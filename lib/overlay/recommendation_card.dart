import 'package:flutter/material.dart';
import '../core/recommendation.dart';

class RecommendationCard extends StatelessWidget {
  const RecommendationCard({super.key, required this.rec, required this.rank});

  final Recommendation rec;
  final int rank;

  Color get _scoreColor {
    if (rec.isLethal) return Colors.red;
    if (rec.type == ActionType.endTurn) return Colors.blueGrey;
    if (rec.score >= 0.7) return Colors.green;
    if (rec.score >= 0.4) return Colors.yellow;
    return Colors.red.shade300;
  }

  IconData get _typeIcon => switch (rec.type) {
        ActionType.playCard => Icons.style,
        ActionType.heroPower => Icons.auto_awesome,
        ActionType.attack => Icons.gps_fixed,
        ActionType.endTurn => Icons.skip_next,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.82),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _scoreColor, width: rec.isLethal ? 2 : 1),
      ),
      child: Row(
        children: [
          // Rank badge
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _scoreColor.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: _scoreColor),
            ),
            child: Text(
              '$rank',
              style: TextStyle(
                  color: _scoreColor, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          // Action type icon
          Icon(_typeIcon, size: 16, color: _scoreColor.withOpacity(0.9)),
          const SizedBox(width: 8),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (rec.isLethal)
                  const Text(
                    'LETHAL',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 1.2,
                    ),
                  ),
                Text(
                  rec.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  rec.reason,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.6), fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Score badge (hide for end turn)
          if (rec.type != ActionType.endTurn)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _scoreColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                rec.isLethal ? '!' : '${(rec.score * 100).round()}%',
                style: TextStyle(
                  color: _scoreColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
