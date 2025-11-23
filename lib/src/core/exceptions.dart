part of '../toastify.dart';

/// Exception thrown by Toastify when invalid parameters are supplied.
///
/// Currently thrown when:
/// - The [BuildContext] is not mounted
/// - The message is empty, whitespace-only, or shorter than 5 characters
class ToastifyException implements Exception {
  /// The error message describing what went wrong.
  final String message;

  /// Creates a new [ToastifyException] with the provided [message].
  const ToastifyException(this.message);

  @override
  String toString() => 'ToastifyException: $message';
}
