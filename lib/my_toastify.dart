/// A beautiful, highly customizable toast/notification system for Flutter.
///
/// Toastify provides snack-bar, banner, and theme-aware minimal toast styles,
/// stacking behaviour, swipe-to-dismiss, custom icons/actions, theming,
/// and fine-grained control over position, duration, width and alignment.
///
/// ## Features
/// - Multiple toast styles: `ToastStyle.snackBar`, `ToastStyle.banner`, and
///   `ToastStyle.minimal`
/// - Stack up to 3 toasts with nice scale animation
/// - Top or bottom positioning
/// - Auto-dismiss with custom duration
/// - Swipe horizontally to dismiss
/// - Custom leading widget, action widget, colors, shadows, curves and layout
/// - Full control: dismiss by id, dismiss first/last, dismiss all
///
/// ## Quick example
/// ```dart
/// Toastify.show(
///   context,
///   message: 'Operation completed successfully!',
///   type: ToastType.success,
///   style: ToastStyle.banner,
///   position: ToastPosition.top,
/// );
/// ```
///
/// See the individual enums (`ToastType`, `ToastPosition`, `ToastStyle`)
/// for all available options.
library;

export 'src/toastify.dart';
