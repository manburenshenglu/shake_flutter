import 'package:flutter/widgets.dart';

import '../flutter_shake_container.dart';

/// A lightweight shake animation container for any Flutter widget.
///
/// Trigger it via [ShakeTrigger] and customize animation using [ShakeConfig].
class ShakeContainer extends StatefulWidget {
  final ShakeTrigger trigger;
  final ShakeConfig config;
  final Widget child;

  /// Called when a shake animation actually starts.
  ///
  /// This callback is triggered right before the animation controller
  /// starts forwarding. It is suitable for triggering side effects such as
  /// haptic feedback or vibration, without introducing any dependency
  /// into this library.
  final VoidCallback? onShakeStart;

  const ShakeContainer({
    super.key,
    required this.trigger,
    this.config = ShakePreset.error, // default config
    required this.child,
    this.onShakeStart,
  });

  @override
  State<ShakeContainer> createState() => _ShakeContainerState();
}

class _ShakeContainerState extends State<ShakeContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;

  bool _playing = false;
  int _pending = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.config.duration,
      vsync: this,
    );

    _animation = _buildAnimation(widget.config);
    widget.trigger.addListener(_onTrigger);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _playing = false;
        if (_pending > 0) {
          _pending--;
          _play();
        }
      }
    });
  }

  void _onTrigger() {
    if (_playing) {
      _pending++;
    } else {
      _play();
    }
  }

  void _play() {
    _playing = true;

    // 🔔 Notify shake start
    widget.onShakeStart?.call();

    _controller.forward(from: 0);
  }

  Animation<double> _buildAnimation(ShakeConfig config) {
    final items = <TweenSequenceItem<double>>[];

    for (int i = 0; i < config.offsets.length - 1; i++) {
      items.add(
        TweenSequenceItem(
          tween: Tween(
            begin: config.offsets[i],
            end: config.offsets[i + 1],
          ),
          weight: config.weights[i],
        ),
      );
    }

    return TweenSequence(items).animate(
      CurvedAnimation(
        parent: _controller,
        curve: config.curve,
      ),
    );
  }

  Offset _offset(double v) {
    switch (widget.config.axis) {
      case ShakeAxis.vertical:
        return Offset(0, v);
      case ShakeAxis.both:
        return Offset(v, v);
      case ShakeAxis.horizontal:
      default:
        return Offset(v, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, child) {
        return Transform.translate(
          offset: _offset(_animation.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    widget.trigger.removeListener(_onTrigger);
    _controller.dispose();
    super.dispose();
  }
}
