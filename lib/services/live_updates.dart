import 'dart:async';

import 'package:flutter/widgets.dart';

/// "Server data may have changed" signal — screens listen and refresh
/// themselves instantly, with no pull-to-refresh or leaving and re-entering.
///
/// Fires on:
///  1. a push arriving while the app is open (booking confirmed, housed,
///     bus assigned, payment...) — instant;
///  2. the app returning to the foreground (reopened / notification tapped);
///  3. fallback polling while open: every 30s when push isn't available on
///     this device (e.g. notification permission denied), 90s when it is.
class LiveUpdates with WidgetsBindingObserver {
  LiveUpdates._();
  static final LiveUpdates instance = LiveUpdates._();

  final StreamController<void> _controller = StreamController<void>.broadcast();
  Timer? _timer;
  DateTime _lastPing = DateTime.fromMillisecondsSinceEpoch(0);
  bool _started = false;

  /// Set once this device's push token is registered with the server.
  bool pushActive = false;

  Stream<void> get stream => _controller.stream;

  void start() {
    if (_started) return;
    _started = true;
    WidgetsBinding.instance.addObserver(this);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 30), (t) {
      // With push working, only every 3rd tick (90s) is needed.
      if (pushActive && t.tick % 3 != 0) return;
      ping();
    });
  }

  /// Tells every listening screen to refresh. Bursts (two pushes at once)
  /// collapse into a single refresh.
  void ping() {
    final now = DateTime.now();
    if (now.difference(_lastPing) < const Duration(seconds: 2)) return;
    _lastPing = now;
    _controller.add(null);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startTimer();
      ping();
    } else if (state == AppLifecycleState.paused) {
      // No polling in the background — push covers that.
      _timer?.cancel();
    }
  }
}

/// For screens that load their own data: calls [onLiveUpdate] on every signal.
mixin LiveReload<T extends StatefulWidget> on State<T> {
  StreamSubscription<void>? _liveSub;

  Future<void> onLiveUpdate();

  @override
  void initState() {
    super.initState();
    _liveSub = LiveUpdates.instance.stream.listen((_) {
      if (mounted) onLiveUpdate();
    });
  }

  @override
  void dispose() {
    _liveSub?.cancel();
    super.dispose();
  }
}
