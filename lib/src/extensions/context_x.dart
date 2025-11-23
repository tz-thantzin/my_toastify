part of '../toastify.dart';

/// Extension that adds convenient default text styles for toast titles and messages
/// based on the current [Theme].
extension ToastifyContextX on BuildContext {
  /// Default bold white title style used when no custom [titleTextStyle] is provided.
  TextStyle get defaultTitleStyle => Theme.of(this)
      .textTheme
      .titleMedium!
      .copyWith(color: Colors.white, fontWeight: FontWeight.bold);

  /// Default white message style used when no custom [messageTextStyle] is provided.
  TextStyle get defaultMessageStyle =>
      Theme.of(this).textTheme.bodyMedium!.copyWith(color: Colors.white);
}
