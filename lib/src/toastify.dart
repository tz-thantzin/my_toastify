import 'dart:async';

import 'package:flutter/material.dart';

part 'core/enums.dart';
part 'core/exceptions.dart';
part 'core/models.dart';
part 'core/toast_manager.dart';
part 'core/toast_widget.dart';
part 'extensions/context_x.dart';

class Toastify {
  Toastify._();

  static final _manager = _ToastManager.instance;

  static String show(
    BuildContext context, {
    required String message,
    String? toastId,
    String? title,
    ToastType type = ToastType.info,
    ToastPosition position = ToastPosition.bottom,
    ToastStyle style = ToastStyle.snackBar,
    TextStyle? titleTextStyle,
    TextStyle? messageTextStyle,
    Widget? leading,
    Widget? action,
    Color? backgroundColor,
    Color? borderColor,
    List<BoxShadow>? boxShadow,
    Duration duration = const Duration(seconds: 3),
    Curve appearCurve = Curves.easeOutBack,
    Curve dismissCurve = Curves.easeInBack,
    Duration animationDuration = const Duration(milliseconds: 400),
    VoidCallback? onDismiss,
    bool isAutoDismissible = true,
  }) {
    if (!context.mounted) {
      debugPrint('Toastify: BuildContext is not mounted.');
      return '';
    }

    if (message.trim().isEmpty || message.length < 5) {
      throw ToastifyException(
        'Message must be at least 5 characters and not empty.',
      );
    }

    final id = toastId ?? DateTime.now().microsecondsSinceEpoch.toString();

    final details = ToastDetails(
      id: id,
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
      appearCurve: appearCurve,
      dismissCurve: dismissCurve,
      animationDuration: animationDuration,
      onDismiss: onDismiss,
      isAutoDismissible: isAutoDismissible,
    );

    _manager.show(context, details);
    return id;
  }

  static bool dismissById(String id) => _manager.dismissById(id);
  static bool dismissFirst() => _manager.dismissFirst();
  static bool dismissLast() => _manager.dismissLast();
  static void dismissAll() => _manager.dismissAll();
}
