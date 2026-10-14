import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_toastify/my_toastify.dart';

void main() {
  testWidgets('controller shows and dismisses a toast through its host', (
    tester,
  ) async {
    final controller = ToastifyController();

    await tester.pumpWidget(
      MaterialApp(
        home: ToastifyHost(
          controller: controller,
          child: const Scaffold(body: Text('App content')),
        ),
      ),
    );

    final id = controller.show(
      title: 'Saved',
      message: 'Changes saved through the host controller.',
      isAutoDismissible: false,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));

    expect(find.text('Changes saved through the host controller.'),
        findsOneWidget);
    expect(controller.dismissById(id), isTrue);
    await tester.pumpAndSettle();
    expect(
        find.text('Changes saved through the host controller.'), findsNothing);
  });

  testWidgets('controller rejects show calls after its host is removed', (
    tester,
  ) async {
    final controller = ToastifyController();

    await tester.pumpWidget(
      MaterialApp(
        home: ToastifyHost(
          controller: controller,
          child: const Scaffold(body: Text('App content')),
        ),
      ),
    );
    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));

    expect(
      () => controller.show(message: 'This should fail without a host.'),
      throwsA(isA<ToastifyException>()),
    );
  });

  testWidgets('controller queues toasts until a visible toast is dismissed', (
    tester,
  ) async {
    final controller = ToastifyController(maxVisibleToasts: 1);

    await tester.pumpWidget(
      MaterialApp(
        home: ToastifyHost(
          controller: controller,
          child: const Scaffold(body: Text('App content')),
        ),
      ),
    );

    final firstId = controller.show(
      message: 'First notification is visible.',
      isAutoDismissible: false,
    );
    controller.show(
      message: 'Second notification waits in the queue.',
      isAutoDismissible: false,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));

    expect(find.text('First notification is visible.'), findsOneWidget);
    expect(find.text('Second notification waits in the queue.'), findsNothing);

    expect(controller.dismissById(firstId), isTrue);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));

    expect(
        find.text('Second notification waits in the queue.'), findsOneWidget);
  });

  testWidgets('dropNewest policy discards notifications over the limit', (
    tester,
  ) async {
    final controller = ToastifyController(
      maxVisibleToasts: 1,
      queuePolicy: ToastQueuePolicy.dropNewest,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ToastifyHost(
          controller: controller,
          child: const Scaffold(body: Text('App content')),
        ),
      ),
    );

    controller.show(
      message: 'First notification is visible.',
      isAutoDismissible: false,
    );
    controller.show(
      message: 'Dropped notification never appears.',
      isAutoDismissible: false,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));

    expect(find.text('First notification is visible.'), findsOneWidget);
    expect(find.text('Dropped notification never appears.'), findsNothing);
    controller.dismissAll();
    await tester.pumpAndSettle();
  });

  testWidgets('replaceOldest policy shows the new toast immediately', (
    tester,
  ) async {
    final controller = ToastifyController(
      maxVisibleToasts: 1,
      queuePolicy: ToastQueuePolicy.replaceOldest,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ToastifyHost(
          controller: controller,
          child: const Scaffold(body: Text('App content')),
        ),
      ),
    );

    controller.show(
      message: 'Old notification is replaced.',
      isAutoDismissible: false,
    );
    controller.show(
      message: 'Newest notification takes its place.',
      isAutoDismissible: false,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));

    expect(find.text('Old notification is replaced.'), findsNothing);
    expect(find.text('Newest notification takes its place.'), findsOneWidget);
    controller.dismissAll();
    await tester.pumpAndSettle();
  });

  testWidgets('minimal toast uses the dark theme surface and type accent', (
    tester,
  ) async {
    final theme = ThemeData.dark(useMaterial3: true);

    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () => Toastify.show(
                context,
                title: 'Saved',
                message: 'Your changes are ready.',
                type: ToastType.success,
                style: ToastStyle.minimal,
              ),
              child: const Text('Show minimal'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show minimal'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));

    final card = tester
        .widgetList<Container>(
          find.ancestor(
              of: find.text('Saved'), matching: find.byType(Container)),
        )
        .firstWhere((widget) => widget.decoration is BoxDecoration);
    expect(
        (card.decoration! as BoxDecoration).color, theme.colorScheme.surface);
    expect(tester.getSize(find.byWidget(card)).width, lessThanOrEqualTo(420));
    expect(tester.widget<Text>(find.text('Saved')).style?.color,
        theme.colorScheme.onSurface);
    expect(tester.widget<Icon>(find.byIcon(Icons.check_circle_outline)).color,
        Colors.green);

    Toastify.dismissAll();
    await tester.pumpAndSettle();
  });

  testWidgets('deduplication replaces an active controller toast', (
    tester,
  ) async {
    final controller = ToastifyController(maxVisibleToasts: 1);

    await tester.pumpWidget(
      MaterialApp(
        home: ToastifyHost(
          controller: controller,
          child: const Scaffold(body: Text('App content')),
        ),
      ),
    );

    controller.show(
      title: 'Syncing',
      message: 'One background task is running.',
      deduplicationKey: 'background-sync',
      isAutoDismissible: false,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));

    controller.show(
      title: 'Syncing',
      message: 'Three background tasks are running.',
      deduplicationKey: 'background-sync',
      isAutoDismissible: false,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));

    expect(find.text('One background task is running.'), findsNothing);
    expect(find.text('Three background tasks are running.'), findsOneWidget);
    controller.dismissAll();
    await tester.pumpAndSettle();
  });

  testWidgets('custom semantic label is exposed by the toast', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () => Toastify.show(
                context,
                title: 'Payment received',
                message: 'Your receipt is ready to view.',
                semanticLabel:
                    'Payment received. Your receipt is ready to view.',
                position: ToastPosition.topRight,
                isAutoDismissible: false,
              ),
              child: const Text('Show accessible toast'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show accessible toast'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));

    expect(
      find.bySemanticsLabel(
        'Payment received. Your receipt is ready to view.',
      ),
      findsOneWidget,
    );
    Toastify.dismissAll();
    await tester.pumpAndSettle();
  });

  testWidgets('shows toast with fractional width and end alignment', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 600));

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  Toastify.show(
                    context,
                    title: 'Web Layout',
                    message: 'Half-width toast aligned to the right.',
                    style: ToastStyle.banner,
                    position: ToastPosition.bottom,
                    widthFactor: 0.5,
                    horizontalAlignment: ToastHorizontalAlignment.end,
                  );
                },
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));

    expect(find.text('Web Layout'), findsOneWidget);
    expect(find.text('Half-width toast aligned to the right.'), findsOneWidget);

    Toastify.dismissAll();
    await tester.pumpAndSettle();
  });

  testWidgets('rejects invalid widthFactor', (tester) async {
    late BuildContext capturedContext;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            capturedContext = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(
      () => Toastify.show(
        capturedContext,
        message: 'Invalid width factor',
        widthFactor: 2,
      ),
      throwsA(isA<ToastifyException>()),
    );
  });
}
