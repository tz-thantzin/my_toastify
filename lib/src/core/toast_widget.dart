part of '../toastify.dart';

class _ToastStackHost extends StatefulWidget {
  final ToastDetails details;
  final List<_ToastQueueEntry> allEntries;
  final OverlayEntry currentEntry;
  final VoidCallback onDismiss;
  final VoidCallback onPauseTimer;
  final VoidCallback onResumeTimer;

  const _ToastStackHost({
    required this.details,
    required this.allEntries,
    required this.currentEntry,
    required this.onDismiss,
    required this.onPauseTimer,
    required this.onResumeTimer,
  });

  @override
  State<_ToastStackHost> createState() => _ToastStackHostState();
}

class _ToastStackHostState extends State<_ToastStackHost>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  AnimationController? _progressController;
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
        widget.details.position.isCenter
            ? 0
            : widget.details.position.isTop
                ? -0.8
                : 0.8,
      ),
      end: Offset.zero,
    ).animate(animation);

    _controller.forward();

    if (widget.details.showProgressBar && widget.details.isAutoDismissible) {
      _progressController = AnimationController(
        vsync: this,
        duration: widget.details.duration,
      )..forward();
    }
  }

  void dismiss() {
    if (_isDismissing || !mounted) {
      return;
    }

    _isDismissing = true;
    _controller.reverse().then((_) => widget.onDismiss());
  }

  void pauseTimer() {
    if (!widget.details.pauseOnInteraction) return;
    widget.onPauseTimer();
    _progressController?.stop();
  }

  void resumeTimer() {
    if (!widget.details.pauseOnInteraction) return;
    widget.onResumeTimer();
    _progressController?.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _progressController?.dispose();
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
    final isPositioned = widget.details.position.isCenter ||
        widget.details.position == ToastPosition.topLeft ||
        widget.details.position == ToastPosition.topRight ||
        widget.details.position == ToastPosition.bottomLeft ||
        widget.details.position == ToastPosition.bottomRight;
    final maxWidth = widget.details.maxWidth ??
        (widget.details.style == ToastStyle.minimal || isPositioned
            ? 420.0
            : null);
    Widget child = _AnimatedToast(
      id: widget.details.id,
      fade: _fade,
      slide: _slide,
      scale: scale,
      position: widget.details.position,
      onDismissed: dismiss,
      onPauseTimer: pauseTimer,
      onResumeTimer: resumeTimer,
      progress: _progressController,
      child: _ToastContent(
        details: widget.details,
        onTap: dismiss,
        progress: _progressController,
      ),
    );

    if (maxWidth != null) {
      child = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
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
            ToastHorizontalAlignment.stretch &&
        maxWidth == null) {
      child = SizedBox(width: double.infinity, child: child);
    }

    return child;
  }

  Alignment get _fractionalAlignment => switch (widget.details.position) {
        ToastPosition.topLeft ||
        ToastPosition.bottomLeft =>
          Alignment.centerLeft,
        ToastPosition.topRight ||
        ToastPosition.bottomRight =>
          Alignment.centerRight,
        ToastPosition.center => Alignment.center,
        _ => switch (widget.details.horizontalAlignment) {
            ToastHorizontalAlignment.start => Alignment.centerLeft,
            ToastHorizontalAlignment.end => Alignment.centerRight,
            _ => Alignment.center,
          },
      };
}

class _AnimatedToast extends StatelessWidget {
  final String id;
  final Animation<double> fade;
  final Animation<Offset> slide;
  final double scale;
  final ToastPosition position;
  final VoidCallback onDismissed;
  final VoidCallback onPauseTimer;
  final VoidCallback onResumeTimer;
  final Animation<double>? progress;
  final Widget child;

