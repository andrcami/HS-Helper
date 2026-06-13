import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';

final _log = Logger();

/// Growing approximation of the player's card collection, built from logs.
///
/// Sources (all log-based, no auth/memory reading):
///  1. Cards the local player draws/plays in games
///  2. Cards revealed while browsing the Collection screen
///  3. Cards in decks the player opens/edits
///
/// Stores the max copies seen per cardId. This UNDERCOUNTS — a card you own but
/// have never seen in any of these contexts won't appear. It only grows.
class CollectionStore extends ChangeNotifier {
  final Map<String, int> _owned = {}; // cardId -> copies seen
  bool _dirty = false;
  int _sinceFlush = 0;

  int get uniqueCards => _owned.length;
  Map<String, int> get owned => Map.unmodifiable(_owned);

  bool has(String cardId) => _owned.containsKey(cardId);
  int copies(String cardId) => _owned[cardId] ?? 0;

  /// Record seeing [count] copies of [cardId]. Keeps the max ever seen.
  /// Filters out non-collectible cardIds: tokens/enchants end in a lowercase
  /// letter (e.g. RLK_958e, CATA_158t) — collectible cards do not.
  void see(String cardId, {int count = 1}) {
    if (cardId.isEmpty) return;
    if (!RegExp(r'^[A-Z]+_\d+[a-z]?$|^[A-Z]+_\d+$').hasMatch(cardId)) {
      // not a base collectible id shape — but allow common prefixes anyway if
      // it has no lowercase suffix.
    }
    // Reject enchant/token: ends with a single lowercase letter after digits.
    if (RegExp(r'\d[a-z]$|\d[a-z]\d?$').hasMatch(cardId)) return;
    if (!cardId.contains('_')) return;

    final prev = _owned[cardId] ?? 0;
    if (count > prev || prev == 0) {
      _owned[cardId] = count > prev ? count : (prev == 0 ? count : prev);
      _dirty = true;
      _sinceFlush++;
      notifyListeners();
      // Persist eagerly after a handful of new cards so the file appears fast
      // and survives a crash mid-game.
      if (_sinceFlush >= 5) {
        _sinceFlush = 0;
        flush();
      }
    }
  }

  /// How many of [deckCardIds] (cardId list, with repeats for 2-ofs) are owned.
  ({int have, int total}) coverage(List<String> deckCardIds) {
    final need = <String, int>{};
    for (final id in deckCardIds) {
      need[id] = (need[id] ?? 0) + 1;
    }
    int have = 0;
    int total = 0;
    need.forEach((id, n) {
      total += n;
      have += copies(id).clamp(0, n);
    });
    return (have: have, total: total);
  }

  Future<void> load() async {
    try {
      final file = await _file();
      if (!file.existsSync()) return;
      final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      _owned
        ..clear()
        ..addAll(json.map((k, v) => MapEntry(k, (v as num).toInt())));
      _log.i('Collection loaded: ${_owned.length} unique cards');
      notifyListeners();
    } catch (e) {
      _log.e('Collection load failed: $e');
    }
  }

  /// Persist if changed. Call periodically / on dispose.
  Future<void> flush() async {
    if (!_dirty) return;
    try {
      final file = await _file();
      await file.writeAsString(jsonEncode(_owned));
      _dirty = false;
    } catch (e) {
      _log.e('Collection persist failed: $e');
    }
  }

  Future<File> _file() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/hs_collection.json');
  }
}
