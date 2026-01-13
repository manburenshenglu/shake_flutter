import 'dart:async';
import 'package:flutter/foundation.dart';
import 'shake_trigger.dart';

class StreamShakeTrigger<T> extends ChangeNotifier implements ShakeTrigger {
  late final StreamSubscription<T> _subscription;

  StreamShakeTrigger(
    Stream<T> stream, {
    void Function(Object error, StackTrace stackTrace)? onError,
    bool cancelOnError = false,
  }) {
    _subscription = stream.listen(
      (_) => notifyListeners(),
      onError: onError,
      cancelOnError: cancelOnError,
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
