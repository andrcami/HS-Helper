import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../core/game_state.dart';

final _log = Logger();

/// Static card metadata from HearthstoneJSON (free, no auth).
class CardMeta {
  const CardMeta({
    required this.cardId,
    required this.dbfId,
    required this.name,
    required this.cost,
    required this.type,
    required this.rarity,
    required this.cardClass,
    required this.text,
  });

  final String cardId;
  final int dbfId;
  final String name;
  final int cost;
  final CardType type;
  final Rarity rarity;
  final String cardClass;
  final String text;
}

/// Fetches the full collectible card database from HearthstoneJSON.
/// https://api.hearthstonejson.com/v1/latest/enUS/cards.collectible.json
class CardDbClient {
  CardDbClient({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(connectTimeout: const Duration(seconds: 10)));
  final Dio _dio;

  static const _url =
      'https://api.hearthstonejson.com/v1/latest/enUS/cards.collectible.json';

  Future<List<CardMeta>> fetchAll() async {
    try {
      final res = await _dio.get<List<dynamic>>(
        _url,
        options: Options(receiveTimeout: const Duration(seconds: 30)),
      );
      if (res.statusCode != 200 || res.data == null) {
        _log.w('CardDB returned ${res.statusCode}');
        return [];
      }
      final cards = <CardMeta>[];
      for (final raw in res.data!) {
        final m = raw as Map<String, dynamic>;
        final id = m['id'] as String?;
        if (id == null) continue;
        cards.add(CardMeta(
          cardId: id,
          dbfId: (m['dbfId'] as num?)?.toInt() ?? 0,
          name: m['name'] as String? ?? id,
          cost: (m['cost'] as num?)?.toInt() ?? 0,
          type: _parseType(m['type'] as String?),
          rarity: _parseRarity(m['rarity'] as String?),
          cardClass: m['cardClass'] as String? ?? 'NEUTRAL',
          text: m['text'] as String? ?? '',
        ));
      }
      _log.i('CardDB loaded: ${cards.length} cards');
      return cards;
    } on DioException catch (e) {
      _log.e('CardDB fetch failed: $e');
      return [];
    }
  }

  static CardType _parseType(String? t) {
    switch (t) {
      case 'MINION':
        return CardType.minion;
      case 'SPELL':
        return CardType.spell;
      case 'WEAPON':
        return CardType.weapon;
      case 'HERO':
        return CardType.hero;
      case 'HERO_POWER':
        return CardType.heropower;
      default:
        return CardType.minion;
    }
  }

  static Rarity _parseRarity(String? r) {
    switch (r) {
      case 'LEGENDARY':
        return Rarity.legendary;
      case 'EPIC':
        return Rarity.epic;
      case 'RARE':
        return Rarity.rare;
      case 'COMMON':
        return Rarity.common;
      default:
        return Rarity.common;
    }
  }
}
