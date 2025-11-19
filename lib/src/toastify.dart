part of 'toastify_core.dart';

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
  /// - **type** *(default: .info)*:
  ///   Controls color/theme (info, success, warning, error).
  ///
  /// - **position** *(default: .bottom)*:
  ///   Display location: top or bottom.
  ///
  /// - **style** *(default: .snackBarStyle)*:
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
  /// - **animationDuration** *(default: 500ms)*:
  ///   Controls how long the fade/slide animation takes.
  ///
  /// - **animationCurve** *(default: Curves.easeOut)*:
  ///   Defines the curve used for the entrance and exit animations.
  ///
  /// ---
  /// ### Animations
  ///
  /// Toasts are displayed using:
  ///
  /// - **Fade animation** when appearing and disappearing.
  /// - **Slide animation** based on the toast position:
  ///     - From the top → slides down into view.
  ///     - From the bottom → slides up into view.
  ///
  /// Both animations are driven by an internal `AnimationController`,
  /// which is disposed automatically when the toast is removed.
  ///
  /// ---
  /// ### Returns
  ///
  /// A `String` ID representing the toast.
  /// Can be used with `dismissById(id)` to cancel it manually.
  static String show(
    BuildContext context, {
    required String message,
    String? toastId,
    String? title,
    ToastType type = .info,
    ToastPosition position = .bottom,
    ToastStyle style = .snackBarStyle,
    TextStyle? titleTextStyle,
    TextStyle? messageTextStyle,
    Widget? leading,
    Widget? action,
    Color? backgroundColor,
    Color? borderColor,
    List<BoxShadow>? boxShadow,
    Duration duration = const Duration(seconds: 3),
    Curve appearCurve = Curves.easeOutBack, // V.1.1.0
    Curve dismissCurve = Curves.easeIn, // V.1.1.0
    Duration animationDuration = const Duration(milliseconds: 250), // V.1.1.0
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
      appearCurve: appearCurve,
      dismissCurve: dismissCurve,
      animationDuration: animationDuration,
      onDismiss: onDismiss,
      isAutoDismissible: isAutoDismissible,
    );

    _manager.showToast(context: context, details: details);
    return id;
  }

  /// Dismisses a toast by its unique [id].
  ///
  /// Returns `true` if a matching toast was found and dismissed,
  /// otherwise returns `false`.
  static bool dismissById(String id) => _manager.dismissById(id);

  /// Dismisses the **oldest (first)** toast in the queue.
  ///
  /// Returns `true` if a toast was dismissed, otherwise `false`.
  static bool dismissFirst() => _manager.dismissFirst();

  /// Dismisses the **most recent (last)** toast in the queue.
  ///
  /// Returns `true` if a toast was dismissed, otherwise `false`.
  static bool dismissLast() => _manager.dismissLast();

  /// Dismisses **all active toasts** at once.
  ///
  /// Use this when you need to clear the overlay immediately.
  static void dismissAll() => _manager.dismissAll();
}
