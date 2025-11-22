part of '../toastify.dart';

class ToastDetails {
  final String id;
  final String message;
  final String? title;
  final ToastType type;
  final ToastPosition position;
  final ToastStyle style;
  final TextStyle? titleTextStyle;
  final TextStyle? messageTextStyle;
  final Widget? leading;
  final Widget? action;
  final Color? backgroundColor;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;
  final Duration duration;
  final Duration animationDuration;
  final Curve appearCurve;
  final Curve dismissCurve;
  final VoidCallback? onDismiss;
  final bool isAutoDismissible;

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
