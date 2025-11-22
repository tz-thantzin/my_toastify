part of '../toastify.dart';

class ToastifyException implements Exception {
  final String message;
  const ToastifyException(this.message);

  @override
  String toString() => 'ToastifyException: $message';
}
