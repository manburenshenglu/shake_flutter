import 'package:flutter/foundation.dart';

/// Unified trigger abstraction for shake animations.
///
/// [ShakeTrigger] is a lightweight interface used by [ShakeContainer]
/// to listen for "shake events".
///
/// A shake is an **event signal**, not a UI state.
///
/// This makes it easy to integrate with different architectures, such as:
/// - [ValueListenable] / [ChangeNotifier]
/// - Stream-based systems (via [StreamShakeTrigger])
/// - GetX / BLoC / Riverpod (through a custom trigger adapter)
///
/// ### Example (Stream)
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
/// Notes:
/// - Each [ShakeContainer] should have its own [ShakeTrigger].
/// - You should call [dispose] to release resources (e.g. stream subscriptions).
abstract class ShakeTrigger implements Listenable {
  /// Disposes any internal resources.
  ///
  /// For example, [StreamShakeTrigger] cancels its stream subscription here.
  void dispose();
}