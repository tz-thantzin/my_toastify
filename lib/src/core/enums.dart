part of '../toastify.dart';

/// Semantic type of the toast – mainly used for default coloring and icon.
enum ToastType {
  /// Neutral information message (default blue).
  info,

  /// Success/positive feedback (green).
  success,

  /// Warning that something needs attention (orange).
  warning,

  /// Error or failure (red).
  error,
}

/// Where the toast should appear on the screen.
enum ToastPosition {
  /// Appears at the top of the screen (under the status bar).
  top,

  /// Appears at the bottom of the screen (above the navigation bar).
  bottom,

  /// Appears in the top-left corner.
  topLeft,

  /// Appears in the top-right corner.
  topRight,

  /// Appears in the bottom-left corner.
  bottomLeft,

  /// Appears in the bottom-right corner.
  bottomRight,

  /// Appears at the center of the overlay.
  center,
}

extension on ToastPosition {
  bool get isTop =>
      this == ToastPosition.top ||
      this == ToastPosition.topLeft ||
      this == ToastPosition.topRight;

  bool get isBottom =>
      this == ToastPosition.bottom ||
      this == ToastPosition.bottomLeft ||
      this == ToastPosition.bottomRight;

  bool get isCenter => this == ToastPosition.center;
}

/// The visual style of the toast.
enum ToastStyle {
  /// Classic compact toast that appears at the edges of the screen.
  snackBar,

  /// Full-width banner that stretches across the entire width.
  /// Great for important announcements or promotional messages.
  banner,

  /// Compact card using the current theme with a color accent for the type.
  minimal,

  /// @Deprecated: Use [snackBar] instead.
  /// Kept for backward compatibility only.
  @Deprecated('Use ToastStyle.snackBar instead')
  snackBarStyle,

  /// @Deprecated: Use [banner] instead.
  /// Kept for backward compatibility only.
  @Deprecated('Use ToastStyle.banner instead')
  bannerStyle,
}

/// Horizontal placement of the toast inside the available overlay width.
enum ToastHorizontalAlignment {
  /// Pins the toast to the left side of the available width.
  start,

  /// Centers the toast horizontally.
  center,

  /// Pins the toast to the right side of the available width.
  end,

  /// Expands the toast to fill the available width.
  stretch,
}
