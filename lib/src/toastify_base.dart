import 'package:flutter/material.dart';

import 'constants/toastify_enum.dart';
import 'manager/toast_manager.dart';
import 'models/toast_details.dart';

class Toastify {
  Toastify._();

  static final ToastManager _manager = ToastManager();

  static void show({
    required BuildContext context,
    required String message,
    String? title,
    ToastType type = ToastType.info,
    ToastPosition position = ToastPosition.bottom,
    ToastStyle style = ToastStyle.snackBarStyle,
    TextStyle? titleTextStyle,
    TextStyle? messageTextStyle,
    Widget? leading,
    Widget? action,
    Color? backgroundColor,
    Color? borderColor,
    List<BoxShadow>? boxShadow,
    Duration duration = const Duration(seconds: 3),
  }) {
    final details = ToastDetails(
      message: message,
      title: title,
      type: type,
      position: position,
      style: style,
      titleTextStyle: titleTextStyle,
      messageTextStyle: messageTextStyle,
      leading: leading,
      action: action,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      boxShadow: boxShadow,
      duration: duration,
    );

    _manager.showToast(context: context, details: details);
  }

  static void dismissAll() => _manager.dismissAll();
}
