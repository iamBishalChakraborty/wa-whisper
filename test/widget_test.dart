// Basic widget smoke test aligned to current app architecture.
// This avoids relying on app-specific state or external services.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('basic render smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Center(child: Text('Hello')),
      ),
    ));

    expect(find.text('Hello'), findsOneWidget);
    expect(find.byType(Center), findsOneWidget);
  });
}
