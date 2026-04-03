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

    final animation = CurvedAnimation(
      parent: _controller,
      curve: widget.details.appearCurve,
      reverseCurve: widget.details.dismissCurve,
    );

    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(animation);
    _slide = Tween<Offset>(
      begin: Offset(
        0,
        widget.details.position == ToastPosition.top ? -0.8 : 0.8,
      ),
      end: Offset.zero,
    ).animate(animation);

    _controller.forward();
  }

  void dismiss() {
    if (_isDismissing || !mounted) {
      return;
    }

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
    final entriesInGroup = widget.allEntries
        .where(
          (entry) =>
              entry.style == widget.details.style &&
              entry.position == widget.details.position,
        )
        .toList(growable: false)
        .reversed
        .toList(growable: false);

    final stackIndex = entriesInGroup.indexWhere(
      (entry) => entry.entry == widget.currentEntry,
    );

    if (stackIndex == -1 || stackIndex >= 3) {
      return const SizedBox.shrink();
    }

    final layout = _ToastLayoutResolver(
      context: context,
      details: widget.details,
      stackIndex: stackIndex,
    ).resolve();

    return Positioned(
      top: layout.top,
      bottom: layout.bottom,
      left: 0,
      right: 0,
      child: Padding(
        padding: layout.outerPadding,
        child: Align(
          alignment: layout.alignment,
          child: _buildResponsiveToast(layout.scale),
        ),
      ),
    );
  }

  Widget _buildResponsiveToast(double scale) {
    Widget child = _AnimatedToast(
      id: widget.details.id,
      fade: _fade,
      slide: _slide,
      scale: scale,
      position: widget.details.position,
      onDismissed: dismiss,
      child: _ToastContent(details: widget.details, onTap: dismiss),
    );

    if (widget.details.maxWidth != null) {
      child = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.details.maxWidth!),
        child: child,
      );
    }

    if (widget.details.widthFactor != null) {
      child = FractionallySizedBox(
        widthFactor: widget.details.widthFactor,
        alignment: _fractionalAlignment,
        child: child,
      );
    } else if (widget.details.horizontalAlignment ==
        ToastHorizontalAlignment.stretch) {
      child = SizedBox(width: double.infinity, child: child);
    }

    return child;
  }

  Alignment get _fractionalAlignment => switch (widget.details.horizontalAlignment) {
        ToastHorizontalAlignment.start => Alignment.centerLeft,
        ToastHorizontalAlignment.end => Alignment.centerRight,
        _ => Alignment.center,
      };
}

class _AnimatedToast extends StatelessWidget {
  final String id;
  final Animation<double> fade;
  final Animation<Offset> slide;
  final double scale;
  final ToastPosition position;
  final VoidCallback onDismissed;
  final Widget child;

  const _AnimatedToast({
    required this.id,
    required this.fade,
    required this.slide,
    required this.scale,
    required this.position,
    required this.onDismissed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: slide,
          child: Transform.scale(
            scale: scale,
            alignment: position == ToastPosition.top
                ? Alignment.topCenter
                : Alignment.bottomCenter,
            child: Dismissible(
              key: ValueKey(id),
              direction: DismissDirection.horizontal,
              onDismissed: (_) => onDismissed(),
              child: child,
            ),
          ),
        ),
      );
}

class _ToastLayoutResolver {
  final BuildContext context;
  final ToastDetails details;
  final int stackIndex;

  const _ToastLayoutResolver({
    required this.context,
    required this.details,
    required this.stackIndex,
  });

  _ToastLayoutSpec resolve() {
    final mediaQuery = MediaQuery.of(context);
    final safeTop = mediaQuery.viewPadding.top;
    final safeBottom = mediaQuery.viewPadding.bottom;
    final isTop = details.position == ToastPosition.top;
    final isBanner = details.style == ToastStyle.banner;
    final stackOffset = stackIndex * (isBanner ? 20.0 : 16.0);

    final outerPadding = EdgeInsets.only(
      left: 16,
      right: 16,
      top: isTop ? (isBanner ? stackOffset : safeTop + 16 + stackOffset) : 0,
      bottom: isTop
          ? 0
          : (isBanner ? stackOffset : safeBottom + 16 + stackOffset),
    );

    return _ToastLayoutSpec(
      top: isTop ? 0 : null,
      bottom: isTop ? null : 0,
      outerPadding: outerPadding,
      alignment: switch (details.horizontalAlignment) {
        ToastHorizontalAlignment.start => Alignment.topLeft,
        ToastHorizontalAlignment.center => Alignment.topCenter,
        ToastHorizontalAlignment.end => Alignment.topRight,
        ToastHorizontalAlignment.stretch => Alignment.topCenter,
      },
      scale: switch (stackIndex) {
        0 => 1.0,
        1 => 0.95,
        _ => 0.90,
      },
    );
  }
}

class _ToastLayoutSpec {
  final double? top;
  final double? bottom;
  final EdgeInsets outerPadding;
  final Alignment alignment;
  final double scale;

  const _ToastLayoutSpec({
    required this.top,
    required this.bottom,
    required this.outerPadding,
    required this.alignment,
    required this.scale,
  });
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
    final backgroundColor = details.backgroundColor ?? _bgColor();
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
          constraints: isBanner
              ? const BoxConstraints(minHeight: 120, minWidth: double.infinity)
              : const BoxConstraints(minHeight: 60),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: isBanner && isTop ? safeTop + 28 : 24,
            bottom: isBanner && !isTop ? safeBottom + 28 : 24,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: details.borderColor == null
                ? null
                : Border.all(color: details.borderColor!),
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
            boxShadow: details.boxShadow ??
                [
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
