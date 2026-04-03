import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_toastify/my_toastify.dart';

void main() {
  testWidgets('shows toast with fractional width and end alignment', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 600));

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
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
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));

    expect(find.text('Web Layout'), findsOneWidget);
    expect(find.text('Half-width toast aligned to the right.'), findsOneWidget);
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
