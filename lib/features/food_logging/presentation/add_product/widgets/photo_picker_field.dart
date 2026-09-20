import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../home/presentation/theme/dashboard_colors.dart';
import '../../../../home/presentation/theme/dashboard_text_styles.dart';

/// Tap-to-add photo tile for Add Product. Shows a preview once a photo is
/// picked, with a remove action; otherwise an empty dashed tile.
class PhotoPickerField extends StatelessWidget {
  const PhotoPickerField({
    super.key,
    required this.photoPath,
    required this.isPicking,
    required this.onPick,
    required this.onRemove,
  });

  final String? photoPath;
  final bool isPicking;
  final ValueChanged<ImageSource> onPick;
  final VoidCallback onRemove;

  Future<void> _choose(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source != null) onPick(source);
  }

  @override
  Widget build(BuildContext context) {
    if (isPicking) {
      return Container(
        height: 150,
        decoration: BoxDecoration(color: DashboardColors.card, borderRadius: BorderRadius.circular(16)),
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    }

    if (photoPath != null) {
      return Container(
        height: 150,
        decoration: BoxDecoration(
          color: DashboardColors.gaugeCardBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(File(photoPath!), width: 100, height: 126, fit: BoxFit.cover),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Photo added', style: DashboardTextStyles.mealTitle),
                  const SizedBox(height: 4),
                  Text('Tap remove to change it', style: DashboardTextStyles.mealKcal),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: DashboardColors.textSecondary),
              tooltip: 'Remove photo',
              onPressed: onRemove,
            ),
          ],
        ),
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _choose(context),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFC7C2AC), width: 1.5, style: BorderStyle.solid),
          color: DashboardColors.card,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_a_photo_outlined, color: DashboardColors.textMuted, size: 26),
            const SizedBox(height: 8),
            Text('Add a photo', style: DashboardTextStyles.addFoodButton),
          ],
        ),
      ),
    );
  }
}
