[English](README.md) | [中文](README_CN.md)

# flutter_shake_widget

一个轻量、可配置的 Flutter 抖动动画组件。  
**支持任意 Flutter Widget**。

本文档**严格基于 `example/main.dart` 中的实际使用方式**整理，
完整覆盖 **ValueNotifier / GetX / Stream** 三种触发方式，
并分别演示 **横向 / 纵向 / 双轴** 三种抖动方向。

---

## ✨ 特性

- 内置抖动预设：error / warning / subtle
- 通过 `ShakeConfig` 完全自定义动画
- 支持横向 / 纵向 / 双轴抖动
- 队列式触发（抖动不会被中断）
- 统一的触发抽象（ValueNotifier / Stream / GetX）
- 支持文本与任意组件
- 提供 `onShakeStart` 回调（用于震动 / 触觉反馈）
- 零第三方依赖

---

## 📦 安装

```yaml
dependencies:
  flutter_shake_widget: ^1.0.0
```
## 📸 示例效果图

![flutter_shake_widget 示例](https://raw.githubusercontent.com/manburenshenglu/shake_flutter/main/example/example.gif)
---

## 🔧 属性说明

### ShakeContainer

| 属性名 | 类型 | 说明 |
|------|------|------|
| `trigger` | `ShakeTrigger` | 抖动触发器，每个 `ShakeContainer` 应使用独立 trigger |
| `config` | `ShakeConfig` | 抖动动画配置 |
| `child` | `Widget` | 被抖动的组件，支持任意 Widget |
| `onShakeStart` | `VoidCallback?` | 抖动开始时回调，可用于震动或触觉反馈 |

---

### ShakeText

| 属性名 | 类型 | 说明 |
|------|------|------|
| `text` | `ValueListenable<String>` | 文本监听器，非空时触发抖动 |
| `config` | `ShakeConfig` | 抖动动画配置 |
| `style` | `TextStyle?` | 文本样式 |
| `autoDismiss` | `Duration?` | 自动清空文本 |
| `onAutoDismiss` | `VoidCallback?` | 自动清空完成回调 |
| `hideWhenEmpty` | `bool` | 文本为空时是否隐藏 |
| `onShakeStart` | `VoidCallback?` | 抖动开始回调 |

---

## 🧪 示例用法

以下示例**全部直接来源于 `example/main.dart`**。

---

## ✏️ ShakeText —— ValueNotifier

### 横向抖动

```dart
final errorH = ValueNotifier('');

ShakeText(
  text: errorH,
  config: ShakePreset.error,
  style: const TextStyle(color: Colors.red),
  autoDismiss: const Duration(seconds: 2),
  onAutoDismiss: () => errorH.value = '',
  onShakeStart: () {
    print('ValueNotifier：横向抖动开始');
  },
);

errorH.value = 'Horizontal shake';
```

### 纵向抖动

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
    print('ValueNotifier：纵向抖动开始');
  },
);

errorV.value = 'Vertical shake';
```

### 双轴抖动

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
    print('ValueNotifier：双轴抖动开始');
  },
);

errorB.value = 'Both-axis shake';
```

---

## 🟢 ShakeContainer —— GetX

### 横向抖动

```dart
ShakeContainer(
  trigger: triggerGetxH,
  config: ShakePreset.error,
  onShakeStart: () {
    print('GetX：横向抖动开始');
  },
  child: const Icon(Icons.access_alarm, color: Colors.orange),
);

demo.triggerHorizontal();
```

### 纵向抖动

```dart
ShakeContainer(
  trigger: triggerGetxV,
  config: ShakeConfig(
    offsets: [0, -10, 10, -10, 10, 0],
    weights: [1, 1, 1, 1, 1],
    axis: ShakeAxis.vertical,
  ),
  onShakeStart: () {
    print('GetX：纵向抖动开始');
  },
  child: const Icon(Icons.accessibility_sharp, color: Colors.deepOrange),
);

demo.triggerVertical();
```

### 双轴抖动

```dart
ShakeContainer(
  trigger: triggerGetxB,
  config: ShakeConfig(
    offsets: [0, -8, 8, -8, 8, 0],
    weights: [1, 1, 1, 1, 1],
    axis: ShakeAxis.both,
  ),
  onShakeStart: () {
    print('GetX：双轴抖动开始');
  },
  child: const Icon(Icons.access_alarm, color: Colors.purple),
);

demo.triggerBoth();
```

---

## 🔄 ShakeContainer —— Stream

### 横向抖动

```dart
ShakeContainer(
  trigger: triggerStreamH,
  config: ShakePreset.error,
  onShakeStart: () {
    print('Stream：横向抖动开始');
  },
  child: const Text('Horizontal shake'),
);

streamH.add(null);
```

### 纵向抖动

```dart
ShakeContainer(
  trigger: triggerStreamV,
  config: ShakeConfig(
    offsets: [0, -10, 10, -10, 10, 0],
    weights: [1, 1, 1, 1, 1],
    axis: ShakeAxis.vertical,
  ),
  onShakeStart: () {
    print('Stream：纵向抖动开始');
  },
  child: const Text('Vertical shake'),
);

streamV.add(null);
```

### 双轴抖动

```dart
ShakeContainer(
  trigger: triggerStreamB,
  config: ShakeConfig(
    offsets: [0, -8, 8, -8, 8, 0],
    weights: [1, 1, 1, 1, 1],
    axis: ShakeAxis.both,
  ),
  onShakeStart: () {
    print('Stream：双轴抖动开始');
  },
  child: const Text('Both-axis shake'),
);

streamB.add(null);
```

---

## 📄 许可证

MIT License
