import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:logger/logger.dart';
import '../core/game_state.dart';
import 'hsreplay_client.dart';
import 'firestone_client.dart';
import 'card_db_client.dart';

final _log = Logger();

// Card data changes ~monthly (new sets / balance patches). Cache for 30 days.
const _cacheMaxAgeDays = 30;

enum CacheStatus { idle, loading, ready, error }

class CacheManager extends ChangeNotifier {
  CacheManager({
    HsReplayClient? hsreplay,
    FirestoneClient? firestone,
    CardDbClient? cardDb,
  })  : _hsreplay = hsreplay ?? HsReplayClient(),
        _firestone = firestone ?? FirestoneClient(),
        _cardDb = cardDb ?? CardDbClient();

  final HsReplayClient _hsreplay;
  final FirestoneClient _firestone;
  final CardDbClient _cardDb;

  Map<String, CardWinrate> _winrateCache = {};
  Map<String, BgsTierEntry> _tierCache = {};
  Map<String, CardMeta> _cardMeta = {};
  DateTime? _lastRefresh;

  CacheStatus _status = CacheStatus.idle;
  String _statusMessage = '';
  CacheStatus get status => _status;
  String get statusMessage => _statusMessage;
  DateTime? get lastRefresh => _lastRefresh;
  int get cardCount => _cardMeta.length;

  void _setStatus(CacheStatus s, String msg) {
    _status = s;
    _statusMessage = msg;
    notifyListeners();
  }

  bool get isStale =>
      _lastRefresh == null ||
      DateTime.now().difference(_lastRefresh!).inDays >= _cacheMaxAgeDays;

  Future<void> refreshIfStale({String playerClass = 'NEUTRAL'}) async {
    // Always refresh if the card DB is missing — needed for cost/type lookup.
    // If the card DB is already loaded from disk, don't re-download on every
    // launch — that caused a multi-second spinner each start. Only refresh when
    // the DB is genuinely missing or the cache is stale (>30 days).
    if (hasCardDb && !isStale) {
      _setStatus(CacheStatus.ready, '${_cardMeta.length} cards cached');
      return;
    }
    await refresh(playerClass: playerClass);
  }

  Future<void> refresh({String playerClass = 'NEUTRAL'}) async {
    _log.i('Refreshing data cache...');
    _setStatus(CacheStatus.loading, 'Downloading card database…');
    try {
      final results = await Future.wait([
        _hsreplay.fetchCardWinrates(playerClass: playerClass),
        _hsreplay.fetchCardWinrates(playerClass: playerClass, wild: true),
        _firestone.fetchTierList(),
        _cardDb.fetchAll(),
      ]).timeout(
        const Duration(seconds: 45),
        onTimeout: () {
          _log.w('Refresh timed out — using whatever is cached');
          return [<CardWinrate>[], <CardWinrate>[], <BgsTierEntry>[], <CardMeta>[]];
        },
      );

      final standardWinrates = results[0] as List<CardWinrate>;
      final wildWinrates = results[1] as List<CardWinrate>;
      final tierList = results[2] as List<BgsTierEntry>;
      final cards = results[3] as List<CardMeta>;

      _winrateCache = {
        for (final w in [...standardWinrates, ...wildWinrates]) w.cardId: w,
      };
      _tierCache = {for (final t in tierList) t.cardId: t};
      if (cards.isNotEmpty) {
        _cardMeta = {for (final c in cards) c.cardId: c};
        _dbfToCardId = null;
      }
      _lastRefresh = DateTime.now();

      await _persist();
      await _persistCardDb();
      _log.i('Cache refreshed: ${_winrateCache.length} winrates, '
          '${_tierCache.length} BGS, ${_cardMeta.length} cards');

      if (_cardMeta.isEmpty) {
        _setStatus(CacheStatus.error, 'Card download failed — check connection');
      } else {
        _setStatus(CacheStatus.ready, '${_cardMeta.length} cards updated');
      }
    } catch (e) {
      _log.e('Cache refresh failed: $e');
      _setStatus(
        hasCardDb ? CacheStatus.ready : CacheStatus.error,
        'Update failed: $e',
      );
    }
  }

