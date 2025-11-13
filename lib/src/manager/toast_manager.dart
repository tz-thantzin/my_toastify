import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/toastify_enum.dart';
import '../models/toast_details.dart';

class ToastManager {
  static final ToastManager _instance = ToastManager._internal();
  factory ToastManager() => _instance;
  ToastManager._internal();

  final List<_ToastEntry> _entries = [];

  void showToast({
    required BuildContext context,
    required ToastDetails details,
  }) {
    final overlay = Overlay.of(context);
    late final OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        final sameGroup = _entries
            .where(
              (e) => e.style == details.style && e.position == details.position,
            )
            .toList();

        final currentEntry = _ToastEntry(
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
            child: _ToastWidget(
              details: details,
              onDismiss: () => _removeToast(overlayEntry),
            ),
          ),
        );
      },
    );

    // Add the new entry to the *actual* list
    _entries.add(
      _ToastEntry(
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

    Timer(details.duration, () => _removeToast(overlayEntry));
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

  void dismissAll() {
    for (var e in _entries) {
      e.entry.remove();
    }
    _entries.clear();
  }
}

class _ToastEntry {
  final OverlayEntry entry;
  final ToastStyle style;
  final ToastPosition position;

  _ToastEntry({
    required this.entry,
    required this.style,
    required this.position,
  });
}

class _ToastWidget extends StatelessWidget {
  final ToastDetails details;
  final VoidCallback onDismiss;

  const _ToastWidget({required this.details, required this.onDismiss});

  Color _backgroundColor() {
    switch (details.type) {
      case ToastType.error:
        return Colors.redAccent;
      case ToastType.warning:
        return Colors.orangeAccent;
      case ToastType.success:
        return Colors.green;
      default:
        return Colors.blueAccent;
    }
  }

  Widget _defaultIcon() {
    switch (details.type) {
      case ToastType.error:
        return const Icon(Icons.error_outline, color: Colors.white);
      case ToastType.warning:
        return const Icon(Icons.warning_amber_outlined, color: Colors.white);
      case ToastType.success:
        return const Icon(Icons.check_circle_outline, color: Colors.white);
      default:
        return const Icon(Icons.info_outline, color: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = details.backgroundColor ?? _backgroundColor();
    final iconToShow = details.leading ?? _defaultIcon();

    final titleStyle =
        details.titleTextStyle ??
        Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        );

    final messageStyle =
        details.messageTextStyle ??
        Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white);

    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(padding: const EdgeInsets.only(right: 12), child: iconToShow),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (details.title != null)
                Text(
                  details.title!,
                  style: titleStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              Text(
                details.message,
                style: messageStyle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (details.action != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: details.action,
          ),
      ],
    );

    final safeArea = MediaQuery.of(context).viewPadding;
    final isBanner = details.style == ToastStyle.bannerStyle;
    final isTop = details.position == ToastPosition.top;

    EdgeInsets toastPadding;
    if (isBanner) {
      toastPadding = const EdgeInsets.symmetric(horizontal: 24, vertical: 24);

      if (isTop) {
        toastPadding = toastPadding.copyWith(top: safeArea.top + 24);
      } else {
        toastPadding = toastPadding.copyWith(bottom: safeArea.bottom + 24);
      }
    } else {
      toastPadding = const EdgeInsets.all(14);
    }

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.horizontal,
      onDismissed: (_) => onDismiss(),
      child: Material(
        type: MaterialType.transparency,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: toastPadding,
          constraints: details.style == ToastStyle.bannerStyle
              ? const BoxConstraints(minHeight: 120, minWidth: double.infinity)
              : const BoxConstraints(minHeight: 60),
          decoration: BoxDecoration(
            color: baseColor,
            border: details.borderColor != null
                ? Border.all(color: details.borderColor!, width: 2)
                : null,
            borderRadius: details.style == ToastStyle.bannerStyle
                ? (details.position == ToastPosition.top
                      ? const BorderRadius.vertical(bottom: Radius.circular(24))
                      : const BorderRadius.vertical(top: Radius.circular(24)))
                : BorderRadius.circular(10),
            boxShadow:
                details.boxShadow ??
                const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
          ),
          child: content,
        ),
      ),
    );
  }
}
