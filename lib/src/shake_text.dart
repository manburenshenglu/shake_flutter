import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'shake_config.dart';
import 'shake_container.dart';
import 'shake_trigger.dart';

/// A shaking text widget that listens to a [ValueListenable<String>].
///
/// When [text] becomes non-empty, it triggers a shake animation.
/// This is especially useful for showing **validation errors**, **warnings**,
/// or any temporary UI message that needs attention.
///
/// It is built on top of [ShakeContainer] and uses an internal [ShakeTrigger]
/// to convert text changes into shake events.
///
/// Example:
///
/// ```dart
/// final error = ValueNotifier('');
///
/// ShakeText(
///   text: error,
///   config: ShakePreset.error,
///   autoDismiss: const Duration(seconds: 2),
///   onAutoDismiss: () => error.value = '',
/// );
///
/// error.value = 'Invalid password';
/// ```
class ShakeText extends StatefulWidget {
  /// The text source to observe.
  ///
  /// A shake is triggered whenever this value becomes non-empty.
  final ValueListenable<String> text;

  /// Shake animation configuration.
  final ShakeConfig config;

  /// Optional text style for the rendered [Text].
  final TextStyle? style;

  /// Automatically dismiss the text after this duration.
  ///
  /// If null, the text will remain until [text] is cleared manually.
  final Duration? autoDismiss;

  /// Called when [autoDismiss] is reached.
  ///
  /// Typical usage:
  /// ```dart
  /// onAutoDismiss: () => error.value = '',
  /// ```
  final VoidCallback? onAutoDismiss;

  /// Whether to hide the widget when [text] is empty.
  ///
  /// Defaults to true.
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
  /// This package introduces **no dependency** for haptics or vibration.
  final VoidCallback? onShakeStart;

  /// Creates a shaking text widget.
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
  /// Internal counter used to emit shake events.
  ///
  /// Every time the text becomes non-empty, this value is incremented.
  /// It acts as a signal rather than a UI state.
  final ValueNotifier<int> _internal = ValueNotifier(0);

  /// Internal trigger that converts [_internal] changes into [ShakeTrigger].
  late final ShakeTrigger _trigger = _InternalTrigger(_internal);

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    widget.text.addListener(_onTextChanged);

    /// Initial shake if the text is already non-empty.
    ///
    /// This covers cases where the parent sets an initial error message before
    /// the first frame is built.
    if (widget.text.value.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Delay one microtask to ensure AnimationController is attached.
        Future.microtask(() {
          if (!mounted) return;
          _internal.value++;
          _scheduleAutoDismiss();
        });
      });
    }
  }

  void _onTextChanged() {
    /// If text becomes empty, cancel the auto-dismiss timer.
    if (widget.text.value.isEmpty) {
      _timer?.cancel();
      setState(() {});
      return;
    }

    /// Trigger shake on next frame to avoid same-frame build conflicts.
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
      onShakeStart: widget.onShakeStart,
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
