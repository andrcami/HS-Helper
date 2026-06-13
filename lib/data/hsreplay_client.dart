import 'package:dio/dio.dart';
import 'package:csv/csv.dart';
import 'package:logger/logger.dart';

final _log = Logger();

class CardWinrate {
  const CardWinrate({
    required this.cardId,
    required this.winrate,
    required this.playedCount,
  });
  final String cardId;
  final double winrate;
  final int playedCount;
}

// HSReplay free-tier aggregate winrate data.
// URL pattern: https://hsreplay.net/analytics/query/card_included_popularity_report/
class HsReplayClient {
  HsReplayClient({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  static const _baseUrl = 'https://hsreplay.net/analytics/query';

  // NOTE: HSReplay's analytics query endpoint requires auth and returns JSON,
  // not public CSV. Free-tier programmatic access is not available without login.
  // Disabled until a working free winrate source is wired. Engine falls back to
  // a tempo/mana-curve heuristic when no winrate data exists.
  static const _enabled = false;

  Future<List<CardWinrate>> fetchCardWinrates({
    required String playerClass,
    bool wild = false,
  }) async {
    if (!_enabled) return [];
    final gameType = wild ? 'RANKED_WILD' : 'RANKED_STANDARD';
    final url = '$_baseUrl/card_included_popularity_report/'
        '?GameType=$gameType&RankRange=ALL&TimeRange=LAST_30_DAYS'
        '&player_class=${playerClass.toUpperCase()}';

    try {
      final response = await _dio.get<String>(
        url,
        options: Options(
          headers: {'Accept': 'text/csv'},
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode != 200 || response.data == null) {
        _log.w('HSReplay returned ${response.statusCode}');
        return [];
      }

      return _parseCsv(response.data!);
    } on DioException catch (e) {
      _log.e('HSReplay fetch failed: $e');
      return [];
    }
  }

  List<CardWinrate> _parseCsv(String csv) {
    final rows = const CsvToListConverter().convert(csv, eol: '\n');
    if (rows.isEmpty) return [];

    // Find column indices from header row
    final header = rows.first.map((e) => e.toString().toLowerCase()).toList();
    final idIdx = header.indexOf('dbf_id');
    final wrIdx = header.indexOf('win_rate');
    final countIdx = header.indexOf('total_played');

    if (idIdx < 0 || wrIdx < 0) {
      _log.w('Unexpected HSReplay CSV format');
      return [];
    }

    final results = <CardWinrate>[];
    for (final row in rows.skip(1)) {
      if (row.length <= wrIdx) continue;
      final cardId = row[idIdx].toString();
      final winrate = double.tryParse(row[wrIdx].toString()) ?? 0.0;
      final count = countIdx >= 0
          ? int.tryParse(row[countIdx].toString()) ?? 0
          : 0;
      results.add(CardWinrate(
        cardId: cardId,
        winrate: winrate / 100.0, // HSReplay returns 0–100
        playedCount: count,
      ));
    }
    return results;
  }
}
