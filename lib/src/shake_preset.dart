import 'shake_config.dart';

class ShakePreset {
  static ShakeConfig subtle = ShakeConfig(
    offsets: [0, -6, 6, 0],
    weights: [1, 1, 1],
    duration: Duration(milliseconds: 280),
  );

  static ShakeConfig error = ShakeConfig(
    offsets: [0, -12, 12, -8, 8, 0],
    weights: [1, 2, 2, 2, 1],
  );

  static ShakeConfig warning = ShakeConfig(
    offsets: [0, -10, 10, -10, 10, 0],
    weights: [1, 1, 1, 1, 1],
  );
}
