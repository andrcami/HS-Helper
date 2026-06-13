import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';
import '../core/log_buffer.dart';
import '../core/recommendation.dart';
import '../data/cache_manager.dart';
import 'recommendation_card.dart';

/// Small reusable status row: spinner + text colored by cache state.
class CacheStatusBar extends StatelessWidget {
  const CacheStatusBar({super.key, required this.status, required this.message});
  final CacheStatus status;
  final String message;

  @override
  Widget build(BuildContext context) {
    if (status == CacheStatus.idle || message.isEmpty) {
      return const SizedBox.shrink();
    }
    final (color, icon) = switch (status) {
      CacheStatus.loading => (Colors.amber, null),
      CacheStatus.ready => (Colors.green, Icons.check_circle_outline),
      CacheStatus.error => (Colors.redAccent, Icons.error_outline),
      CacheStatus.idle => (Colors.white38, null),
    };
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status == CacheStatus.loading)
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.amber),
            )
          else if (icon != null)
            Icon(icon, size: 13, color: color),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              style: TextStyle(color: color, fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    super.key,
    this.onRefresh,
    this.cacheStatus = CacheStatus.idle,
    this.cacheMessage = '',
    this.dashboard,
  });
  final VoidCallback? onRefresh;
  final CacheStatus cacheStatus;
  final String cacheMessage;
  final Widget? dashboard;

  @override
  Widget build(BuildContext context) {
    final loading = cacheStatus == CacheStatus.loading;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top bar: title + HS-not-detected notice + refresh.
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            border: Border(
              bottom: BorderSide(color: Colors.amber.withOpacity(0.15)),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.sports_esports_rounded, size: 22, color: Colors.amber),
              const SizedBox(width: 10),
              const Text(
                'HS Helper',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.circle, size: 7, color: Colors.orange),
              const SizedBox(width: 5),
              const Text('Waiting for Hearthstone',
                  style: TextStyle(color: Colors.orange, fontSize: 11)),
              const Spacer(),
              if (cacheStatus != CacheStatus.idle)
                CacheStatusBar(status: cacheStatus, message: cacheMessage),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: loading ? null : onRefresh,
                icon: loading
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.amber),
                      )
                    : const Icon(Icons.refresh, size: 16, color: Colors.white54),
                label: Text(
                  loading ? 'Updating…' : 'Update DB',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        if (dashboard != null) Expanded(child: dashboard!),
      ],
    );
  }
}

class OverlayContent extends StatefulWidget {
  const OverlayContent({
    super.key,
    required this.recommendations,
    this.onRefresh,
    this.isLoading = false,
    this.logBuffer,
    this.cacheStatus = CacheStatus.idle,
    this.cacheMessage = '',
    this.dashboard,
    this.collectionSize = 0,
  });

  final List<Recommendation> recommendations;
  final VoidCallback? onRefresh;
  final bool isLoading;
  final LogBuffer? logBuffer;
  final CacheStatus cacheStatus;
  final String cacheMessage;
  final Widget? dashboard;
  final int collectionSize;

  @override
  State<OverlayContent> createState() => _OverlayContentState();
}

