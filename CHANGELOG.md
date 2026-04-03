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
