import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactiontest/main.dart';

void main() {
  group('l01h01', () {
    testWidgets('Scaffold have right background color',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      expect(
        (tester.firstWidget(find.byType(Scaffold)) as Scaffold).backgroundColor,
        const Color(0xFF282E3D),
      );
    });
  });

  group("l01h02", () {
    testWidgets('Top Text widget has correct style',
        (WidgetTester tester) async {
      const TextStyle correctStyle = const TextStyle(
          fontSize: 38, fontWeight: FontWeight.w900, color: Colors.white);
      await tester.pumpWidget(MyApp());
      expect(
          (tester.firstWidget(find.textContaining("Test your")) as Text).style,
          correctStyle);
      expect(
          (tester.firstWidget(find.textContaining("Test your")) as Text)
              .textAlign,
          TextAlign.center);
    });
  });

  group('l01h03', () {
    testWidgets('Centered box has right background color',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      final List<Stack> stackWidgets = tester
          .widgetList<Stack>(
              find.byWidgetPredicate((widget) => widget is Stack))
          .toList();
      final Stack? stackWithThreeWidgets =
          stackWidgets.firstWhere((stack) => stack.children.length == 3);
      expect(stackWithThreeWidgets, isNotNull);
      final Widget? centeredWidget = stackWithThreeWidgets!.children.firstWhere(
          (element) =>
              (element is Align && element.alignment == Alignment.center) ||
              element is Center);
      expect(centeredWidget, isNotNull);
      expect(centeredWidget, isInstanceOf<Align>());
      expect((centeredWidget as Align).child, isInstanceOf<ColoredBox>());
      final ColoredBox coloredBox = centeredWidget.child as ColoredBox;
      expect(coloredBox.color, const Color(0xFF6D6D6D));
    });
  });

  group('l01h04', () {
    testWidgets('The Text with milliseconds has correct style',
        (WidgetTester tester) async {
      const TextStyle correctStyle = const TextStyle(
          fontSize: 36, fontWeight: FontWeight.w500, color: Colors.white);
      await tester.pumpWidget(MyApp());
      final Text? text = tester.firstWidget(find
          .byWidgetPredicate((widget) => widget is Text && widget.data == ""));
      expect(text, isNotNull);
      expect(text!.style, correctStyle);
    });
  });

  group('l01h05', () {
    testWidgets('The Text with milliseconds has correct style',
        (WidgetTester tester) async {
      const TextStyle correctStyle = const TextStyle(
          fontSize: 38, fontWeight: FontWeight.w900, color: Colors.white);
      await tester.pumpWidget(MyApp());
      final Text? text = tester.firstWidget(find.byWidgetPredicate(
          (widget) => widget is Text && widget.data == "START"));
      expect(text, isNotNull);
      expect(text!.style, correctStyle);
    });
  });
}
