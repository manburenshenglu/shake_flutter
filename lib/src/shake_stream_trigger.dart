import 'dart:async';

import 'package:flutter/foundation.dart';

import 'shake_trigger.dart';

/// A [ShakeTrigger] implementation that converts a [Stream] into shake signals.
///
/// Each event emitted by the stream will trigger a shake.
/// The event value itself is ignored — only the signal matters.
///
/// Typical use cases:
/// - BLoC / Cubit streams
/// - RxDart streams
/// - WebSocket events
/// - Form validation triggers
///
/// ---
///
/// ## Basic Example
///
/// ```dart
/// final controller = StreamController<void>.broadcast();
/// final trigger = StreamShakeTrigger(controller.stream);
///
/// ShakeContainer(
///   trigger: trigger,
///   config: ShakePreset.error,
///   child: const Text('Shake me'),
/// );
///
/// controller.add(null); // triggers shake
/// ```
///
/// ---
///
/// ## GetX Example (Recommended Pattern)
///
/// Shake is an **event**, not a state change.
/// When using GetX, do NOT rely on `Rx` value changes to trigger shakes.
/// Instead, create a dedicated stream to emit shake events.
///
/// ✅ Controller:
///
/// ```dart
/// class DemoGetxController extends GetxController {
///   final StreamController<void> _shakeController =
///       StreamController<void>.broadcast();
///
///   Stream<void> get shakeStream => _shakeController.stream;
///
///   void triggerShake() {
///     _shakeController.add(null); // always triggers a shake event
///   }
///
///   @override
///   void onClose() {
///     _shakeController.close();
///     super.onClose();
///   }
/// }
/// ```
///
/// ✅ UI:
///
/// ```dart
/// final demo = Get.find<DemoGetxController>();
/// final trigger = StreamShakeTrigger(demo.shakeStream);
///
/// ShakeContainer(
///   trigger: trigger,
///   config: ShakePreset.warning,
///   child: const Icon(Icons.warning),
/// );
///
/// ElevatedButton(
///   onPressed: demo.triggerShake,
///   child: const Text('Trigger GetX Shake'),
/// );
/// ```
///
/// Notes:
/// - This package does NOT depend on GetX.
/// - The code above is only an example showing how to connect GetX to a stream.
class StreamShakeTrigger<T> extends ChangeNotifier implements ShakeTrigger {
  late final StreamSubscription<T> _subscription;

  /// Creates a trigger that listens to [stream].
  ///
  /// If [onError] is provided, it will be called when the stream emits an error.
  /// Otherwise, errors are silently ignored.
  ///
  /// Set [cancelOnError] to true if you want the trigger to stop listening after
  /// the first error event.
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
