import 'dart:async';
import 'package:get/get.dart';

/// DemoController
///
/// Demonstrates the recommended pattern for using shake_widget with GetX:
/// - State (error text) is managed by Rx
/// - Shake triggering is handled by an independent Stream
///
/// This guarantees that every trigger causes a shake,
/// regardless of whether the state value changes.
import 'dart:async';
import 'package:get/get.dart';

class DemoGetxController extends GetxController {
  final _h = StreamController<void>.broadcast();
  final _v = StreamController<void>.broadcast();
  final _b = StreamController<void>.broadcast();

  Stream<void> get shakeHorizontal => _h.stream;
  Stream<void> get shakeVertical => _v.stream;
  Stream<void> get shakeBoth => _b.stream;

  void triggerHorizontal() => _h.add(null);
  void triggerVertical() => _v.add(null);
  void triggerBoth() => _b.add(null);

  @override
  void onClose() {
    _h.close();
    _v.close();
    _b.close();
    super.onClose();
  }
}
