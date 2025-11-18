part of '../toastify_core.dart';

extension ContextStyle on BuildContext {
  TextStyle get defaultTitleStyle =>
      Theme.of(this).textTheme.titleMedium!.copyWith(color: Colors.white);

  TextStyle get defaultMessageStyle =>
      Theme.of(this).textTheme.bodyMedium!.copyWith(color: Colors.white);
}
