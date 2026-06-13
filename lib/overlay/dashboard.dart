import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/game_record.dart';
import '../core/deckstring.dart';
import '../data/collection_store.dart';
import '../data/cache_manager.dart';
import '../data/deck_store.dart';

/// Idle dashboard: session stats, last games, win-rate by class, meta decks.
class Dashboard extends StatelessWidget {
  const Dashboard({
    super.key,
    required this.stats,
    required this.last5,
    required this.sessionGames,
    required this.sessionWins,
    required this.cardCount,
    required this.collection,
    required this.cache,
    required this.deckStore,
  });

  final HistoryStats stats;
  final List<GameRecord> last5;
  final int sessionGames;
  final int sessionWins;
  final int cardCount;
  final CollectionStore collection;
  final CacheManager cache;
  final DeckStore deckStore;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SessionCard(games: sessionGames, wins: sessionWins),
          const SizedBox(height: 10),
          _OverallCard(stats: stats),
          const SizedBox(height: 10),
          _LastGamesCard(games: last5),
          const SizedBox(height: 10),
          _ClassWinRateCard(stats: stats),
          const SizedBox(height: 10),
          _DeckShelfCard(
              deckStore: deckStore, collection: collection, cache: cache),
          const SizedBox(height: 10),
          _CardDbCard(cardCount: cardCount, collectionSize: collection.uniqueCards),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.icon, required this.child});
  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.amber.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: Colors.amber.withOpacity(0.8)),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: Colors.amber.withOpacity(0.8),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, this.color});
  final String value;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color ?? Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
      ],
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.games, required this.wins});
  final int games;
  final int wins;

  @override
  Widget build(BuildContext context) {
    final losses = games - wins;
    return _Panel(
      title: 'THIS SESSION',
      icon: Icons.bolt,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Stat(value: '$games', label: 'games'),
          _Stat(value: '$wins', label: 'wins', color: Colors.green),
          _Stat(value: '$losses', label: 'losses', color: Colors.redAccent),
        ],
      ),
    );
  }
}

class _OverallCard extends StatelessWidget {
  const _OverallCard({required this.stats});
  final HistoryStats stats;

  @override
  Widget build(BuildContext context) {
    final wr = (stats.winRate * 100).toStringAsFixed(0);
    final streakLabel = stats.streak == 0
        ? '—'
        : stats.streak > 0
            ? '${stats.streak}W'
            : '${-stats.streak}L';
    final streakColor = stats.streak >= 0 ? Colors.green : Colors.redAccent;
    return _Panel(
      title: 'OVERALL  (${stats.total} games)',
      icon: Icons.insights,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Stat(value: stats.total == 0 ? '—' : '$wr%', label: 'win rate'),
          _Stat(value: '${stats.wins}', label: 'wins', color: Colors.green),
          _Stat(value: streakLabel, label: 'streak', color: streakColor),
        ],
      ),
    );
  }
}

class _LastGamesCard extends StatelessWidget {
  const _LastGamesCard({required this.games});
  final List<GameRecord> games;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: 'LAST GAMES',
      icon: Icons.history,
      child: games.isEmpty
          ? const Text('No games recorded yet',
              style: TextStyle(color: Colors.white38, fontSize: 11))
          : Column(
              children: games
                  .map((g) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: g.won ? Colors.green : Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              g.won ? 'WIN' : 'LOSS',
                              style: TextStyle(
                                color: g.won ? Colors.green : Colors.redAccent,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${g.playerClass} vs ${g.opponentClass}',
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 11),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text('${g.turns}t',
                                style: const TextStyle(
                                    color: Colors.white30, fontSize: 10)),
                          ],
                        ),
                      ))
                  .toList(),
            ),
    );
  }
}

class _ClassWinRateCard extends StatelessWidget {
  const _ClassWinRateCard({required this.stats});
  final HistoryStats stats;

