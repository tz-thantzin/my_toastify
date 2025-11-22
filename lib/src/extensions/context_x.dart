part of '../toastify.dart';

extension ToastifyContextX on BuildContext {
  TextStyle get defaultTitleStyle => Theme.of(this).textTheme.titleMedium!
      .copyWith(color: Colors.white, fontWeight: FontWeight.bold);

  TextStyle get defaultMessageStyle =>
      Theme.of(this).textTheme.bodyMedium!.copyWith(color: Colors.white);
}
