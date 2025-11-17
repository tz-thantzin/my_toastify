import 'package:flutter/material.dart';

import 'constants/toastify_enum.dart';
import 'exceptions/toastify_exception.dart';
import 'manager/toast_manager.dart';
import 'models/toast_details.dart';

class Toastify {
  Toastify._();

  static final ToastManager _manager = ToastManager();

  /// Displays a toast message on the screen.
  ///
  /// Returns a unique `toastId` for controlling or dismissing the toast later.
  ///
  /// ---
  /// ### Parameters
  ///
  /// - **context**:
  ///   The `BuildContext` used to insert the toast overlay.
  ///   Must be *mounted*, otherwise a warning is printed and the toast is not shown.
  ///
  /// - **message**:
  ///   The primary text of the toast.
  ///   Must not be empty and must be **longer than 5 characters**.
  ///
  /// - **toastId** *(optional)*:
  ///   Provide your own ID.
  ///   If omitted, a unique ID is generated automatically.
  ///
  /// - **title** *(optional)*:
  ///   An optional title displayed above the message.
  ///
  /// - **type** *(default: ToastType.info)*:
  ///   Controls color/theme (info, success, warning, error).
  ///
  /// - **position** *(default: ToastPosition.bottom)*:
  ///   Display location: top or bottom.
  ///
  /// - **style** *(default: ToastStyle.snackBarStyle)*:
  ///   Controls visual layout: snackbar-style, banner-style, etc.
  ///
  /// - **titleTextStyle**, **messageTextStyle** *(optional)*:
  ///   Custom text styles for the title and message.
  ///
  /// - **leading** *(optional)*:
  ///   A widget displayed at the start of the toast (icon/avatar/etc.).
  ///
  /// - **action** *(optional)*:
  ///   A widget displayed at the end of the toast (e.g., button).
  ///
  /// - **backgroundColor**, **borderColor**, **boxShadow** *(optional)*:
  ///   Optional appearance customizations.
  ///
  /// - **duration** *(default: 3 seconds)*:
  ///   Auto-dismiss duration (ignored if `isAutoDismissible` is false).
  ///
  /// - **onDismiss** *(optional)*:
  ///   Callback fired when the toast is dismissed.
  ///
  /// - **isAutoDismissible** *(default: true)*:
  ///   Whether the toast automatically disappears after [duration].
  ///
  /// ---
  /// ### Returns
  ///
  /// A `String` ID representing the toast.
  /// Can be used with `dismissById(id)` to cancel it manually.
  ///
  static String show({
    required BuildContext context,
    required String message,
    String? toastId,
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
    VoidCallback? onDismiss,
    bool isAutoDismissible = true,
  }) {
    // Context validation
    if (!context.mounted) {
      throw ToastifyException(
        'Context Unmounted: The BuildContext is not mounted. Ensure you check context.mounted before calling Toastify.show().',
      );
    }

    // Message validation (using trim().isEmpty check)
    if (message.trim().isEmpty) {
      throw ToastifyException(
        'Invalid Message: The message cannot be empty or consist only of whitespace.',
      );
    }

    // Length validation (using string interpolation)
    if (message.length < 5) {
      throw ToastifyException(
        'Message Too Short: The message length (${message.length}) is below the required minimum of 5 characters.',
      );
    }

    final id = toastId ?? UniqueKey().toString();

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
      onDismiss: onDismiss,
      isAutoDismissible: isAutoDismissible,
    );

    _manager.showToast(context: context, details: details);
    return id;
  }

  static bool dismissById(String id) => _manager.dismissById(id);
  static bool dismissFirst() => _manager.dismissFirst();
  static bool dismissLast() => _manager.dismissLast();
  static void dismissAll() => _manager.dismissAll();
}
