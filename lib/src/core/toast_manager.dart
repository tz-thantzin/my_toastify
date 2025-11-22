part of '../toastify.dart';

class _ToastManager {
  _ToastManager._();
  static final _ToastManager instance = _ToastManager._();

  final List<_ToastQueueEntry> _entries = [];

  void show(BuildContext context, ToastDetails details) {
    if (!context.mounted) return;

    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _ToastStackHost(
        details: details,
        allEntries: _entries,
        currentEntry: entry,
        onDismiss: () => _remove(entry, details.onDismiss),
      ),
    );

    final queueEntry = _ToastQueueEntry(
      id: details.id,
      entry: entry,
      style: details.style,
      position: details.position,
      createdAt: DateTime.now(),
    );

    _entries.add(queueEntry);
    overlay.insert(entry);

    if (details.isAutoDismissible) {
      Timer(details.duration, () {
        if (_entries.any((e) => e.entry == entry && entry.mounted)) {
          _remove(entry, details.onDismiss);
        }
      });
    }
  }

  void _remove(OverlayEntry entry, VoidCallback? callback) {
    final index = _entries.indexWhere((e) => e.entry == entry);
    if (index == -1) return;

    _entries.removeAt(index);
    if (entry.mounted) {
      entry.remove();
    }
    callback?.call();

    // Rebuild remaining entries in same group
    final remaining = _entries.where((e) => e.entry.mounted);
    for (final e in remaining) {
      e.entry.markNeedsBuild();
    }
  }

  bool dismissById(String id) {
    final entry = _entries.cast<_ToastQueueEntry?>().firstWhere(
      (e) => e?.id == id,
      orElse: () => null,
    );
    if (entry == null) return false;
    _remove(entry.entry, null);
    return true;
  }

  bool dismissFirst() =>
      _entries.isNotEmpty ? dismissById(_entries.first.id) : false;
  bool dismissLast() =>
      _entries.isNotEmpty ? dismissById(_entries.last.id) : false;

  void dismissAll({bool animated = true}) {
    for (final e in List.of(_entries)) {
      if (animated && e.entry.mounted) {
        e.entry.markNeedsBuild(); // trigger exit animation
      } else {
        e.entry.remove();
      }
    }
    _entries.clear();
  }
}
