import 'dart:async';

import 'package:example/demo_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shake_container/flutter_shake_container.dart';
import 'package:get/get.dart';

void main() {
  Get.put(DemoGetxController());
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(home: Home());
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  /// ===================================================
  /// 1️⃣ ValueNotifier（3 个方向 = 3 个 notifier）
  /// ===================================================
  final errorH = ValueNotifier('');
  final errorV = ValueNotifier('');
  final errorB = ValueNotifier('');

  /// ===================================================
  /// 2️⃣ Stream（3 个方向 = 3 个 controller）
  /// ===================================================
  final streamH = StreamController<void>.broadcast();
  final streamV = StreamController<void>.broadcast();
  final streamB = StreamController<void>.broadcast();

  late final triggerStreamH = StreamShakeTrigger(streamH.stream);
  late final triggerStreamV = StreamShakeTrigger(streamV.stream);
  late final triggerStreamB = StreamShakeTrigger(streamB.stream);

  /// ===================================================
  /// 3️⃣ GetX（3 个方向 = 3 个 trigger）
  /// ===================================================
  late final DemoGetxController demo = Get.find();

  late final triggerGetxH = StreamShakeTrigger<void>(demo.shakeHorizontal);
  late final triggerGetxV = StreamShakeTrigger<void>(demo.shakeVertical);
  late final triggerGetxB = StreamShakeTrigger<void>(demo.shakeBoth);

  /// ===================================================
  /// Shake Configs
  /// ===================================================
  final ShakeConfig horizontal = ShakePreset.error;

  final ShakeConfig vertical = ShakeConfig(
    offsets: [0, -10, 10, -10, 10, 0],
    weights: [1, 1, 1, 1, 1],
    axis: ShakeAxis.vertical,
  );

  final ShakeConfig both = ShakeConfig(
    offsets: [0, -8, 8, -8, 8, 0],
    weights: [1, 1, 1, 1, 1],
    axis: ShakeAxis.both,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('shake_widget example')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===================================================
            /// ValueNotifier × Directions
            /// ===================================================
            const Text(
              'Shaken by ValueNotifier',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            ShakeText(
              text: errorH,
              config: horizontal,
              style: const TextStyle(color: Colors.red),
              autoDismiss: const Duration(seconds: 2),
              onAutoDismiss: () => errorH.value = '',
              onShakeStart: () {
                debugPrint(
                  'Shaken by ValueNotifier： Horizontal shake started, do something...such as haptic feedback or vibration ',
                );
              },
            ),
            ElevatedButton(
              onPressed: () => errorH.value = 'Horizontal shake',
              child: const Text('ValueNotifier · Horizontal'),
            ),

            ShakeText(
              text: errorV,
              config: vertical,
              style: const TextStyle(color: Colors.orange),
              autoDismiss: const Duration(seconds: 3),
              onAutoDismiss: () => errorV.value = '',
              onShakeStart: () {
                debugPrint(
                  'Shaken by ValueNotifier： Vertical shake started, do something...such as haptic feedback or vibration ',
                );
              },
            ),
            ElevatedButton(
              onPressed: () => errorV.value = 'Vertical shake',
              child: const Text('ValueNotifier · Vertical'),
            ),
            ShakeText(
              text: errorB,
              config: both,
              style: const TextStyle(color: Colors.purple),
              autoDismiss: const Duration(milliseconds: 1200),
              onAutoDismiss: () => errorB.value = '',
              onShakeStart: () {
                debugPrint(
                  'Shaken by ValueNotifier： Both-axis shake started, do something...such as haptic feedback or vibration ',
                );
              },
            ),
            ElevatedButton(
              onPressed: () => errorB.value = 'Both-axis shake',
              child: const Text('ValueNotifier · Both'),
            ),

            const Divider(height: 40),

            /// ===================================================
            /// GetX × Directions
            /// ===================================================
            const Text(
              'Shaken by GetX',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            ShakeContainer(
              trigger: triggerGetxH,
              config: horizontal,
              onShakeStart: () {
                debugPrint(
                  'Shaken by GetX： Horizontal shake started, do something...such as haptic feedback or vibration ',
                );
              },
              child: const Icon(Icons.access_alarm, color: Colors.orange),
            ),
            ElevatedButton(
              onPressed: demo.triggerHorizontal,
              child: const Text('GetX · Horizontal'),
            ),

            ShakeContainer(
              trigger: triggerGetxV,
              config: vertical,
              onShakeStart: () {
                debugPrint(
                  'Shaken by GetX： Vertical shake started, do something...such as haptic feedback or vibration ',
                );
              },
              child: const Icon(
                Icons.accessibility_sharp,
                color: Colors.deepOrange,
              ),
            ),
            ElevatedButton(
              onPressed: demo.triggerVertical,
              child: const Text('GetX · Vertical'),
            ),

            ShakeContainer(
              trigger: triggerGetxB,
              config: both,
              onShakeStart: () {
                debugPrint(
                  'Shaken by GetX：Both shake started, do something...such as haptic feedback or vibration ',
                );
              },
              child: const Icon(Icons.access_alarm, color: Colors.purple),
            ),
            ElevatedButton(
              onPressed: demo.triggerBoth,
              child: const Text('GetX · Both'),
            ),
            const Divider(height: 40),

            /// ===================================================
            /// Stream × Directions
            /// ===================================================
            const Text(
              'Shaken by Stream',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            ShakeContainer(
              trigger: triggerStreamH,
              config: horizontal,
              child: const Text('Horizontal shake'),
              onShakeStart: () {
                debugPrint(
                  'Shaken by Stream： Horizontal shake started, do something...such as haptic feedback or vibration ',
                );
              },
            ),
            ElevatedButton(
              onPressed: () => streamH.add(null),
              child: const Text('Stream · Horizontal'),
            ),

            ShakeContainer(
              trigger: triggerStreamV,
              config: vertical,
              child: const Text('Vertical shake'),
              onShakeStart: () {
                debugPrint(
                  'Shaken by Stream： Vertical shake started, do something...such as haptic feedback or vibration ',
                );
              },
            ),
            ElevatedButton(
              onPressed: () => streamV.add(null),
              child: const Text('Stream · Vertical'),
            ),

            ShakeContainer(
              trigger: triggerStreamB,
              config: both,
              child: const Text('Both-axis shake'),
              onShakeStart: () {
                debugPrint(
                  'Shaken by Stream： Both-axis shake started, do something...such as haptic feedback or vibration ',
                );
              },
            ),
            ElevatedButton(
              onPressed: () => streamB.add(null),
              child: const Text('Stream · Both'),
            ),

            const Divider(height: 40),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    errorH.dispose();
    errorV.dispose();
    errorB.dispose();

    streamH.close();
    streamV.close();
    streamB.close();

    triggerStreamH.dispose();
    triggerStreamV.dispose();
    triggerStreamB.dispose();

    triggerGetxH.dispose();
    triggerGetxV.dispose();
    triggerGetxB.dispose();

    super.dispose();
  }
}