class _OverlayContentState extends State<OverlayContent> {
  bool _showLog = false;
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showLog) _scrollToBottom();

    return Material(
      color: Colors.transparent,
      child: DragToMoveArea(
        child: Container(
          // Fill the narrow always-on-top window; semi-transparent so HS shows
          // faintly behind it.
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.82),
            border: Border(left: BorderSide(color: Colors.amber.withOpacity(0.18))),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(
                onRefresh: widget.onRefresh,
                isLoading: widget.isLoading ||
                    widget.cacheStatus == CacheStatus.loading,
                showLog: _showLog,
                collectionSize: widget.collectionSize,
                onToggleLog: () => setState(() => _showLog = !_showLog),
              ),
              if (widget.cacheStatus == CacheStatus.loading ||
                  widget.cacheStatus == CacheStatus.error)
                CacheStatusBar(
                  status: widget.cacheStatus,
                  message: widget.cacheMessage,
                ),
              // Body fills remaining height.
              Expanded(
                child: _showLog
                    ? _LogPanel(buffer: widget.logBuffer, scrollCtrl: _scrollCtrl)
                    : widget.recommendations.isEmpty
                        ? (widget.dashboard ?? _EmptyState())
                        : ListView(
                            padding: const EdgeInsets.all(8),
                            children: widget.recommendations
                                .asMap()
                                .entries
                                .map((e) => RecommendationCard(
                                    rec: e.value, rank: e.key + 1))
                                .toList(),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogPanel extends StatefulWidget {
  const _LogPanel({this.buffer, required this.scrollCtrl});
  final LogBuffer? buffer;
  final ScrollController scrollCtrl;

  @override
  State<_LogPanel> createState() => _LogPanelState();
}

class _LogPanelState extends State<_LogPanel> {
  @override
  void initState() {
    super.initState();
    widget.buffer?.addListener(_onLog);
  }

  @override
  void dispose() {
    widget.buffer?.removeListener(_onLog);
    super.dispose();
  }

  void _onLog() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final lines = widget.buffer?.lines ?? [];
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.92),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                const Text('LOG', style: TextStyle(color: Colors.green, fontSize: 10, letterSpacing: 1)),
                const Spacer(),
                Text('${lines.length} lines', style: const TextStyle(color: Colors.white24, fontSize: 9)),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(text: lines.join('\n')));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Logs copied'),
                          duration: Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: const Icon(Icons.copy, color: Colors.white38, size: 13),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => widget.buffer?.clear(),
                  child: const Icon(Icons.delete_outline, color: Colors.white24, size: 13),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white12),
          Expanded(
            child: lines.isEmpty
                ? const Center(child: Text('No log events yet', style: TextStyle(color: Colors.white24, fontSize: 11)))
                : ListView.builder(
                    controller: widget.scrollCtrl,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    itemCount: lines.length,
                    itemBuilder: (_, i) => Text(
                      lines[i],
                      style: TextStyle(
                        color: lines[i].contains('ZONE') ? Colors.greenAccent : Colors.white54,
                        fontSize: 9,
                        fontFamily: 'monospace',
                        height: 1.4,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    this.onRefresh,
    this.isLoading = false,
    this.showLog = false,
    this.collectionSize = 0,
    this.onToggleLog,
  });
  final VoidCallback? onRefresh;
  final bool isLoading;
  final bool showLog;
  final int collectionSize;
  final VoidCallback? onToggleLog;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        children: [
          const Text(
            'HS Helper',
            style: TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          if (collectionSize > 0) ...[
            const Icon(Icons.style_outlined, size: 12, color: Colors.lightBlueAccent),
            const SizedBox(width: 3),
            Text('$collectionSize',
                style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 11)),
            const SizedBox(width: 10),
          ],
          GestureDetector(
            onTap: onToggleLog,
            child: Icon(
              Icons.terminal,
              color: showLog ? Colors.green : Colors.white38,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          if (isLoading)
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.amber),
            )
          else
            GestureDetector(
              onTap: onRefresh,
              child: const Icon(Icons.refresh, color: Colors.white54, size: 16),
            ),
          const SizedBox(width: 12),
          // Frameless window controls.
          GestureDetector(
            onTap: () => windowManager.minimize(),
            child: const Icon(Icons.remove, color: Colors.white38, size: 16),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => windowManager.close(),
            child: const Icon(Icons.close, color: Colors.white38, size: 16),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatefulWidget {
  @override
  State<_EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<_EmptyState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _glow = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.88),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
        border: Border.all(color: Colors.amber.withOpacity(0.15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _glow,
            builder: (_, __) => Icon(
              Icons.sports_esports_rounded,
              size: 40,
              color: Colors.amber.withOpacity(_glow.value),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'HS Helper',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Launch Hearthstone to\nget card recommendations',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 11, height: 1.5),
          ),
          const SizedBox(height: 16),
          _StatusDot(),
        ],
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          'Watching for game...',
          style: TextStyle(color: Colors.white38, fontSize: 10),
        ),
      ],
    );
  }
}
