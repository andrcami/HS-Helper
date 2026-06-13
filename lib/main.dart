import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:window_manager/window_manager.dart';

import 'core/game_state.dart';
import 'core/log_buffer.dart';
import 'core/recommendation.dart';
import 'data/cache_manager.dart';
import 'data/collection_store.dart';
import 'data/deck_store.dart';
import 'data/history_store.dart';
import 'modes/constructed/recommendation_engine.dart';
import 'modes/battlegrounds/bgs_engine.dart';
import 'overlay/dashboard.dart';
import 'overlay/overlay_window.dart';
import 'platform/windows/log_watcher.dart';
import 'platform/windows/power_log_parser.dart';

final _log = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    // Narrow, tall panel that sits on the right edge over Hearthstone.
    const width = 340.0;
    final screen = await windowManager.getBounds();
    final options = WindowOptions(
      size: Size(width, screen.height > 0 ? screen.height : 900),
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden, // frameless — looks like an overlay
      alwaysOnTop: true,
    );
    windowManager.waitUntilReadyToShow(options, () async {
      await windowManager.setAsFrameless();
      await windowManager.setAlwaysOnTop(true);
      // Dock to the top-right of the primary display.
      await windowManager.setAlignment(Alignment.topRight);
      await windowManager.show();
    });
  }

  runApp(const ProviderScope(child: HsHelperApp()));
}

final cacheManagerProvider =
    ChangeNotifierProvider<CacheManager>((ref) => CacheManager());

final logBufferProvider = ChangeNotifierProvider<LogBuffer>((ref) => LogBuffer());

final historyProvider =
    ChangeNotifierProvider<HistoryStore>((ref) => HistoryStore());

final collectionProvider =
    ChangeNotifierProvider<CollectionStore>((ref) => CollectionStore());

final deckStoreProvider =
    ChangeNotifierProvider<DeckStore>((ref) => DeckStore());

final gameStateProvider = StreamProvider<GameState>((ref) {
  if (!Platform.isWindows) return const Stream.empty();
  final watcher = WindowsLogWatcher();
  final history = ref.read(historyProvider);
  final collection = ref.read(collectionProvider);
  final parser = PowerLogParser(
    cache: ref.read(cacheManagerProvider),
    onGameEnd: history.record,
    onCardSeen: collection.see,
  );
  // Persist any newly-seen cards periodically.
  final flushTimer =
      Timer.periodic(const Duration(seconds: 20), (_) => collection.flush());
  ref.onDispose(flushTimer.cancel);
  final logBuf = ref.read(logBufferProvider);
  watcher.start();
  ref.onDispose(watcher.dispose);
  return watcher.lines.map((line) {
    final state = parser.parseLine(line);
    // Only log interesting lines to avoid flooding
    if (line.contains('TAG_CHANGE') && line.contains('ZONE') ||
        line.contains('SHOW_ENTITY') ||
        line.contains('FULL_ENTITY') ||
        line.contains('GameType=')) {
      logBuf.add(line.length > 120 ? '${line.substring(0, 120)}…' : line);
    }
    return state;
  }).where((s) => s != null).cast<GameState>();
});

final recommendationsProvider = Provider<List<Recommendation>>((ref) {
  final gameState = ref.watch(gameStateProvider).valueOrNull;
  final cache = ref.watch(cacheManagerProvider);
  if (gameState == null) return [];
  return gameState.when(
    constructed: (state) => ConstructedEngine(cache: cache).recommend(state),
    battlegrounds: (_) => [], // BGS uses bgsRecommendationsProvider (different type)
    idle: () => [],
  );
});

/// Battlegrounds shop recommendations. Separate provider — BGS actions use a
/// different model (BgsRecommendation) than constructed. UI rendering + the BGS
/// log parser are wired once a real BGS game is captured.
final bgsRecommendationsProvider = Provider<List<BgsRecommendation>>((ref) {
  final gameState = ref.watch(gameStateProvider).valueOrNull;
  final cache = ref.watch(cacheManagerProvider);
  if (gameState == null) return [];
  return gameState.when(
    constructed: (_) => [],
    battlegrounds: (state) => BgsEngine(cache: cache).recommend(state),
    idle: () => [],
  );
});

class HsHelperApp extends ConsumerWidget {
  const HsHelperApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const MaterialApp(
      title: 'HS Helper',
      debugShowCheckedModeBanner: false,
      home: _MainOverlay(),
    );
  }
}

class _MainOverlay extends ConsumerStatefulWidget {
  const _MainOverlay();

  @override
  ConsumerState<_MainOverlay> createState() => _MainOverlayState();
}

class _MainOverlayState extends ConsumerState<_MainOverlay> {
  bool _hsRunning = false;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _initCache();
    _checkHs();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) => _checkHs());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _initCache() async {
    await ref.read(historyProvider).load();
    await ref.read(collectionProvider).load();
    await ref.read(deckStoreProvider).load();
    final cache = ref.read(cacheManagerProvider);
    await cache.load();
    await cache.refreshIfStale();
  }

  void _checkHs() {
    final running = _isHearthstoneRunning();
    if (mounted) setState(() => _hsRunning = running);
  }

  bool _isHearthstoneRunning() {
    try {
      final result = Process.runSync(
        'powershell',
        ['-Command', 'Get-Process -Name Hearthstone -ErrorAction SilentlyContinue | Measure-Object | Select-Object -ExpandProperty Count'],
      );
      final count = int.tryParse(result.stdout.toString().trim()) ?? 0;
      _log.i('HS process count: $count');
      return count > 0;
    } catch (e) {
      _log.e('process check error: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final recs = ref.watch(recommendationsProvider);
    // NOTE: do NOT use gameStateProvider.isLoading for the spinner — a tailing
    // log stream stays "loading" until its first emit (i.e. until a card is
    // drawn), so it would spin forever in menus. Only cache download shows a
    // spinner (handled via cacheStatus in OverlayContent/SplashScreen).
    const isLoading = false;
    final cache = ref.watch(cacheManagerProvider);
    final logBuf = ref.watch(logBufferProvider);
    final history = ref.watch(historyProvider);
    final collection = ref.watch(collectionProvider);
    final deckStore = ref.watch(deckStoreProvider);

    final dashboard = Dashboard(
      stats: history.stats,
      last5: history.last5,
      sessionGames: history.sessionGames,
      sessionWins: history.sessionWins,
      cardCount: cache.cardCount,
      collection: collection,
      cache: cache,
      deckStore: deckStore,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _hsRunning
          ? OverlayContent(
              recommendations: recs,
              isLoading: isLoading,
              logBuffer: logBuf,
              cacheStatus: cache.status,
              cacheMessage: cache.statusMessage,
              dashboard: dashboard,
              collectionSize: collection.uniqueCards,
              onRefresh: () => cache.refresh(),
            )
          : SplashScreen(
              cacheStatus: cache.status,
              cacheMessage: cache.statusMessage,
              dashboard: dashboard,
              onRefresh: () => cache.refresh(),
            ),
    );
  }
}
