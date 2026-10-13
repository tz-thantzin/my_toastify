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
        onPauseTimer: () => _pauseTimer(entry),
        onResumeTimer: () => _resumeTimer(entry, details.onDismiss),
      ),
    );

    final queueEntry = _ToastQueueEntry(
      id: details.id,
      entry: entry,
      style: details.style,
      position: details.position,
      createdAt: DateTime.now(),
      remainingDuration: details.duration,
    );

    queueEntry.mountedStateListener = () {
      if (entry.mounted) {
        return;
      }

      entry.removeListener(queueEntry.mountedStateListener!);
      queueEntry.dismissTimer?.cancel();
      _entries.removeWhere((e) => e.entry == entry);
    };

    entry.addListener(queueEntry.mountedStateListener!);

    _entries.add(queueEntry);
    overlay.insert(entry);

    if (details.isAutoDismissible) {
      _startTimer(queueEntry, details.onDismiss);
    }
  }

  void _startTimer(_ToastQueueEntry entry, VoidCallback? onDismiss) {
    entry.timerStopwatch = Stopwatch()..start();
    entry.dismissTimer = Timer(entry.remainingDuration, () {
      if (_entries.any((e) => e.entry == entry.entry && entry.entry.mounted)) {
        _remove(entry.entry, onDismiss);
      }
    });
  }

  void _pauseTimer(OverlayEntry overlayEntry) {
    final entry = _entries.cast<_ToastQueueEntry?>().firstWhere(
          (candidate) => candidate?.entry == overlayEntry,
          orElse: () => null,
        );
    if (entry == null || entry.dismissTimer == null) return;

    entry.timerStopwatch?.stop();
    entry.remainingDuration -= entry.timerStopwatch?.elapsed ?? Duration.zero;
    entry.dismissTimer?.cancel();
    entry.dismissTimer = null;
    entry.timerStopwatch = null;
  }

  void _resumeTimer(OverlayEntry overlayEntry, VoidCallback? onDismiss) {
    final entry = _entries.cast<_ToastQueueEntry?>().firstWhere(
          (candidate) => candidate?.entry == overlayEntry,
          orElse: () => null,
        );
    if (entry == null || entry.dismissTimer != null) return;

    if (entry.remainingDuration <= Duration.zero) {
      _remove(overlayEntry, onDismiss);
    } else {
      _startTimer(entry, onDismiss);
    }
  }

  void _remove(OverlayEntry entry, VoidCallback? callback) {
    final index = _entries.indexWhere((e) => e.entry == entry);
    if (index == -1) return;

    final removedEntry = _entries.removeAt(index);
    removedEntry.dismissTimer?.cancel();
    if (removedEntry.mountedStateListener != null) {
      entry.removeListener(removedEntry.mountedStateListener!);
    }
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
      e.dismissTimer?.cancel();
      if (e.mountedStateListener != null) {
        e.entry.removeListener(e.mountedStateListener!);
      }

      if (animated && e.entry.mounted) {
        e.entry.markNeedsBuild(); // trigger exit animation
      } else if (e.entry.mounted) {
        e.entry.remove();
      }
    }
    _entries.clear();
  }
}
