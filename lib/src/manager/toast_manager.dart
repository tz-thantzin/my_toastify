part of '../toastify_core.dart';

class ToastManager {
  static final ToastManager _instance = ToastManager._internal();
  factory ToastManager() => _instance;
  ToastManager._internal();

  final List<ToastEntry> _entries = [];

  void showToast({
    required BuildContext context,
    required ToastDetails details,
  }) {
    assert(
      context.mounted,
      'Toastify.show() called with an unmounted BuildContext.',
    );

    final overlay = Overlay.of(context);
    late final OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        final sameGroup = _entries
            .where(
              (e) => e.style == details.style && e.position == details.position,
            )
            .toList();

        final currentEntry = ToastEntry(
          id: details.id,
          entry: overlayEntry,
          style: details.style,
          position: details.position,
        );

        final allToasts = [...sameGroup, currentEntry];

        int newestIndex = allToasts.length - 1;

        int currentToastIndex = allToasts.indexWhere(
          (e) => e.entry == overlayEntry,
        );

        // Calculate index from newest (0 = newest, 1 = second newest, etc.)
        int indexFromNewest = newestIndex - currentToastIndex;

        int effectiveIndex = indexFromNewest.clamp(0, 3) - 1;

        // Scale logic
        double scale;
        if (effectiveIndex == 0) {
          scale = 1.0;
        } else if (effectiveIndex == 1) {
          scale = 0.95;
        } else {
          scale = 0.92;
        }

        // Offset logic
        // Non-banner toasts stack with a 16px gap.
        // Banners stack with a 16px gap *relative to the screen edge*.
        double baseOffset = 16.0;
        double offset = effectiveIndex * baseOffset;

        final isBanner = details.style == ToastStyle.bannerStyle;
        final safeArea = MediaQuery.of(context).viewPadding;

        double? posTop, posBottom;
        if (details.position == ToastPosition.top) {
          // Banners position from the screen edge (top: 0 + offset)
          // Non-banners position from the safe area (top: safeArea + 16 + offset)
          posTop = isBanner ? offset : (safeArea.top + 16.0 + offset);
        } else {
          posBottom = isBanner ? offset : (safeArea.bottom + 16.0 + offset);
        }

        return Positioned(
          top: posTop,
          bottom: posBottom,
          left: isBanner ? 0 : 16,
          right: isBanner ? 0 : 16,
          child: AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            child: ToastWidget(
              details: details,
              onDismiss: () {
                _removeToast(overlayEntry);
                details.onDismiss?.call();
              },
            ),
          ),
        );
      },
    );

    // Add the new entry to the *actual* list
    _entries.add(
      ToastEntry(
        id: details.id,
        entry: overlayEntry,
        style: details.style,
        position: details.position,
      ),
    );

    // Rebuild all other toasts in the same group to update their scale and offset
    for (var e in _entries.where(
      (x) =>
          x.style == details.style &&
          x.position == details.position &&
          x.entry != overlayEntry,
    )) {
      e.entry.markNeedsBuild();
    }

    overlay.insert(overlayEntry);
    if (details.isAutoDismissible) {
      Timer(details.duration, () {
        _removeToast(overlayEntry);
        details.onDismiss?.call();
      });
    }
  }

  void _removeToast(OverlayEntry entry) {
    final index = _entries.indexWhere((e) => e.entry == entry);
    if (index != -1) {
      final style = _entries[index].style;
      final position = _entries[index].position;

      _entries[index].entry.remove();
      _entries.removeAt(index);

      // Rebuild remaining same-group toasts
      for (var e in _entries.where(
        (x) => x.style == style && x.position == position,
      )) {
        e.entry.markNeedsBuild();
      }
    }
  }

  bool dismissById(String id) {
    final index = _entries.indexWhere((e) => e.id == id);
    if (index == -1) return false;

    _entries[index].entry.remove();
    _entries.removeAt(index);
    return true;
  }

  bool dismissFirst() {
    if (_entries.isEmpty) return false;
    return dismissById(_entries.first.id);
  }

  bool dismissLast() {
    if (_entries.isEmpty) return false;
    return dismissById(_entries.last.id);
  }

  void dismissAll() {
    for (var e in _entries) {
      e.entry.remove();
    }
    _entries.clear();
  }
}
