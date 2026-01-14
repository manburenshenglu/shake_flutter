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

  /// Recommended constructor with validation.
  factory ShakeConfig.create({
    required List<double> offsets,
    required List<double> weights,
    Duration duration = const Duration(milliseconds: 600),
    Curve curve = Curves.easeOut,
    ShakeAxis axis = ShakeAxis.horizontal,
  }) {
    assert(offsets.length >= 2, 'offsets must have at least 2 values.');
    assert(
      weights.length == offsets.length - 1,
      'weights.length must be offsets.length - 1.',
    );

    return ShakeConfig(
      offsets: offsets,
      weights: weights,
      duration: duration,
      curve: curve,
      axis: axis,
    );
  }

  /// Public const constructor.
  ///
  /// No runtime asserts here, recommend use [ShakeConfig.create] for validation.
  const ShakeConfig({
    required this.offsets,
    required this.weights,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOut,
    this.axis = ShakeAxis.horizontal,
  });
}
