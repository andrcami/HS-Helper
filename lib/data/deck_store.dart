import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';

final _log = Logger();

/// A deck the user saved, sourced from a pasted deckstring (Hearthpwn,
/// YouTube descriptions, own exports, etc).
class SavedDeck {
  const SavedDeck({
    required this.name,
    required this.playerClass,
    required this.code,
    this.note = '',
  });

  final String name;
  final String playerClass;
  final String code; // deckstring
  final String note; // optional source / tier label

  Map<String, dynamic> toJson() => {
        'name': name,
        'class': playerClass,
        'code': code,
        'note': note,
      };

  factory SavedDeck.fromJson(Map<String, dynamic> j) => SavedDeck(
        name: j['name'] as String? ?? 'Deck',
        playerClass: j['class'] as String? ?? 'UNKNOWN',
        code: j['code'] as String? ?? '',
        note: j['note'] as String? ?? '',
      );
}

/// Persistent shelf of user-added decks. Feeds the dashboard Meta/Decks panel.
class DeckStore extends ChangeNotifier {
  List<SavedDeck> _decks = [];
  List<SavedDeck> get decks => List.unmodifiable(_decks);

  Future<void> load() async {
    try {
      final file = await _file();
      if (!file.existsSync()) return;
      final list = jsonDecode(await file.readAsString()) as List<dynamic>;
      _decks = list
          .map((e) => SavedDeck.fromJson(e as Map<String, dynamic>))
          .toList();
      _log.i('Decks loaded: ${_decks.length}');
      notifyListeners();
    } catch (e) {
      _log.e('Deck load failed: $e');
    }
  }

  Future<void> add(SavedDeck deck) async {
    _decks.insert(0, deck);
    notifyListeners();
    await _persist();
  }

  Future<void> removeAt(int index) async {
    if (index < 0 || index >= _decks.length) return;
    _decks.removeAt(index);
    notifyListeners();
    await _persist();
  }

  Future<void> _persist() async {
    try {
      final file = await _file();
      await file.writeAsString(jsonEncode(_decks.map((d) => d.toJson()).toList()));
    } catch (e) {
      _log.e('Deck persist failed: $e');
    }
  }

  Future<File> _file() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/hs_decks.json');
  }
}
