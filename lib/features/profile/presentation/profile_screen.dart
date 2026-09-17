import 'package:flutter/material.dart';

import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../home/presentation/theme/dashboard_colors.dart';
import '../../home/presentation/theme/dashboard_text_styles.dart';

/// Placeholder profile screen. The design for this screen was never
/// finished, so this just wires up the tab so navigation works end-to-end.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Profile', style: DashboardTextStyles.greeting),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Coming soon',
                  style: DashboardTextStyles.mealEmpty,
                ),
              ),
            ),
            const AppBottomNavBar(currentTab: AppNavTab.profile),
          ],
        ),
      ),
    );
  }
}
