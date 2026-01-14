[English](README.md) | [中文](README_CN.md)

# flutter_shake_container

A lightweight, configurable shake animation widget for Flutter.  
Supports **any Flutter widget**.

This README documents the **exact usage patterns** shown in `example/main.dart`,
including **ValueNotifier**, **GetX**, and **Stream** based triggers, each
demonstrated with **horizontal**, **vertical**, and **both-axis** shake directions.

---

## ✨ Features

- Preset shake styles: error / warning / subtle
- Fully customizable animation via `ShakeConfig`
- Supports horizontal / vertical / both-axis shaking
- Queue-based triggering (no interrupted animations)
- Unified trigger abstraction (ValueNotifier / Stream / GetX)
- Text and generic widget support
- `onShakeStart` callback for haptic / vibration integration
- Zero external dependencies

---

## 📦 Installation

```yaml
dependencies:
  flutter_shake_container: ^1.0.0
```
## 📥 Import

```dart
import 'package:flutter_shake_container/flutter_shake_container.dart';
```

## 📸 Demo Preview


![flutter_shake_container demo](https://raw.githubusercontent.com/manburenshenglu/shake_flutter/main/example/example.gif)
## 🔧 Properties

### ShakeContainer

| Property | Type | Description |
|--------|------|-------------|
| `trigger` | `ShakeTrigger` | The trigger that starts the shake animation. Each `ShakeContainer` should have its own trigger. |
| `config` | `ShakeConfig` | Defines the shake animation (offsets, weights, axis, curve, duration). |
| `child` | `Widget` | The widget to be shaken. Supports any Flutter widget. |
| `onShakeStart` | `VoidCallback?` | Called when the shake animation actually starts. Useful for haptic feedback or vibration. |

---

### ShakeText

| Property | Type | Description |
|--------|------|-------------|
| `text` | `ValueListenable<String>` | The text content to display and observe. A shake is triggered when the value becomes non-empty. |
| `config` | `ShakeConfig` | Shake animation configuration. |
| `style` | `TextStyle?` | Text style applied to the text widget. |
| `autoDismiss` | `Duration?` | Automatically clears the text after the given duration. |
| `onAutoDismiss` | `VoidCallback?` | Called when `autoDismiss` completes. |
| `hideWhenEmpty` | `bool` | Whether to hide the widget when the text is empty. Defaults to `true`. |
| `onShakeStart` | `VoidCallback?` | Called when the shake animation starts. Can be used for haptic feedback. |

---

### ShakeConfig

| Property | Type | Description |
|--------|------|-------------|
| `offsets` | `List<double>` | The offset values used to build the shake motion. |
| `weights` | `List<double>` | The weight for each shake segment. Must be `offsets.length - 1`. |
| `axis` | `ShakeAxis` | The shake direction: `horizontal`, `vertical`, or `both`. |
| `curve` | `Curve` | Animation curve. Defaults to `Curves.easeOut`. |
| `duration` | `Duration` | Total duration of the shake animation. |

---

### ShakeTrigger

`ShakeTrigger` is an abstraction over different trigger mechanisms.

Provided implementations:

- `StreamShakeTrigger` – Triggered by a `Stream` event
- Internal trigger for `ShakeText` (ValueListenable-based)

Each `ShakeContainer` should use **its own trigger**.
---

## 🧪 Example Usage

The following examples are copied and directly from `example/main.dart`.

---

## ✏️ ShakeText — ValueNotifier

### Horizontal

```dart
final errorH = ValueNotifier('');

ShakeText(
  text: errorH,
  config: ShakePreset.error,
  style: const TextStyle(color: Colors.red),
  autoDismiss: const Duration(seconds: 2),
  onAutoDismiss: () => errorH.value = '',
  onShakeStart: () {
    print('Shaken by ValueNotifier: Horizontal');
  },
);

errorH.value = 'Horizontal shake';
```

### Vertical

```dart
final errorV = ValueNotifier('');

ShakeText(
  text: errorV,
  config: ShakeConfig(
    offsets: [0, -10, 10, -10, 10, 0],
    weights: [1, 1, 1, 1, 1],
    axis: ShakeAxis.vertical,
  ),
  style: const TextStyle(color: Colors.orange),
  autoDismiss: const Duration(seconds: 3),
  onAutoDismiss: () => errorV.value = '',
  onShakeStart: () {
    print('Shaken by ValueNotifier: Vertical');
  },
);

errorV.value = 'Vertical shake';
```

### Both Axis

```dart
final errorB = ValueNotifier('');

ShakeText(
  text: errorB,
  config: ShakeConfig(
    offsets: [0, -8, 8, -8, 8, 0],
    weights: [1, 1, 1, 1, 1],
    axis: ShakeAxis.both,
  ),
  style: const TextStyle(color: Colors.purple),
  autoDismiss: const Duration(milliseconds: 1200),
  onAutoDismiss: () => errorB.value = '',
  onShakeStart: () {
    print('Shaken by ValueNotifier: Both');
  },
);

errorB.value = 'Both-axis shake';
```

---

## 🟢 ShakeContainer — GetX

Each direction uses an independent trigger stream.

### Horizontal

```dart
ShakeContainer(
  trigger: triggerGetxH,
  config: ShakePreset.error,
  onShakeStart: () {
    print('Shaken by GetX: Horizontal');
  },
  child: const Icon(Icons.access_alarm, color: Colors.orange),
);

demo.triggerHorizontal();
```

### Vertical

```dart
ShakeContainer(
  trigger: triggerGetxV,
  config: ShakeConfig(
    offsets: [0, -10, 10, -10, 10, 0],
    weights: [1, 1, 1, 1, 1],
    axis: ShakeAxis.vertical,
  ),
  onShakeStart: () {
    print('Shaken by GetX: Vertical');
  },
  child: const Icon(Icons.accessibility_sharp, color: Colors.deepOrange),
);

demo.triggerVertical();
```

### Both Axis

```dart
ShakeContainer(
  trigger: triggerGetxB,
  config: ShakeConfig(
    offsets: [0, -8, 8, -8, 8, 0],
    weights: [1, 1, 1, 1, 1],
    axis: ShakeAxis.both,
  ),
  onShakeStart: () {
    print('Shaken by GetX: Both');
  },
  child: const Icon(Icons.access_alarm, color: Colors.purple),
);

demo.triggerBoth();
```

---

## 🔄 ShakeContainer — Stream

Each direction uses its own `StreamController`.

### Horizontal

```dart
ShakeContainer(
  trigger: triggerStreamH,
  config: ShakePreset.error,
  onShakeStart: () {
    print('Shaken by Stream: Horizontal');
  },
  child: const Text('Horizontal shake'),
);

streamH.add(null);
```

### Vertical

```dart
ShakeContainer(
  trigger: triggerStreamV,
  config: ShakeConfig(
    offsets: [0, -10, 10, -10, 10, 0],
    weights: [1, 1, 1, 1, 1],
    axis: ShakeAxis.vertical,
  ),
  onShakeStart: () {
    print('Shaken by Stream: Vertical');
  },
  child: const Text('Vertical shake'),
);

streamV.add(null);
```

### Both Axis

```dart
ShakeContainer(
  trigger: triggerStreamB,
  config: ShakeConfig(
    offsets: [0, -8, 8, -8, 8, 0],
    weights: [1, 1, 1, 1, 1],
    axis: ShakeAxis.both,
  ),
  onShakeStart: () {
    print('Shaken by Stream: Both');
  },
  child: const Text('Both-axis shake'),
);

streamB.add(null);
```

---

## 📄 License

MIT License
