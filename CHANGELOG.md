## 2.0.0
### Added
- Added `ToastifyHost` and `ToastifyController` for app-level toast management without passing a page `BuildContext` to each call.
- Added controller methods to show notifications, dismiss by ID, dismiss the first or last toast, and dismiss all toasts.
- Added per-controller visible toast limits and queue, drop-newest, and replace-oldest overflow policies.
- Added deduplication keys so repeated updates replace stale notifications.
- Added reusable `ToastifyThemeData` styling for toast colors, surfaces, corners, and shadows.
- Added screen-reader live region announcements with custom semantic labels.
- Added top-left, top-right, bottom-left, bottom-right, and center position presets.
- Added widget tests for host lifecycle, queues, deduplication, and accessibility labels.

## 1.3.0
### Added
- Added an optional countdown progress bar for auto-dismissing toasts.
- Added hover and long-press pausing for toast auto-dismiss timers.
- Added `ToastStyle.minimal`, a compact theme-aware card with semantic accents.

### Improved
- Auto-dismiss countdowns now preserve their remaining time while paused.

## 1.2.0
### Added
- Added `widthFactor` for fractional toast widths.
- Added `maxWidth` for responsive width constraints.
- Added `ToastHorizontalAlignment` to support start, center, end, and stretch placement.

### Changed
- Refactored toast layout internals for cleaner, more maintainable code structure.
- Updated the example app into a clearer demo catalog with focused example sections.
- Expanded the `example` folder with dedicated layout and customization examples.
- Improved README API documentation for the new layout options.

### Fixed
- Applied `borderColor` and `boxShadow` consistently to toast decoration.
- Fixed the web/banner layout flow for half-width bottom-right placement.
- Fixed the syntax issue in `toast_widget.dart` that caused web compilation to fail.
- Fixed remaining auto-dismiss timers when overlay entries are disposed externally, improving widget test stability.
- Fixed pending auto-dismiss timers so widget tests can dispose toast overlays cleanly after manual dismissal.

## 1.1.2
- Add API description.

## 1.1.1
- Modify min dart sdk 3.9 to 3.0.
- Optimize source code.

## 1.1.0
- Add custom appear and dismiss animation.

## 1.0.1
- Add error handling.

## 1.0.0
### Stable Release
- Added `onDismiss` callback to handle actions when a toast is dismissed.
- Introduced `isAutoDismissible` flag to control automatically disappear.
- Added manual dismissal methods:
  - `dismissById(id)` to dismiss a specific toast by its unique ID.
  - `dismissFirst()` to dismiss the first toast in the queue.
  - `dismissLast()` to dismiss the most recently added toast.

## 0.0.3
- Modify README.md.

## 0.0.2
- Modify README.md.

## 0.0.1
### Initial Release
- Introduced `Toastify`, a customizable toast notification system for Flutter.
- Added support for:
  - Overlay-based toasts with stacking and animations.
  - Two layouts: `snackBarStyle` and `bannerStyle`.
  - Toast directions: top or bottom.
  - Toast types: info, success, warning, error.
  - Custom leading icons and action buttons.
  - Shadow, border, and background color customization.
  - Swipe-to-dismiss gesture.
  - Multiple toasts displayed simultaneously.
