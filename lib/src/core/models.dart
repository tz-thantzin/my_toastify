part of '../toastify.dart';

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

  /// Optional border color (currently unused – reserved for future use).
  final Color? borderColor;

  /// Custom box shadows. If `null`, a default subtle shadow is applied.
  final List<BoxShadow>? boxShadow;

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

  /// Creates a new [ToastDetails] configuration object.
  const ToastDetails({
    required this.id,
    required this.message,
    this.title,
    this.type = ToastType.info,
    this.position = ToastPosition.bottom,
    this.style = ToastStyle.snackBar,
    this.titleTextStyle,
    this.messageTextStyle,
    this.leading,
    this.action,
    this.backgroundColor,
    this.borderColor,
    this.boxShadow,
    this.duration = const Duration(seconds: 3),
    this.animationDuration = const Duration(milliseconds: 400),
    this.appearCurve = Curves.easeOutBack,
    this.dismissCurve = Curves.easeInBack,
    this.onDismiss,
    this.isAutoDismissible = true,
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
  final DateTime createdAt;

  _ToastQueueEntry({
    required this.id,
    required this.entry,
    required this.style,
    required this.position,
    required this.createdAt,
  });
}
