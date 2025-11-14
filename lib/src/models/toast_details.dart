import 'package:flutter/material.dart';

import '../constants/toastify_enum.dart';

class ToastDetails {
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

  ToastDetails({
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
  });
}
