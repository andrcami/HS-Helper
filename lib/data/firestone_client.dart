import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

final _log = Logger();

class BgsTierEntry {
  const BgsTierEntry({
    required this.cardId,
    required this.tier,
    required this.name,
  });
  final String cardId;
  final int tier; // 1 = best, 6 = worst
  final String name;
}

// Firestone (Zero-to-Heroes) Battlegrounds card stats.
// Live CDN endpoint (gzipped JSON, served with Content-Encoding so Dio
// transparently decompresses). %mmrPercentile%: 100=all, 50, 25, 10, 1.
// %timePeriod%: last-patch | past-three | past-seven.
// Structure: { cardStats: [ { cardId, totalPlayed, averagePlacement, ... } ] }
// Lower averagePlacement = stronger (1st place is best of 8).
class FirestoneClient {
  FirestoneClient({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(connectTimeout: const Duration(seconds: 10)));

  final Dio _dio;

  static const _cardStatsUrl =
      'https://static.zerotoheroes.com/api/bgs/card-stats/'
      'mmr-100/last-patch/overview-from-hourly.gz.json';

  Future<List<BgsTierEntry>> fetchTierList() async {
    try {
      final response = await _dio.get<dynamic>(
        _cardStatsUrl,
        options: Options(
          responseType: ResponseType.json,
          receiveTimeout: const Duration(seconds: 20),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode != 200 || response.data == null) {
        _log.w('Firestone returned ${response.statusCode}');
        return [];
      }

      final data = response.data is String
          ? jsonDecode(response.data as String)
          : response.data;
      return _parse(data as Map<String, dynamic>);
    } on DioException catch (e) {
      _log.e('Firestone fetch failed: $e');
      return [];
    }
  }

  List<BgsTierEntry> _parse(Map<String, dynamic> data) {
    final stats = data['cardStats'] as List<dynamic>? ?? [];
    final results = <BgsTierEntry>[];
    for (final item in stats) {
      if (item is! Map<String, dynamic>) continue;
      final cardId = item['cardId']?.toString() ?? '';
      if (cardId.isEmpty) continue;
      final avg = (item['averagePlacement'] as num?)?.toDouble() ?? 4.5;
      results.add(BgsTierEntry(
        cardId: cardId,
        tier: _tierFromPlacement(avg),
        name: cardId, // card-stats feed has no display name; resolved via CardDB
      ));
    }
    _log.i('Firestone BGS card stats: ${results.length} minions');
    return results;
  }

  // Map average placement (1=best .. 8=worst) to a 1–6 tier bucket.
  static int _tierFromPlacement(double avg) {
    if (avg <= 3.2) return 1;
    if (avg <= 3.7) return 2;
    if (avg <= 4.1) return 3;
    if (avg <= 4.5) return 4;
    if (avg <= 5.0) return 5;
    return 6;
  }
}
