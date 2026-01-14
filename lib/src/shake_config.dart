import 'package:flutter/animation.dart';
import 'shake_axis.dart';

/// Configuration for a shake animation.
///
/// [ShakeConfig] defines how the shake animation behaves, including:
/// - total [duration]
/// - animation [curve]
/// - movement [offsets] and corresponding [weights]
/// - shake [axis] direction (horizontal / vertical / both)
///
/// Example:
///
/// ```dart
/// final config = ShakeConfig(
///   offsets: [0, -12, 12, -8, 8, 0],
///   weights: [1, 2, 2, 2, 1],
///   axis: ShakeAxis.horizontal,
///   duration: const Duration(milliseconds: 600),
/// );
/// ```
///
/// Notes:
/// - [offsets] must contain at least 2 values (start and end).
/// - [weights] length must be `offsets.length - 1`.
class ShakeConfig {
  /// Total duration of the shake animation.
  final Duration duration;

  /// Animation curve used by the shake motion.
  final Curve curve;

  /// Offset values used to build the shake motion.
  ///
  /// Example:
  /// ```dart
  /// offsets: [0, -12, 12, -8, 8, 0]
  /// ```
  ///
  /// Must contain at least 2 values.
  final List<double> offsets;

  /// Weights for each shake segment.
  ///
  /// Must have a length of `offsets.length - 1`.
  ///
  /// Example:
  /// ```dart
  /// weights: [1, 2, 2, 2, 1]
  /// ```
  final List<double> weights;

  /// The shake axis direction.
  ///
  /// - [ShakeAxis.horizontal] → left/right shake
  /// - [ShakeAxis.vertical] → up/down shake
  /// - [ShakeAxis.both] → both-axis shake
  final ShakeAxis axis;

  /// Creates a shake animation configuration.
  ///
  /// Assertions:
  /// - [offsets.length] must be >= 2
  /// - [weights.length] must equal `offsets.length - 1`
  const ShakeConfig({
    required this.offsets,
    required this.weights,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOut,
    this.axis = ShakeAxis.horizontal,
  })  : assert(offsets.length >= 2),
        assert(weights.length == offsets.length - 1);
}