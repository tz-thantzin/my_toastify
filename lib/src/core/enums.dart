part of '../toastify.dart';

enum ToastType { info, error, warning, success }

enum ToastPosition { top, bottom }

enum ToastStyle {
  snackBar,
  banner,

  @Deprecated('Use ToastStyle.snackbar instead')
  snackBarStyle,

  @Deprecated('Use ToastStyle.banner instead')
  bannerStyle,
}
