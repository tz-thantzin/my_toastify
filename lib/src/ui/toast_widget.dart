part of '../toastify_core.dart';

class ToastWidget extends StatefulWidget {
  final ToastDetails details;
  final VoidCallback onDismiss;

  const ToastWidget({required this.details, required this.onDismiss});

  @override
  State<ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool _dismissTriggered = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.details.animationDuration,
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.details.appearCurve,
      reverseCurve: widget.details.dismissCurve,
    );

    // Start appear animation
    _controller.forward();

    // Auto dismiss logic
    if (widget.details.isAutoDismissible) {
      Future.delayed(widget.details.duration, () {
        if (mounted) dismiss();
      });
    }
  }

  void dismiss() {
    if (_dismissTriggered) return;
    _dismissTriggered = true;

    _controller.reverse();

    Future.delayed(widget.details.animationDuration, () {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _backgroundColor() {
    switch (widget.details.type) {
      case .error:
        return Colors.redAccent;
      case .warning:
        return Colors.orangeAccent;
      case .success:
        return Colors.green;
      default:
        return Colors.blueAccent;
    }
  }

  Widget _defaultIcon() {
    switch (widget.details.type) {
      case .error:
        return const Icon(Icons.error_outline, color: Colors.white);
      case .warning:
        return const Icon(Icons.warning_amber_outlined, color: Colors.white);
      case .success:
        return const Icon(Icons.check_circle_outline, color: Colors.white);
      default:
        return const Icon(Icons.info_outline, color: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final details = widget.details;

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
    final isBanner = details.style == .bannerStyle;
    final isTop = details.position == .top;

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

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.horizontal,
        onDismissed: (_) => dismiss(),
        child: Material(
          type: MaterialType.transparency,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            padding: toastPadding,
            constraints: details.style == .bannerStyle
                ? const BoxConstraints(
                    minHeight: 120,
                    minWidth: double.infinity,
                  )
                : const BoxConstraints(minHeight: 60),
            decoration: BoxDecoration(
              color: baseColor,
              border: details.borderColor != null
                  ? Border.all(color: details.borderColor!, width: 2)
                  : null,
              borderRadius: details.style == .bannerStyle
                  ? (details.position == .top
                        ? const BorderRadius.vertical(
                            bottom: Radius.circular(24),
                          )
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
      ),
    );
  }
}