  CardWinrate? winrate(String cardId) => _winrateCache[cardId];
  BgsTierEntry? tier(String cardId) => _tierCache[cardId];
  CardMeta? card(String cardId) => _cardMeta[cardId];
  List<String> cardMechanics(String cardId) => _cardMeta[cardId]?.mechanics ?? const [];
  bool get hasCardDb => _cardMeta.isNotEmpty;

  // dbfId → cardId, built lazily from card metadata (for deckstring decoding).
  Map<int, String>? _dbfToCardId;
  String? cardIdForDbf(int dbfId) {
    _dbfToCardId ??= {
      for (final c in _cardMeta.values) c.dbfId: c.cardId,
    };
    return _dbfToCardId![dbfId];
  }

  Future<void> _persist() async {
    try {
      final dir = await getApplicationSupportDirectory();
      final file = File('${dir.path}/hs_cache.json');
      await file.writeAsString(jsonEncode({
        'lastRefresh': _lastRefresh?.toIso8601String(),
        'winrates': {
          for (final e in _winrateCache.entries)
            e.key: {'winrate': e.value.winrate, 'count': e.value.playedCount},
        },
        'tiers': {
          for (final e in _tierCache.entries)
            e.key: {'tier': e.value.tier, 'name': e.value.name},
        },
      }));
    } catch (e) {
      _log.e('Cache persist failed: $e');
    }
  }

  Future<void> _persistCardDb() async {
    if (_cardMeta.isEmpty) return;
    try {
      final dir = await getApplicationSupportDirectory();
      final file = File('${dir.path}/hs_carddb.json');
      await file.writeAsString(jsonEncode({
        for (final e in _cardMeta.entries)
          e.key: {
            'dbfId': e.value.dbfId,
            'name': e.value.name,
            'cost': e.value.cost,
            'type': e.value.type.index,
            'rarity': e.value.rarity.index,
            'class': e.value.cardClass,
            'text': e.value.text,
            'mech': e.value.mechanics,
          },
      }));
    } catch (e) {
      _log.e('CardDB persist failed: $e');
    }
  }

  Future<void> _loadCardDb() async {
    try {
      final dir = await getApplicationSupportDirectory();
      final file = File('${dir.path}/hs_carddb.json');
      if (!file.existsSync()) return;
      // Use the card DB file's own modified time as the freshness anchor — the
      // separate hs_cache.json can be missing/stale even when the DB is current.
      if (_lastRefresh == null) {
        _lastRefresh = file.lastModifiedSync();
      }
      final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      _cardMeta = {
        for (final e in json.entries)
          e.key: CardMeta(
            cardId: e.key,
            dbfId: (e.value['dbfId'] as num).toInt(),
            name: e.value['name'] as String,
            cost: (e.value['cost'] as num).toInt(),
            type: CardType.values[(e.value['type'] as num).toInt()],
            rarity: Rarity.values[(e.value['rarity'] as num).toInt()],
            cardClass: e.value['class'] as String? ?? 'NEUTRAL',
            text: e.value['text'] as String? ?? '',
            mechanics: (e.value['mech'] as List<dynamic>?)
                    ?.map((x) => x.toString())
                    .toList() ??
                const [],
          ),
      };
      _dbfToCardId = null;
      _log.i('CardDB loaded from disk: ${_cardMeta.length} cards');
    } catch (e) {
      _log.e('CardDB load failed: $e');
    }
  }

  Future<void> load() async {
    await _loadCardDb();
    try {
      final dir = await getApplicationSupportDirectory();
      final file = File('${dir.path}/hs_cache.json');
      if (!file.existsSync()) return;
      final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      _lastRefresh = json['lastRefresh'] != null
          ? DateTime.parse(json['lastRefresh'] as String)
          : null;
      final winrates = json['winrates'] as Map<String, dynamic>? ?? {};
      _winrateCache = {
        for (final e in winrates.entries)
          e.key: CardWinrate(
            cardId: e.key,
            winrate: (e.value['winrate'] as num).toDouble(),
            playedCount: (e.value['count'] as num).toInt(),
          ),
      };
      final tiers = json['tiers'] as Map<String, dynamic>? ?? {};
      _tierCache = {
        for (final e in tiers.entries)
          e.key: BgsTierEntry(
            cardId: e.key,
            tier: (e.value['tier'] as num).toInt(),
            name: e.value['name'] as String,
          ),
      };
      _log.i('Cache loaded from disk');
    } catch (e) {
      _log.e('Cache load failed: $e');
    }
  }
}
