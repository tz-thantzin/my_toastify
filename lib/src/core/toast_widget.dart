part of '../toastify.dart';

class _ToastStackHost extends StatefulWidget {
  final ToastDetails details;
  final List<_ToastQueueEntry> allEntries;
  final OverlayEntry currentEntry;
  final VoidCallback onDismiss;

  const _ToastStackHost({
    required this.details,
    required this.allEntries,
    required this.currentEntry,
    required this.onDismiss,
  });

  @override
  State<_ToastStackHost> createState() => _ToastStackHostState();
}

class _ToastStackHostState extends State<_ToastStackHost>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.details.animationDuration,
    );

    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.details.appearCurve,
        reverseCurve: widget.details.dismissCurve,
      ),
    );

    _slide = Tween<Offset>(
      begin: Offset(
        0,
        widget.details.position == ToastPosition.top ? -0.8 : 0.8,
      ),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.details.appearCurve,
        reverseCurve: widget.details.dismissCurve,
      ),
    );

    _controller.forward();
  }

  void dismiss() {
    if (_isDismissing || !mounted) return;
    _isDismissing = true;
    _controller.reverse().then((_) => widget.onDismiss());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sameGroup = widget.allEntries
        .where(
          (e) =>
              e.style == widget.details.style &&
              e.position == widget.details.position,
        )
        .toList();

    final reversed = sameGroup.reversed.toList();
    final int indexFromNewest = reversed.indexWhere(
      (e) => e.entry == widget.currentEntry,
    );

    if (indexFromNewest == -1 || indexFromNewest >= 3) {
      return const SizedBox.shrink();
    }

    final int effectiveIndex = indexFromNewest;

    final double scale = switch (effectiveIndex) {
      0 => 1.0,
      1 => 0.95,
      _ => 0.90,
    };

    final bool isBanner = widget.details.style == ToastStyle.banner;
    final bool isTop = widget.details.position == ToastPosition.top;

    final double gap = isBanner ? 20.0 : 16.0;
    final double offsetY = effectiveIndex * gap;

    final double safeTop = MediaQuery.of(context).viewPadding.top;
    final double safeBottom = MediaQuery.of(context).viewPadding.bottom;

    double? top, bottom;
    if (isTop) {
      top = isBanner ? offsetY : safeTop + 16.0 + offsetY;
    } else {
      bottom = isBanner ? offsetY : safeBottom + 16.0 + offsetY;
    }

    return Positioned(
      top: top,
      bottom: bottom,
      left: isBanner ? 0.0 : 16.0,
      right: isBanner ? 0.0 : 16.0,
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Transform.scale(
            scale: scale,
            alignment: isTop ? Alignment.topCenter : Alignment.bottomCenter,
            child: Dismissible(
              key: ValueKey(widget.details.id),
              direction: DismissDirection.horizontal,
              onDismissed: (_) => dismiss(),
              child: _ToastContent(details: widget.details, onTap: dismiss),
            ),
          ),
        ),
      ),
    );
  }
}

class _ToastContent extends StatelessWidget {
  final ToastDetails details;
  final VoidCallback? onTap;

  const _ToastContent({required this.details, this.onTap});

  Color _bgColor() => switch (details.type) {
        ToastType.error => Colors.redAccent,
        ToastType.warning => Colors.orangeAccent,
        ToastType.success => Colors.green,
        _ => Colors.blueAccent,
      };

  Widget _icon() => switch (details.type) {
        ToastType.error => const Icon(Icons.error_outline, color: Colors.white),
        ToastType.warning => const Icon(
            Icons.warning_amber_outlined,
            color: Colors.white,
          ),
        ToastType.success => const Icon(
            Icons.check_circle_outline,
            color: Colors.white,
          ),
        _ => const Icon(Icons.info_outline, color: Colors.white),
      };

  @override
  Widget build(BuildContext context) {
    final bg = details.backgroundColor ?? _bgColor();
    final isBanner = details.style == ToastStyle.banner;
    final isTop = details.position == ToastPosition.top;
    final safeTop = MediaQuery.of(context).viewPadding.top;
    final safeBottom = MediaQuery.of(context).viewPadding.bottom;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          constraints: details.style == ToastStyle.banner
              ? const BoxConstraints(minHeight: 120, minWidth: double.infinity)
              : const BoxConstraints(minHeight: 60),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: isBanner && isTop ? safeTop + 28 : 24,
            bottom: isBanner && !isTop ? safeBottom + 28 : 24,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: isBanner
                ? (isTop
                    ? const BorderRadius.only(
                        bottomLeft: Radius.circular(28),
                        bottomRight: Radius.circular(28),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ))
                : BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.32),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: details.leading ?? _icon(),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (details.title != null)
                      Text(
                        details.title!,
                        style: details.titleTextStyle ??
                            context.defaultTitleStyle.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (details.title != null) const SizedBox(height: 6),
                    Text(
                      details.message,
                      style: details.messageTextStyle ??
                          context.defaultMessageStyle.copyWith(fontSize: 15),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (details.action != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: details.action!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
