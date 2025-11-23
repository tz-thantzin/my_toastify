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
  /// Throws a [ToastifyException] if the [context] is not mounted or if the
  /// [message] is empty/whitespace-only or shorter than 5 characters.
  ///
  /// ### Parameters
  ///
  /// @param context               The BuildContext used to insert the overlay.
  /// @param message               The main text content of the toast. Must be ≥ 5 characters.
  /// @param toastId               Optional custom identifier. If omitted, a unique id is generated.
  /// @param title                 Optional bold title displayed above the message.
  /// @param type                  Semantic type that sets default color and icon (info, success, warning, error).
  /// @param position              Screen position – [ToastPosition.top] or [ToastPosition.bottom].
  /// @param style                 Visual style – [ToastStyle.snackBar] (compact) or [ToastStyle.banner] (full-width).
  /// @param titleTextStyle        Custom style for the title; falls back to theme-based style.
  /// @param messageTextStyle      Custom style for the message; falls back to theme-based style.
  /// @param leading               Optional widget shown on the left (replaces default type icon).
  /// @param action                Optional trailing widget (e.g., a button).
  /// @param backgroundColor       Explicit background color. Overrides color derived from [type].
  /// @param borderColor           Reserved for future use (currently unused).
  /// @param boxShadow             Custom shadow list. If `null`, a default shadow is applied.
  /// @param duration              How long the toast stays visible when [isAutoDismissible] is true.
  /// @param appearCurve           Animation curve for the enter transition.
  /// @param dismissCurve          Animation curve for the exit transition.
  /// @param animationDuration     Duration of enter/exit animations.
  /// @param onDismiss             Callback invoked after the toast is fully removed.
  /// @param isAutoDismissible     If `false`, the toast stays until manually dismissed.
  ///
  /// ### Example
  /// ```dart
  /// Toastify.show(
  ///   context,
  ///   message: 'Profile updated successfully!',
  ///   type: ToastType.success,
  ///   style: ToastStyle.banner,
  ///   position: ToastPosition.top,
  /// );
  /// ```
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
