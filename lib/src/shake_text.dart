import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'shake_config.dart';
import 'shake_container.dart';
import 'shake_trigger.dart';

class ShakeText extends StatefulWidget {
  final ValueListenable<String> text;
  final ShakeConfig config;
  final TextStyle? style;
  final Duration? autoDismiss;
  final VoidCallback? onAutoDismiss;
  final bool hideWhenEmpty;

  /// Called when the shake animation starts.
  ///
  /// This callback is forwarded to [ShakeContainer] and is triggered
  /// right before the shake animation begins.
  ///
  /// Typical use cases:
  /// - Haptic feedback
  /// - Vibration
  /// - Sound effects
  ///
  /// No dependency is introduced by this library.
  final VoidCallback? onShakeStart;

  const ShakeText({
    super.key,
    required this.text,
    required this.config,
    this.style,
    this.autoDismiss,
    this.onAutoDismiss,
    this.hideWhenEmpty = true,
    this.onShakeStart,
  });

  @override
  State<ShakeText> createState() => _ShakeTextState();
}

class _ShakeTextState extends State<ShakeText> {
  final ValueNotifier<int> _internal = ValueNotifier(0);
  late final ShakeTrigger _trigger = _InternalTrigger(_internal);

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    widget.text.addListener(_onTextChanged);

    // Initial shake if text is not empty
    if (widget.text.value.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Delay one microtask to ensure AnimationController is attached
        Future.microtask(() {
          if (!mounted) return;
          _internal.value++;
          _scheduleAutoDismiss();
        });
      });
    }
  }

  void _onTextChanged() {
    if (widget.text.value.isEmpty) {
      _timer?.cancel();
      setState(() {});
      return;
    }

    // Trigger shake on next frame to avoid same-frame build conflicts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _internal.value++;
      _scheduleAutoDismiss();
    });

    setState(() {});
  }

  void _scheduleAutoDismiss() {
    _timer?.cancel();
    if (widget.autoDismiss == null) return;

    _timer = Timer(widget.autoDismiss!, () {
      widget.onAutoDismiss?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.text.value;
    if (widget.hideWhenEmpty && value.isEmpty) {
      return const SizedBox.shrink();
    }

    return ShakeContainer(
      trigger: _trigger,
      config: widget.config,
      onShakeStart: widget.onShakeStart, // payload
      child: Text(
        value,
        style: widget.style,
      ),
    );
  }

  @override
  void dispose() {
    widget.text.removeListener(_onTextChanged);
    _timer?.cancel();
    _internal.dispose();
    _trigger.dispose();
    super.dispose();
  }
}

class _InternalTrigger extends ChangeNotifier implements ShakeTrigger {
  final ValueListenable<int> source;

  _InternalTrigger(this.source) {
    source.addListener(notifyListeners);
  }

  @override
  void dispose() {
    source.removeListener(notifyListeners);
    super.dispose();
  }
}
