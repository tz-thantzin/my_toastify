part of '../toastify.dart';

/// Controls what happens when a controller's visible toast limit is reached.
enum ToastQueuePolicy {
  /// Keep the new toast pending until a visible toast is dismissed.
  queue,

  /// Discard the new toast when the visible limit is reached.
  dropNewest,

  /// Dismiss the oldest toast to make room for the new toast.
  replaceOldest,
}

class _QueuedToast {
  const _QueuedToast(
      {required this.id, required this.show, this.deduplicationKey});

  final String id;
  final VoidCallback show;
  final String? deduplicationKey;
}

/// Controls toast notifications shown by a [ToastifyHost].
///
/// Create one controller and pass it to a host near the root of the app. The
/// controller can then be used by callbacks and services without passing a
/// [BuildContext] to each call.
class ToastifyController {
  /// Creates a controller with a limit on simultaneously visible toasts.
  ToastifyController({
    this.maxVisibleToasts = 3,
    this.queuePolicy = ToastQueuePolicy.queue,
    this.theme,
  }) : assert(maxVisibleToasts > 0);

  /// Maximum number of this controller's toasts shown at the same time.
  final int maxVisibleToasts;

  /// Policy used when [maxVisibleToasts] has been reached.
  final ToastQueuePolicy queuePolicy;

  /// Theme applied to controller toasts unless a toast supplies its own.
  final ToastifyThemeData? theme;

  BuildContext? _context;
  final List<String> _activeIds = [];
  final List<_QueuedToast> _pending = [];
  final Map<String, String> _activeDeduplicationKeys = {};
  static int _nextId = 0;

  void _attach(BuildContext context) => _context = context;

  void _detach(BuildContext context) {
    if (identical(_context, context)) {
      _context = null;
      for (final id in List<String>.of(_activeIds)) {
        Toastify.dismissById(id);
      }
      _activeIds.clear();
      _activeDeduplicationKeys.clear();
      _pending.clear();
    }
  }

  /// Shows a toast through the host and returns its generated identifier.
  ///
  /// Throws [ToastifyException] if no mounted [ToastifyHost] uses this
  /// controller.
  String show({
    required String message,
    String? toastId,
    String? title,
    ToastType type = ToastType.info,
    String? deduplicationKey,
    ToastifyThemeData? theme,
    String? semanticLabel,
    bool announceToScreenReader = true,
    ToastPosition position = ToastPosition.bottom,
    ToastStyle style = ToastStyle.snackBar,
    TextStyle? titleTextStyle,
    TextStyle? messageTextStyle,
    Widget? leading,
    Widget? action,
    Color? backgroundColor,
    Color? borderColor,
    List<BoxShadow>? boxShadow,
    double? widthFactor,
    double? maxWidth,
    ToastHorizontalAlignment horizontalAlignment =
        ToastHorizontalAlignment.stretch,
    Duration duration = const Duration(seconds: 3),
    Curve appearCurve = Curves.easeOutBack,
    Curve dismissCurve = Curves.easeInBack,
    Duration animationDuration = const Duration(milliseconds: 400),
    VoidCallback? onDismiss,
    bool isAutoDismissible = true,
    bool showProgressBar = false,
    bool pauseOnInteraction = true,
  }) {
    final context = _context;
    if (context == null || !context.mounted) {
      throw ToastifyException(
        'Cannot show toast: No mounted ToastifyHost is attached to this controller.',
      );
    }
    if (message.trim().isEmpty || message.length < 5) {
      throw ToastifyException(
        'Message must be at least 5 characters and not empty.',
      );
    }
    if (widthFactor != null && (widthFactor <= 0 || widthFactor > 1)) {
      throw ToastifyException(
        'widthFactor must be greater than 0 and less than or equal to 1.',
      );
    }
    if (maxWidth != null && maxWidth <= 0) {
      throw ToastifyException('maxWidth must be greater than 0.');
    }

    final id = toastId ??
        'toastify-${DateTime.now().microsecondsSinceEpoch}-${_nextId++}';
    if (_activeIds.contains(id) || _pending.any((toast) => toast.id == id)) {
      throw ToastifyException('A toast with id "$id" is already queued.');
    }
    late final _QueuedToast request;
    request = _QueuedToast(
      id: id,
      deduplicationKey: deduplicationKey,
      show: () {
        final attachedContext = _context;
        if (attachedContext == null || !attachedContext.mounted) return;
        _activeIds.add(id);
        if (deduplicationKey != null) {
          _activeDeduplicationKeys[deduplicationKey] = id;
        }
        Toastify.show(
          attachedContext,
          message: message,
          toastId: id,
          title: title,
          type: type,
          deduplicationKey: deduplicationKey,
          theme: theme ?? this.theme,
          semanticLabel: semanticLabel,
          announceToScreenReader: announceToScreenReader,
          position: position,
          style: style,
          titleTextStyle: titleTextStyle,
          messageTextStyle: messageTextStyle,
          leading: leading,
          action: action,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          boxShadow: boxShadow,
          widthFactor: widthFactor,
          maxWidth: maxWidth,
          horizontalAlignment: horizontalAlignment,
          duration: duration,
          appearCurve: appearCurve,
          dismissCurve: dismissCurve,
          animationDuration: animationDuration,
          onDismiss: () {
            _finish(id);
            onDismiss?.call();
          },
          isAutoDismissible: isAutoDismissible,
          showProgressBar: showProgressBar,
          pauseOnInteraction: pauseOnInteraction,
        );
      },
    );

    if (deduplicationKey != null) {
      final pendingIndex = _pending.indexWhere(
        (toast) => toast.deduplicationKey == deduplicationKey,
      );
      if (pendingIndex >= 0) {
        _pending[pendingIndex] = request;
        return id;
      }

      final activeId = _activeDeduplicationKeys[deduplicationKey];
      if (activeId != null) {
        Toastify.dismissById(activeId);
        _activeIds.remove(activeId);
        _activeDeduplicationKeys.remove(deduplicationKey);
        _pending.insert(0, request);
        _drain();
        return id;
      }
    }

    if (_activeIds.length < maxVisibleToasts) {
      _pending.add(request);
      _drain();
    } else {
      switch (queuePolicy) {
        case ToastQueuePolicy.queue:
          _pending.add(request);
        case ToastQueuePolicy.dropNewest:
          break;
        case ToastQueuePolicy.replaceOldest:
          if (_activeIds.isNotEmpty) {
            final oldestId = _activeIds.removeAt(0);
            Toastify.dismissById(oldestId);
            _pending.insert(0, request);
          } else if (_pending.isNotEmpty) {
            _pending.removeAt(0);
            _pending.add(request);
          }
          _drain();
      }
    }
    return id;
  }

