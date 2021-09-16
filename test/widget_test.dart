import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MyWidget', () {
    testWidgets('should display a string of text', (WidgetTester tester) async {
      const myWidget = MaterialApp(
        home: Scaffold(
          body: Text('Hello'),
        ),
      );
      await tester.pumpWidget(myWidget);
      expect(find.byType(Text), findsOneWidget);
    });
  });
}
