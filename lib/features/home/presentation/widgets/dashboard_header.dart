import 'package:flutter/material.dart';

import '../theme/dashboard_text_styles.dart';

/// Greeting + today's date, shown at the top of the home dashboard.
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.greeting,
    required this.name,
    required this.dateLabel,
  });

  final String greeting;
  final String name;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$greeting, $name', style: DashboardTextStyles.greeting),
          const SizedBox(height: 2),
          Text(dateLabel, style: DashboardTextStyles.greetingDate),
        ],
      ),
    );
  }
}
