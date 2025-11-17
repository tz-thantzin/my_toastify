/// Custom exception for Toastify library
class ToastifyException implements Exception {
  final String message;
  ToastifyException(this.message);

  @override
  String toString() => "ToastifyException: $message";
}
