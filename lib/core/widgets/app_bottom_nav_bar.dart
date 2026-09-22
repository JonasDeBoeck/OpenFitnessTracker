import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/theme/dashboard_text_styles.dart';
import '../router/app_routes.dart';

/// Which primary tab is currently active, for [AppBottomNavBar] to
/// highlight.
enum AppNavTab { goals, diary, trends, profile }

/// The bottom navigation bar shared by the home ("Goals"), diary, trends,
/// and profile screens: Goals, Diary, Trends, and Profile tabs, plus a
/// raised center FAB that opens Add Food.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key, required this.currentTab});

  final AppNavTab currentTab;

  static const Color _active = Color(0xFF3C6E4F);
  static const Color _inactive = Color(0xFF9C9A8A);
  static const Color _surface = Color(0xFFFBFAF2);
  static const Color _border = Color(0xFFDAD6C6);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: _surface,
            border: Border(top: BorderSide(color: _border)),
          ),
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
          child: Row(
            children: [
              Expanded(
                child: _NavItem(
                  icon: Icons.track_changes_outlined,
                  label: 'Goals',
                  active: currentTab == AppNavTab.goals,
                  onTap: () => context.go(AppRoutes.homePath),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.menu_book_outlined,
                  label: 'Diary',
                  active: currentTab == AppNavTab.diary,
                  onTap: () => context.go(AppRoutes.diaryPath),
                ),
              ),
              const Expanded(child: SizedBox.shrink()),
              Expanded(
                child: _NavItem(
                  icon: Icons.show_chart,
                  label: 'Trends',
                  active: currentTab == AppNavTab.trends,
                  onTap: () => context.go(AppRoutes.trendsPath),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.person_outline,
                  label: 'Profile',
                  active: currentTab == AppNavTab.profile,
                  onTap: () => context.go(AppRoutes.profilePath),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -22,
          child: _AddFoodFab(
            onTap: () => context.push(AppRoutes.foodSearchPath),
          ),
        ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;

  /// Null disables the tab — used for destinations not built yet.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppBottomNavBar._active : AppBottomNavBar._inactive;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 4),
            Text(label, style: DashboardTextStyles.navLabel.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

class _AddFoodFab extends StatelessWidget {
  const _AddFoodFab({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Add food',
      child: Material(
        color: AppBottomNavBar._active,
        shape: const CircleBorder(
          side: BorderSide(color: AppBottomNavBar._surface, width: 3),
        ),
        elevation: 6,
        shadowColor: const Color(0x591C3C28),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: const SizedBox(
            width: 52,
            height: 52,
            child: Icon(Icons.add, size: 22, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
