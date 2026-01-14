/// Defines the shake direction (axis) for a shake animation.
///
/// - [horizontal] → left/right shake
/// - [vertical] → up/down shake
/// - [both] → shake on both x and y axes
enum ShakeAxis {
  /// Shake along the X axis (left/right).
  horizontal,

  /// Shake along the Y axis (up/down).
  vertical,

  /// Shake along both X and Y axes.
  both,
}