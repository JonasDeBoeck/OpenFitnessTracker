import 'package:flutter/material.dart';

import '../../features/home/presentation/theme/dashboard_colors.dart';
import '../../features/home/presentation/theme/dashboard_text_styles.dart';

/// Shows an "Exit app?" confirmation, styled to [DashboardColors]. Returns
/// true only if the user tapped Exit.
Future<bool> showConfirmExitDialog(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    barrierColor: DashboardColors.dialogBackdrop,
    builder: (context) => Dialog(
      backgroundColor: DashboardColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Exit app?', style: DashboardTextStyles.dialogTitle),
            const SizedBox(height: 8),
            Text(
              'Are you sure you want to close OpenFitnessTracker?',
              style: DashboardTextStyles.confirmMessage,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: DashboardColors.card,
                        foregroundColor: DashboardColors.textPrimary,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: DashboardTextStyles.dialogButtonLabel,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: FilledButton.styleFrom(
                        backgroundColor: DashboardColors.primary,
                      ),
                      child: Text(
                        'Exit',
                        style: DashboardTextStyles.dialogButtonLabel.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  return confirmed ?? false;
}
