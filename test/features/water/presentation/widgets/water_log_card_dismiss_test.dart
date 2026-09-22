import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_fitness_tracker/features/water/domain/models/water_entry.dart';
import 'package:open_fitness_tracker/features/water/presentation/widgets/water_log_card.dart';

class _Harness extends StatefulWidget {
  const _Harness();

  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  var _entries = [
    WaterEntry(id: 1, loggedAt: DateTime(2026, 1, 1, 8), milliliters: 500),
  ];

  Future<void> _delete(int id) async {
    // Mirrors WaterLogController.delete in the real app: an immediate state
    // change triggers a rebuild of anything watching it *before* the async
    // repository call + provider invalidation actually removes the entry
    // from `entries`.
    setState(() {});
    await Future<void>.delayed(const Duration(milliseconds: 50));
    setState(() {
      _entries = _entries.where((e) => e.id != id).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaterLogCard(
        entries: _entries,
        onQuickAdd: (_) {},
        onCustomAdd: (_) {},
        onDelete: _delete,
      ),
    );
  }
}

void main() {
  testWidgets(
    'swiping a water entry to delete it survives a rebuild before the '
    'async delete completes',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: _Harness()));

      await tester.drag(find.text('500 mL'), const Offset(-500, 0));
      await tester.pumpAndSettle();

      // Confirm-delete dialog should be showing.
      expect(find.text('Delete'), findsOneWidget);
      await tester.tap(find.text('Delete'));
      await tester.pump(); // start dismiss animation
      await tester.pump(const Duration(milliseconds: 300)); // onDismissed fires

      // The intermediate `setState((){})` rebuild happens here, with the
      // entry still in `_entries` but the Dismissible already dismissed.
      // Without the pending-delete filtering in WaterLogCard, this throws
      // "A dismissed Dismissible widget is still part of the tree".
      await tester.pump(const Duration(milliseconds: 10));

      await tester.pumpAndSettle();

      expect(find.text('500 mL'), findsNothing);
    },
  );
}
