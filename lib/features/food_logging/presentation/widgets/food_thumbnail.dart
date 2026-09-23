import 'dart:io';

import 'package:flutter/material.dart';

import '../../../home/presentation/theme/dashboard_colors.dart';

/// A food's photo, rounded-square and cropped to fill. Falls back to a
/// muted placeholder tile when [photoPath] is null, reusing the same look
/// as the empty state of [PhotoPickerField].
class FoodThumbnail extends StatelessWidget {
  const FoodThumbnail({super.key, required this.photoPath, this.size = 44});

  final String? photoPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    final path = photoPath;
    final radius = BorderRadius.circular(size >= 60 ? 16 : 12);

    if (path == null) {
      return ClipRRect(
        borderRadius: radius,
        child: Container(
          width: size,
          height: size,
          color: DashboardColors.gaugeCardBackground,
          alignment: Alignment.center,
          child: Icon(
            Icons.image_outlined,
            size: size * 0.42,
            color: DashboardColors.primaryDark,
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: radius,
      child: Image.file(File(path), width: size, height: size, fit: BoxFit.cover),
    );
  }
}
