import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:open_fitness_tracker/core/widgets/app_bottom_nav_bar.dart';

void main() {
  testWidgets(
    'tapping the top of the raised Add Food button opens food search',
    (tester) async {
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(
              body: SizedBox(),
              bottomNavigationBar: AppBottomNavBar(currentTab: AppNavTab.goals),
            ),
          ),
          GoRoute(
            path: '/log-food',
            builder: (context, state) => const Scaffold(body: Text('Food search')),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      // The FAB rises 22px above the bar, so its topmost pixels sit well
      // above the bar's own box. Before the fix, only a tap within the
      // bar's own reported size (i.e. below that raised region) would
      // register — a tap this close to the FAB's own top edge would miss.
      final fabRect = tester.getRect(
        find.ancestor(of: find.byIcon(Icons.add), matching: find.byType(InkWell)),
      );
      final nearTop = Offset(fabRect.center.dx, fabRect.top + 2);

      await tester.tapAt(nearTop);
      await tester.pumpAndSettle();

      expect(find.text('Food search'), findsOneWidget);
    },
  );
}
