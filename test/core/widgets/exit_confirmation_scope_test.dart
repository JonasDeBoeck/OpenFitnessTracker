import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_fitness_tracker/core/widgets/exit_confirmation_scope.dart';

void main() {
  testWidgets('back press shows the exit confirmation, cancel keeps the '
      'screen', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ExitConfirmationScope(child: Scaffold(body: Text('Home tab'))),
      ),
    );

    expect(find.text('Home tab'), findsOneWidget);

    // Simulate the Android hardware/gesture back button.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Exit app?'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // Dialog dismissed, screen (and app) still there.
    expect(find.text('Exit app?'), findsNothing);
    expect(find.text('Home tab'), findsOneWidget);
  });
}
