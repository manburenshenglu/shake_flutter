# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/).

---

## 1.1.0

### Added

- Added `onShakeStart` callback support in `ShakeContainer` and `ShakeText` for integrating haptic
  feedback / vibration.
- Added GetX usage example in `StreamShakeTrigger` documentation comments.

### Improved

- Improve documentation comments for public APIs.
- Updated README examples and clarified multi-trigger / multi-axis usage patterns.

---

## 1.0.0

### Added

- Initial stable release.
- `ShakeContainer` for shaking any widget using a trigger.
- `ShakeText` for shaking error text with optional auto-dismiss support.
- Built-in presets: `ShakePreset.error`, `ShakePreset.warning`, `ShakePreset.subtle`.
- `StreamShakeTrigger` for stream-based triggering.