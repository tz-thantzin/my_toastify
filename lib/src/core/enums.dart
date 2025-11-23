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
}

/// The visual style of the toast.
enum ToastStyle {
  /// Classic compact toast that appears at the edges of the screen.
  snackBar,

  /// Full-width banner that stretches across the entire width.
  /// Great for important announcements or promotional messages.
  banner,

  /// @Deprecated: Use [snackBar] instead.
  /// Kept for backward compatibility only.
  @Deprecated('Use ToastStyle.snackBar instead')
  snackBarStyle,

  /// @Deprecated: Use [banner] instead.
  /// Kept for backward compatibility only.
  @Deprecated('Use ToastStyle.banner instead')
  bannerStyle,
}
