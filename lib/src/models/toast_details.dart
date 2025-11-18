part of '../toastify_core.dart';

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
  final VoidCallback? onDismiss;
  final bool isAutoDismissible;

  final Duration animationDuration; // V.1.1.0
  final Curve appearCurve; // V.1.1.0
  final Curve dismissCurve; // V.1.1.0

  ToastDetails({
    required this.id,
    required this.message,
    this.title,
    this.type = ToastType.info,
    this.position = ToastPosition.bottom,
    this.style = ToastStyle.snackBarStyle,
    this.titleTextStyle,
    this.messageTextStyle,
    this.leading,
    this.action,
    this.backgroundColor,
    this.borderColor,
    this.boxShadow,
    this.duration = const Duration(seconds: 3),
    this.onDismiss,
    this.isAutoDismissible = true,
    this.animationDuration = const Duration(milliseconds: 500),
    this.appearCurve = Curves.easeOutBack,
    this.dismissCurve = Curves.easeIn,
  });
}