  @override
  Widget build(BuildContext context) {
    final entries = stats.winRateByClass.entries.toList()
      ..sort((a, b) => b.value.total.compareTo(a.value.total));
    return _Panel(
      title: 'WIN RATE BY CLASS',
      icon: Icons.shield_outlined,
      child: entries.isEmpty
          ? const Text('Play games to build stats',
              style: TextStyle(color: Colors.white38, fontSize: 11))
          : Column(
              children: entries.map((e) {
                final pct = e.value.total == 0
                    ? 0.0
                    : e.value.wins / e.value.total;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 90,
                        child: Text(e.key,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 11)),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: pct,
                            minHeight: 6,
                            backgroundColor: Colors.white12,
                            color: pct >= 0.5 ? Colors.green : Colors.orange,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${(pct * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 10)),
                      Text(' (${e.value.total})',
                          style: const TextStyle(
                              color: Colors.white24, fontSize: 10)),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }
}

class _DeckShelfCard extends StatelessWidget {
  const _DeckShelfCard({
    required this.deckStore,
    required this.collection,
    required this.cache,
  });
  final DeckStore deckStore;
  final CollectionStore collection;
  final CacheManager cache;

  ({int have, int total})? _coverage(String code) {
    final decoded = Deckstring.decode(code);
    if (decoded == null || !cache.hasCardDb) return null;
    final cardIds = <String>[];
    for (final dbf in decoded.cards) {
      final id = cache.cardIdForDbf(dbf);
      if (id != null) cardIds.add(id);
    }
    if (cardIds.isEmpty) return null;
    return collection.coverage(cardIds);
  }

  @override
  Widget build(BuildContext context) {
    final decks = deckStore.decks;
    return _Panel(
      title: 'MY DECKS',
      icon: Icons.style,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Paste deck codes from Hearthpwn, YouTube, or your own '
                  'exports. Owned counts approximate (cards seen so far).',
                  style: TextStyle(color: Colors.white30, fontSize: 9, height: 1.4),
                ),
              ),
              const SizedBox(width: 6),
              TextButton.icon(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => _showAddDialog(context),
                icon: const Icon(Icons.add, size: 14, color: Colors.amber),
                label: const Text('Add',
                    style: TextStyle(color: Colors.amber, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (decks.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text('No decks yet — hit Add to paste a deck code',
                  style: TextStyle(color: Colors.white38, fontSize: 11)),
            )
          else
            ...decks.asMap().entries.map((e) => _DeckRow(
                  deck: e.value,
                  coverage: _coverage(e.value.code),
                  onDelete: () => deckStore.removeAt(e.key),
                )),
        ],
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context) async {
    final codeCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    String? error;

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text('Add deck',
              style: TextStyle(color: Colors.amber, fontSize: 16)),
          content: SizedBox(
            width: 340,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _field(nameCtrl, 'Deck name (e.g. Rainbow DK)'),
                const SizedBox(height: 8),
                _field(noteCtrl, 'Note / source (optional, e.g. Tier 1)'),
                const SizedBox(height: 8),
                _field(codeCtrl, 'Deck code (paste deckstring)', lines: 3),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(error!,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 11)),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.white54)),
            ),
            TextButton(
              onPressed: () {
                final code = codeCtrl.text.trim();
                final decoded = Deckstring.decode(code);
                if (decoded == null) {
                  setState(() => error = 'Invalid deck code — check you pasted the full string');
                  return;
                }
                // Derive class from hero dbfId if name omitted.
                final heroCardId = cache.cardIdForDbf(decoded.heroDbfId);
                final heroClass =
                    heroCardId != null ? (cache.card(heroCardId)?.cardClass ?? '') : '';
                deckStore.add(SavedDeck(
                  name: nameCtrl.text.trim().isEmpty
                      ? (heroClass.isEmpty ? 'Deck' : heroClass)
                      : nameCtrl.text.trim(),
                  playerClass: heroClass.isEmpty ? 'UNKNOWN' : _titleCase(heroClass),
                  code: code,
                  note: noteCtrl.text.trim(),
                ));
                Navigator.pop(ctx);
              },
              child: const Text('Save', style: TextStyle(color: Colors.amber)),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _field(TextEditingController c, String hint, {int lines = 1}) {
    return TextField(
      controller: c,
      maxLines: lines,
      style: const TextStyle(color: Colors.white, fontSize: 12),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white30, fontSize: 12),
        isDense: true,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber),
        ),
      ),
    );
  }

  static String _titleCase(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();
}

class _DeckRow extends StatelessWidget {
  const _DeckRow({
    required this.deck,
    required this.coverage,
    required this.onDelete,
  });
  final SavedDeck deck;
  final ({int have, int total})? coverage;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final cov = coverage;
    final complete = cov != null && cov.have >= cov.total;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deck.note.isEmpty
                      ? '${deck.name}  ·  ${deck.playerClass}'
                      : '${deck.name}  ·  ${deck.playerClass}  ·  ${deck.note}',
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
                if (cov != null)
                  Text(
                    complete
                        ? 'You own all ${cov.total} cards ✓'
                        : '${cov.have}/${cov.total} cards owned (seen)',
                    style: TextStyle(
                      color: complete ? Colors.green : Colors.white38,
                      fontSize: 9,
                    ),
                  )
                else
                  const Text('decode pending (card DB loading)',
                      style: TextStyle(color: Colors.white24, fontSize: 9)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: deck.code));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${deck.name} code copied — paste in HS deck import'),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Icon(Icons.copy, size: 14, color: Colors.white54),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(Icons.close, size: 14, color: Colors.white24),
          ),
        ],
      ),
    );
  }
}

class _CardDbCard extends StatelessWidget {
  const _CardDbCard({required this.cardCount, required this.collectionSize});
  final int cardCount;
  final int collectionSize;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: 'DATA',
      icon: Icons.storage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                cardCount > 0 ? Icons.check_circle_outline : Icons.cloud_download_outlined,
                size: 14,
                color: cardCount > 0 ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 8),
              Text(
                cardCount > 0
                    ? '$cardCount cards (HearthstoneJSON)'
                    : 'Card DB not downloaded — hit refresh',
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.style_outlined, size: 14, color: Colors.lightBlueAccent),
              const SizedBox(width: 8),
              Text(
                'Your collection: $collectionSize cards seen',
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4, left: 22),
            child: Text(
              'Grows as you play & browse Collection',
              style: TextStyle(color: Colors.white24, fontSize: 9),
            ),
          ),
        ],
      ),
    );
  }
}
