import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The app's crossed fork-and-knife-into-dumbbells mark, as used for the
/// app icon and splash screen. Reused in-app wherever the brand mark
/// itself (not just an outline icon) is called for.
class AppMark extends StatelessWidget {
  const AppMark({super.key, this.size = 24, this.color = const Color(0xFFFBFAF2)});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icon/mark.svg',
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
