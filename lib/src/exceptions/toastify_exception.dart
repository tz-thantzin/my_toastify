/// Custom exception for Toastify
class ToastifyException implements Exception {
  final String message;
  ToastifyException(this.message);

  @override
  String toString() => "ToastifyException: $message";
}
