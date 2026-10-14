import 'package:example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('demo app includes the controller queue examples', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ToastifyDemoApp());

    expect(find.text('Controller and queues'), findsOneWidget);
    expect(find.text('Queue notifications'), findsOneWidget);
    expect(find.text('Dismiss queued updates'), findsOneWidget);
  });
}
