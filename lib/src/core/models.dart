part of '../toastify.dart';

/// Shared visual tokens for toast notifications.
///
/// Pass one instance to multiple calls or set it on [ToastifyController] to
/// apply consistent type colors, surface colors, corners, and shadows.
class ToastifyThemeData {
  /// Creates reusable toast styling.
  const ToastifyThemeData({
    this.infoColor,
    this.successColor,
    this.warningColor,
    this.errorColor,
    this.surfaceColor,
    this.foregroundColor,
    this.borderRadius,
    this.boxShadow,
  });

  /// Accent for informational notifications.
  final Color? infoColor;

  /// Accent for successful notifications.
  final Color? successColor;

  /// Accent for warning notifications.
  final Color? warningColor;

  /// Accent for error notifications.
  final Color? errorColor;

  /// Surface used by minimal style notifications.
  final Color? surfaceColor;

  /// Foreground color for text and icons.
  final Color? foregroundColor;

  /// Shared border radius for the toast card.
  final BorderRadiusGeometry? borderRadius;

  /// Shared shadow list.
  final List<BoxShadow>? boxShadow;

  Color accentFor(ToastType type) => switch (type) {
        ToastType.info => infoColor ?? Colors.blueAccent,
        ToastType.success => successColor ?? Colors.green,
        ToastType.warning => warningColor ?? Colors.orangeAccent,
        ToastType.error => errorColor ?? Colors.redAccent,
      };
}

/// All configuration data for a single toast instance.
class ToastDetails {
  /// Unique identifier of the toast. If omitted, an auto-generated id is used.
  final String id;

  /// The main message text displayed inside the toast.
  final String message;

  /// Optional title shown above the message (bold, larger font).
  final String? title;

  /// Visual style of the toast – determines layout and stacking behaviour.
  final ToastStyle style;

  /// Position on the screen (top or bottom).
  final ToastPosition position;

  /// Semantic type – controls default background color and leading icon.
  final ToastType type;

  /// Optional key used to replace an existing toast with the same key.
  final String? deduplicationKey;

  /// Reusable visual styling for this toast.
  final ToastifyThemeData? theme;

  /// Optional label announced by assistive technologies.
  final String? semanticLabel;

  /// Whether this toast should be announced as a live region update.
  final bool announceToScreenReader;

  /// Custom text style for the title. Falls back to theme-based style.
  final TextStyle? titleTextStyle;

  /// Custom text style for the message. Falls back to theme-based style.
  final TextStyle? messageTextStyle;

  /// Optional widget displayed on the left side (replaces default type icon).
  final Widget? leading;

  /// Optional widget (usually a button) displayed on the trailing side.
  final Widget? action;

  /// Explicit background color. If `null`, color is derived from [type].
  final Color? backgroundColor;

  /// Optional border color for the toast container.
  final Color? borderColor;

  /// Custom box shadows. If `null`, a default subtle shadow is applied.
  final List<BoxShadow>? boxShadow;

  /// Fraction of the available overlay width used by the toast.
  ///
  /// Must be greater than `0` and less than or equal to `1`.
  ///
  /// Example: `0.5` renders the toast at half the available width.
  final double? widthFactor;

  /// Maximum width of the toast in logical pixels.
  final double? maxWidth;

  /// Horizontal placement of the toast inside the overlay bounds.
  final ToastHorizontalAlignment horizontalAlignment;

  /// How long the toast stays visible when [isAutoDismissible] is true.
  final Duration duration;

  /// Duration of the enter/exit animations.
  final Duration animationDuration;

  /// Curve used when the toast appears.
  final Curve appearCurve;

  /// Curve used when the toast is dismissed.
  final Curve dismissCurve;

  /// Callback invoked after the toast has been fully removed.
  final VoidCallback? onDismiss;

  /// Whether the toast should disappear automatically after [duration].
  final bool isAutoDismissible;

  /// Whether to show a countdown bar while the toast is visible.
  final bool showProgressBar;

  /// Whether hover and long-press pause the auto-dismiss countdown.
  final bool pauseOnInteraction;

  /// Creates a new [ToastDetails] configuration object.
  const ToastDetails({
    required this.id,
    required this.message,
    this.title,
    this.type = ToastType.info,
    this.deduplicationKey,
    this.theme,
    this.semanticLabel,
    this.announceToScreenReader = true,
    this.position = ToastPosition.bottom,
    this.style = ToastStyle.snackBar,
    this.titleTextStyle,
    this.messageTextStyle,
    this.leading,
    this.action,
    this.backgroundColor,
    this.borderColor,
    this.boxShadow,
    this.widthFactor,
    this.maxWidth,
    this.horizontalAlignment = ToastHorizontalAlignment.stretch,
    this.duration = const Duration(seconds: 3),
    this.animationDuration = const Duration(milliseconds: 400),
    this.appearCurve = Curves.easeOutBack,
    this.dismissCurve = Curves.easeInBack,
    this.onDismiss,
    this.isAutoDismissible = true,
    this.showProgressBar = false,
    this.pauseOnInteraction = true,
  });
}

/// Internal representation of a toast entry in the queue.
///
/// This class is not part of the public API and should not be used directly.
/// It is intentionally private but documented for clarity and testing.
class _ToastQueueEntry {
  final String id;
  final OverlayEntry entry;
  final ToastStyle style;
  final ToastPosition position;
  final String? deduplicationKey;
  final VoidCallback? onDismiss;
  final DateTime createdAt;
  Timer? dismissTimer;
  Duration remainingDuration;
  Stopwatch? timerStopwatch;
  VoidCallback? mountedStateListener;

  _ToastQueueEntry({
    required this.id,
    required this.entry,
    required this.style,
    required this.position,
    this.deduplicationKey,
    this.onDismiss,
    required this.createdAt,
    required this.remainingDuration,
  });
}
