import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import '../core/game_record.dart';

final _log = Logger();

/// Persists completed games to a JSON file, newest-first. Also tracks
/// this-session counters (reset on app restart).
class HistoryStore extends ChangeNotifier {
  static const _maxGames = 100;

  List<GameRecord> _games = []; // newest first
  List<GameRecord> get games => List.unmodifiable(_games);

  // Session counters (not persisted).
  int sessionGames = 0;
  int sessionWins = 0;
  int sessionCardsSeen = 0;

  HistoryStats get stats => HistoryStats.from(_games);
  List<GameRecord> get last5 => _games.take(5).toList();

  Future<void> load() async {
    try {
      final file = await _file();
      if (!file.existsSync()) return;
      final list = jsonDecode(await file.readAsString()) as List<dynamic>;
      _games = list
          .map((e) => GameRecord.fromJson(e as Map<String, dynamic>))
          .toList();
      _log.i('History loaded: ${_games.length} games');
      notifyListeners();
    } catch (e) {
      _log.e('History load failed: $e');
    }
  }

  Future<void> record(GameRecord game) async {
    _games.insert(0, game);
    if (_games.length > _maxGames) {
      _games = _games.sublist(0, _maxGames);
    }
    sessionGames++;
    if (game.won) sessionWins++;
    _log.i('Game recorded: ${game.won ? "WIN" : "LOSS"} as ${game.playerClass} '
        'vs ${game.opponentClass} (${game.turns} turns)');
    notifyListeners();
    await _persist();
  }

  void bumpCardsSeen([int n = 1]) {
    sessionCardsSeen += n;
    notifyListeners();
  }

  Future<void> _persist() async {
    try {
      final file = await _file();
      await file.writeAsString(jsonEncode(_games.map((g) => g.toJson()).toList()));
    } catch (e) {
      _log.e('History persist failed: $e');
    }
  }

  Future<File> _file() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/hs_history.json');
  }
}
