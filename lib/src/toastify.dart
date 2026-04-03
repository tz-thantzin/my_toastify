import 'dart:async';

import 'package:flutter/material.dart';

part 'core/enums.dart';
part 'core/exceptions.dart';
part 'core/models.dart';
part 'core/toast_manager.dart';
part 'core/toast_widget.dart';
part 'extensions/context_x.dart';

/// Main entry point for showing and controlling toasts.
class Toastify {
  Toastify._();

  static final _manager = _ToastManager.instance;

  /// Shows a new toast notification.
  ///
  /// Returns the toast’s unique identifier (either the supplied [toastId] or an
  /// auto-generated one). The returned id can be used with [dismissById].
  ///
  /// Throws a [ToastifyException] if the [context] is not mounted, if the
  /// [message] is empty/whitespace-only or shorter than 5 characters, or if
  /// [widthFactor] / [maxWidth] contain invalid values.
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
    double? widthFactor,
    double? maxWidth,
    ToastHorizontalAlignment horizontalAlignment =
        ToastHorizontalAlignment.stretch,
    Duration duration = const Duration(seconds: 3),
    Curve appearCurve = Curves.easeOutBack,
    Curve dismissCurve = Curves.easeInBack,
    Duration animationDuration = const Duration(milliseconds: 400),
    VoidCallback? onDismiss,
    bool isAutoDismissible = true,
  }) {
    if (!context.mounted) {
      throw ToastifyException(
        'Cannot show toast: The provided BuildContext is not mounted. '
        'Make sure the widget is still in the tree when calling Toastify.show().',
      );
    }

    if (message.trim().isEmpty || message.length < 5) {
      throw ToastifyException(
        'Message must be at least 5 characters and not empty.',
      );
    }

    if (widthFactor != null && (widthFactor <= 0 || widthFactor > 1)) {
      throw ToastifyException(
        'widthFactor must be greater than 0 and less than or equal to 1.',
      );
    }

    if (maxWidth != null && maxWidth <= 0) {
      throw ToastifyException('maxWidth must be greater than 0.');
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
      widthFactor: widthFactor,
      maxWidth: maxWidth,
      horizontalAlignment: horizontalAlignment,
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

  /// Dismisses a toast by its id.
  ///
  /// Returns `true` if a toast with that id existed and was removed.
  static bool dismissById(String id) => _manager.dismissById(id);

  /// Dismisses the oldest visible toast.
  ///
  /// Returns `true` if a toast was dismissed.
  static bool dismissFirst() => _manager.dismissFirst();

  /// Dismisses the newest visible toast.
  ///
  /// Returns `true` if a toast was dismissed.
  static bool dismissLast() => _manager.dismissLast();

  /// Dismisses **all** currently visible toasts.
  ///
  /// The exit animation runs for each toast before it is removed.
  static void dismissAll() => _manager.dismissAll();
}
