part of '../toastify_core.dart';

class ToastEntry {
  final String id;
  final OverlayEntry entry;
  final ToastStyle style;
  final ToastPosition position;

  ToastEntry({
    required this.id,
    required this.entry,
    required this.style,
    required this.position,
  });
}