  void _drain() {
    while (_activeIds.length < maxVisibleToasts && _pending.isNotEmpty) {
      _pending.removeAt(0).show();
    }
  }

  void _finish(String id) {
    _activeIds.remove(id);
    _activeDeduplicationKeys.removeWhere((_, activeId) => activeId == id);
    _drain();
  }

  /// Dismisses a toast by its id.
  bool dismissById(String id) {
    final pendingIndex = _pending.indexWhere((toast) => toast.id == id);
    if (pendingIndex >= 0) {
      _pending.removeAt(pendingIndex);
      return true;
    }
    if (!_activeIds.contains(id) || !Toastify.dismissById(id)) return false;
    _finish(id);
    return true;
  }

  /// Dismisses the oldest visible toast.
  bool dismissFirst() {
    if (_activeIds.isNotEmpty) return dismissById(_activeIds.first);
    return _pending.isNotEmpty ? dismissById(_pending.first.id) : false;
  }

  /// Dismisses the newest visible toast.
  bool dismissLast() {
    if (_pending.isNotEmpty) return dismissById(_pending.last.id);
    return _activeIds.isNotEmpty ? dismissById(_activeIds.last) : false;
  }

  /// Dismisses all currently visible toasts.
  void dismissAll() {
    _pending.clear();
    for (final id in List<String>.of(_activeIds)) {
      Toastify.dismissById(id);
    }
    _activeIds.clear();
    _activeDeduplicationKeys.clear();
  }
}

/// Provides a host context for notifications controlled by [controller].
///
/// Place this around the app content beneath [MaterialApp], usually in its
/// `builder`, so notifications can be shown without passing a page context.
class ToastifyHost extends StatefulWidget {
  /// Creates a toast host.
  const ToastifyHost({
    required this.controller,
    required this.child,
    super.key,
  });

  /// Controller used to show and dismiss notifications.
  final ToastifyController controller;

  /// App content displayed inside this host.
  final Widget child;

  @override
  State<ToastifyHost> createState() => _ToastifyHostState();
}

class _ToastifyHostState extends State<ToastifyHost> {
  BuildContext? _attachedContext;

  @override
  void didUpdateWidget(covariant ToastifyHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      final context = _attachedContext;
      if (context != null) oldWidget.controller._detach(context);
      if (context != null) widget.controller._attach(context);
    }
  }

  @override
  void dispose() {
    final context = _attachedContext;
    if (context != null) widget.controller._detach(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (_) => Builder(
              builder: (hostContext) {
                _attachedContext = hostContext;
                widget.controller._attach(hostContext);
                return widget.child;
              },
            ),
          ),
        ],
      );
}
