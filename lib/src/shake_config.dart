import 'package:flutter/animation.dart';
import 'shake_axis.dart';

class ShakeConfig {
  final Duration duration;
  final Curve curve;
  final List<double> offsets;
  final List<double> weights;
  final ShakeAxis axis;

  const ShakeConfig({
    required this.offsets,
    required this.weights,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOut,
    this.axis = ShakeAxis.horizontal,
  })  : assert(offsets.length >= 2),
        assert(weights.length == offsets.length - 1);
}
