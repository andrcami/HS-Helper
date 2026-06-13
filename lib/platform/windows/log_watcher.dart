import 'dart:async';
import 'dart:io';
import 'package:logger/logger.dart';
import '../../core/interfaces/log_source.dart';

final _log = Logger();

class WindowsLogWatcher implements LogSource {
  WindowsLogWatcher({String? logPath, this.onTruncationFreeze})
      : _logPath = logPath ?? _defaultLogPath();

  /// Fired when HS hits the 10MB cap and stops writing (the "Truncating log"
  /// marker is the last line + no further writes). Only a HS restart recovers.
  final void Function()? onTruncationFreeze;

  // Set true after we read the truncation marker; if no new bytes arrive for a
  // while afterward, we consider the log frozen and notify once.
  bool _sawTruncateMarker = false;
  bool _frozenNotified = false;
  DateTime? _lastDataAt;

  static String _defaultLogPath() {
    const logsBase = r'C:\Program Files (x86)\Hearthstone\Logs';
    final logsDir = Directory(logsBase);
    if (!logsDir.existsSync()) return '$logsBase\\Power.log';
    // Find most recent session subfolder
    final sessions = logsDir
        .listSync()
        .whereType<Directory>()
        .where((d) => d.path.contains('Hearthstone_'))
        .toList()
      ..sort((a, b) => b.path.compareTo(a.path));
    if (sessions.isEmpty) return '$logsBase\\Power.log';
    return '${sessions.first.path}\\Power.log';
  }

  String _logPath;
  final _controller = StreamController<String>.broadcast();
  RandomAccessFile? _file;
  Timer? _timer;
  Timer? _sessionTimer;

  @override
  Stream<String> get lines => _controller.stream;

  void start() {
    _openOrWait();
    // HS opens a NEW dated session folder each launch. Periodically check for a
    // newer one and switch to it (handles relaunching HS while the app runs).
    _sessionTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _checkForNewerSession();
      _checkTruncationFreeze();
    });
  }

  /// Truncation freeze = saw the marker AND no new bytes for >20s. HS is open
  /// but no longer writing; only a restart recovers. Notify the UI once.
  void _checkTruncationFreeze() {
    if (_frozenNotified || !_sawTruncateMarker) return;
    final last = _lastDataAt;
    if (last == null) return;
    if (DateTime.now().difference(last).inSeconds >= 20) {
      _frozenNotified = true;
      _log.w('Power.log frozen after 10MB truncation — HS restart needed');
      onTruncationFreeze?.call();
    }
  }

  void _checkForNewerSession() {
    final newest = _defaultLogPath();
    if (newest != _logPath && File(newest).existsSync()) {
      _log.i('Newer HS session detected — switching to $newest');
      _file?.closeSync();
      _file = null;
      _logPath = newest;
      _timer?.cancel();
      // Fresh session — clear the freeze state so a future truncation re-notifies.
      _sawTruncateMarker = false;
      _frozenNotified = false;
      _lastDataAt = null;
      _openOrWait();
    }
  }

  void _openOrWait() {
    final file = File(_logPath);
    if (!file.existsSync()) {
      _log.w('Power.log not found at $_logPath — waiting for Hearthstone to launch');
      _pollUntilExists(file);
      return;
    }
    _beginTailing(file);
  }

  void _pollUntilExists(File file) {
    _timer = Timer.periodic(const Duration(seconds: 5), (t) {
      if (file.existsSync()) {
        t.cancel();
        _beginTailing(file);
      }
    });
  }

  void _beginTailing(File file) {
    try {
      _file = file.openSync();
      _file!.setPositionSync(_file!.lengthSync()); // tail from end
      _timer = Timer.periodic(const Duration(milliseconds: 250), (_) => _poll());
      _log.i('Tailing Power.log at $_logPath (start at ${file.lengthSync()} bytes)');
    } catch (e) {
      _log.e('Failed to open Power.log: $e');
    }
  }

  void _poll() {
    final raf = _file;
    if (raf == null) return;
    try {
      final length = File(_logPath).lengthSync();
      final pos = raf.positionSync();

      // Truncation/rotation: HS truncates Power.log at its 10MB cap. It may do
      // this in-place OR by recreating the file — in the latter case our cached
      // handle is detached from the live file and reads nothing. So on shrink,
      // fully REOPEN the file (not just seek) to re-attach to the live inode.
      if (length < pos) {
        _log.w('Power.log shrank ($pos → $length) — reopening file handle');
        _reopen();
        return;
      }

      if (length > pos) {
        final bytes = raf.readSync(length - pos);
        final text = String.fromCharCodes(bytes);
        _lastDataAt = DateTime.now();
        for (final line in text.split('\n')) {
          final trimmed = line.trim();
          if (trimmed.isEmpty) continue;
          // HS writes this right before it freezes at the 10MB cap.
          if (trimmed.contains('Truncating log')) {
            _sawTruncateMarker = true;
          }
          _controller.add(trimmed);
        }
      }
    } catch (e) {
      _log.e('Poll error: $e — reopening');
      _reopen();
    }
  }

  /// Close + reopen the current log file from position 0. Used after truncation
  /// or any read error (handle may have detached from a recreated file).
  void _reopen() {
    try {
      _file?.closeSync();
    } catch (_) {}
    try {
      _file = File(_logPath).openSync();
      _file!.setPositionSync(0); // read fresh content after a truncate
    } catch (e) {
      _log.e('Reopen failed: $e');
      _file = null;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _sessionTimer?.cancel();
    _file?.closeSync();
    _controller.close();
  }
}