  const _AnimatedToast({
    required this.id,
    required this.fade,
    required this.slide,
    required this.scale,
    required this.position,
    required this.onDismissed,
    required this.onPauseTimer,
    required this.onResumeTimer,
    required this.progress,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => onPauseTimer(),
        onExit: (_) => onResumeTimer(),
        child: GestureDetector(
          onLongPressStart: (_) => onPauseTimer(),
          onLongPressEnd: (_) => onResumeTimer(),
          child: FadeTransition(
            opacity: fade,
            child: SlideTransition(
              position: slide,
              child: Transform.scale(
                scale: scale,
                alignment: position.isCenter
                    ? Alignment.center
                    : position.isTop
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
    final isTop = details.position.isTop;
    final isBottom = details.position.isBottom;
    final isCenter = details.position.isCenter;
    final isBanner = details.style == ToastStyle.banner;
    final stackOffset = stackIndex * (isBanner ? 20.0 : 16.0);

    final outerPadding = EdgeInsets.only(
      left: 16,
      right: 16,
      top: isCenter
          ? 16
          : isTop
              ? (isBanner ? stackOffset : safeTop + 16 + stackOffset)
              : 0,
      bottom: isCenter
          ? 16
          : isBottom
              ? (isBanner ? stackOffset : safeBottom + 16 + stackOffset)
              : 0,
    );

    return _ToastLayoutSpec(
      top: isTop || isCenter ? 0 : null,
      bottom: isBottom || isCenter ? 0 : null,
      outerPadding: outerPadding,
      alignment: switch (details.position) {
        ToastPosition.topLeft => Alignment.topLeft,
        ToastPosition.topRight => Alignment.topRight,
        ToastPosition.bottomLeft => Alignment.bottomLeft,
        ToastPosition.bottomRight => Alignment.bottomRight,
        ToastPosition.center => Alignment.center,
        _ => switch (details.horizontalAlignment) {
            ToastHorizontalAlignment.start => Alignment.topLeft,
            ToastHorizontalAlignment.center => Alignment.topCenter,
            ToastHorizontalAlignment.end => Alignment.topRight,
            ToastHorizontalAlignment.stretch => Alignment.topCenter,
          },
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
  final Animation<double>? progress;

  const _ToastContent({required this.details, this.progress, this.onTap});

  Color _bgColor() =>
      details.theme?.accentFor(details.type) ??
      switch (details.type) {
        ToastType.error => Colors.redAccent,
        ToastType.warning => Colors.orangeAccent,
        ToastType.success => Colors.green,
        _ => Colors.blueAccent,
      };

  Widget _icon(Color color) => switch (details.type) {
        ToastType.error => Icon(Icons.error_outline, color: color),
        ToastType.warning => Icon(
            Icons.warning_amber_outlined,
            color: color,
          ),
        ToastType.success => Icon(
            Icons.check_circle_outline,
            color: color,
          ),
        _ => Icon(Icons.info_outline, color: color),
      };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accentColor = _bgColor();
    final isMinimal = details.style == ToastStyle.minimal;
    final backgroundColor = details.backgroundColor ??
        (isMinimal
            ? details.theme?.surfaceColor ?? colorScheme.surface
            : accentColor);
    final foregroundColor = details.theme?.foregroundColor ??
        (isMinimal
            ? (details.backgroundColor == null
                ? colorScheme.onSurface
                : ThemeData.estimateBrightnessForColor(backgroundColor) ==
                        Brightness.dark
                    ? Colors.white
                    : Colors.black)
            : Colors.white);
    final isBanner = details.style == ToastStyle.banner;
    final isTop = details.position.isTop;
    final safeTop = MediaQuery.of(context).viewPadding.top;
    final safeBottom = MediaQuery.of(context).viewPadding.bottom;

    return Semantics(
      container: true,
      liveRegion: details.announceToScreenReader,
      label: details.semanticLabel,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            constraints: isBanner
                ? const BoxConstraints(
                    minHeight: 120, minWidth: double.infinity)
                : const BoxConstraints(minHeight: 60),
            padding: isMinimal
                ? const EdgeInsets.symmetric(horizontal: 16, vertical: 14)
                : EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: isBanner && isTop ? safeTop + 28 : 24,
                    bottom: isBanner && !isTop ? safeBottom + 28 : 24,
                  ),
            decoration: BoxDecoration(
              color: backgroundColor,
              border: details.borderColor != null
                  ? Border.all(color: details.borderColor!)
                  : isMinimal
                      ? Border.all(color: colorScheme.outlineVariant)
                      : null,
              borderRadius: details.theme?.borderRadius ??
                  (isMinimal
                      ? BorderRadius.circular(18)
                      : isBanner
                          ? (isTop
                              ? const BorderRadius.only(
                                  bottomLeft: Radius.circular(28),
                                  bottomRight: Radius.circular(28),
                                )
                              : const BorderRadius.only(
                                  topLeft: Radius.circular(28),
                                  topRight: Radius.circular(28),
                                ))
                          : BorderRadius.circular(14)),
              boxShadow: details.boxShadow ??
                  details.theme?.boxShadow ??
                  [
                    BoxShadow(
                      color: Colors.black
                          .withValues(alpha: isMinimal ? 0.12 : 0.32),
                      blurRadius: isMinimal ? 18 : 20,
                      offset: Offset(0, isMinimal ? 6 : 8),
                    ),
                  ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: isMinimal ? 12 : 14),
                      child: details.leading ??
                          (isMinimal
                              ? DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: accentColor.withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: _icon(accentColor),
                                  ),
                                )
                              : _icon(foregroundColor)),
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
                                    color: foregroundColor,
                                    fontSize: isMinimal ? 15 : 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          if (details.title != null) const SizedBox(height: 6),
                          Text(
                            details.message,
                            style: details.messageTextStyle ??
                                context.defaultMessageStyle.copyWith(
                                  color: foregroundColor,
                                  fontSize: isMinimal ? 14 : 15,
                                ),
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
                if (details.showProgressBar && progress != null) ...[
                  const SizedBox(height: 12),
                  AnimatedBuilder(
                    animation: progress!,
                    builder: (context, _) => LinearProgressIndicator(
                      value: 1 - progress!.value,
                      minHeight: 3,
                      backgroundColor: (isMinimal ? accentColor : Colors.white)
                          .withValues(alpha: 0.28),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isMinimal ? accentColor : Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
