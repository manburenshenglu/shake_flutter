import 'shake_config.dart';

/// Built-in shake animation presets.
///
/// You can use these presets directly:
///
/// ```dart
/// ShakeContainer(
///   trigger: trigger,
///   config: ShakePreset.error,
///   child: const Text('Shake me'),
/// );
/// ```
///
/// Or copy and modify them to create your own [ShakeConfig].
class ShakePreset {
  /// A subtle shake preset, suitable for gentle feedback.
  ///
  /// Example usage:
  /// - Small UI hint
  /// - Subtle validation feedback
  static final ShakeConfig subtle = ShakeConfig(
    offsets: [0, -6, 6, 0],
    weights: [1, 1, 1],
    duration: const Duration(milliseconds: 280),
  );

  /// An error shake preset, suitable for strong feedback.
  ///
  /// Example usage:
  /// - Form validation errors
  /// - Login failure hints
  static final ShakeConfig error = ShakeConfig(
    offsets: [0, -12, 12, -8, 8, 0],
    weights: [1, 2, 2, 2, 1],
  );

  /// A warning shake preset, suitable for medium feedback.
  ///
  /// Example usage:
  /// - Warning messages
  /// - Attention-required UI states
  static final ShakeConfig warning = ShakeConfig(
    offsets: [0, -10, 10, -10, 10, 0],
    weights: [1, 1, 1, 1, 1],
  );
}