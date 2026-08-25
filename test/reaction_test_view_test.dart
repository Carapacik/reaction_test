import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:reactiontest/src/reaction_test/reaction_test_view.dart';

void main() {
  testWidgets('shows the initial reaction test state', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ReactionTestView()));

    expect(find.text('WAIT'), findsOneWidget);
    expect(find.text('START'), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
  });

  testWidgets('disables the button until the ticker starts', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ReactionTestView()));

    await tester.tap(find.text('START'));
    await tester.pump();

    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed, isNull);
    expect(find.text('WAIT'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pump(const Duration(milliseconds: 17));
    await tester.pump(const Duration(milliseconds: 200));

    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed, isNotNull);
    expect(find.textContaining('ms'), findsOneWidget);
    expect(find.text('WAIT'), findsNothing);
  });
}
