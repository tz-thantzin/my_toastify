import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_toastify/my_toastify.dart';

void main() {
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
