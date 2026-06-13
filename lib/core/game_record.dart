/// A completed game, persisted to history.
class GameRecord {
  const GameRecord({
    required this.timestamp,
    required this.won,
    required this.playerClass,
    required this.opponentClass,
    required this.mode,
    required this.format,
    required this.turns,
  });

  final DateTime timestamp;
  final bool won;
  final String playerClass;
  final String opponentClass;
  final String mode; // 'constructed' | 'battlegrounds'
  final String format; // 'standard' | 'wild' | ''
  final int turns;

  Map<String, dynamic> toJson() => {
        'ts': timestamp.toIso8601String(),
        'won': won,
        'class': playerClass,
        'opp': opponentClass,
        'mode': mode,
        'format': format,
        'turns': turns,
      };

  factory GameRecord.fromJson(Map<String, dynamic> j) => GameRecord(
        timestamp: DateTime.parse(j['ts'] as String),
        won: j['won'] as bool,
        playerClass: j['class'] as String? ?? 'UNKNOWN',
        opponentClass: j['opp'] as String? ?? 'UNKNOWN',
        mode: j['mode'] as String? ?? 'constructed',
        format: j['format'] as String? ?? '',
        turns: (j['turns'] as num?)?.toInt() ?? 0,
      );
}

/// Aggregate stats computed from a list of records.
class HistoryStats {
  const HistoryStats({
    required this.total,
    required this.wins,
    required this.losses,
    required this.streak,
    required this.winRateByClass,
  });

  final int total;
  final int wins;
  final int losses;
  final int streak; // positive = win streak, negative = loss streak
  final Map<String, ({int wins, int total})> winRateByClass;

  double get winRate => total == 0 ? 0 : wins / total;

  factory HistoryStats.from(List<GameRecord> games) {
    if (games.isEmpty) {
      return const HistoryStats(
        total: 0, wins: 0, losses: 0, streak: 0, winRateByClass: {},
      );
    }
    final wins = games.where((g) => g.won).length;

    // Streak from most recent game backwards (games assumed newest-first).
    int streak = 0;
    final firstWon = games.first.won;
    for (final g in games) {
      if (g.won == firstWon) {
        streak += firstWon ? 1 : -1;
      } else {
        break;
      }
    }

    final byClass = <String, ({int wins, int total})>{};
    for (final g in games) {
      final prev = byClass[g.playerClass] ?? (wins: 0, total: 0);
      byClass[g.playerClass] = (
        wins: prev.wins + (g.won ? 1 : 0),
        total: prev.total + 1,
      );
    }

    return HistoryStats(
      total: games.length,
      wins: wins,
      losses: games.length - wins,
      streak: streak,
      winRateByClass: byClass,
    );
  }
}
