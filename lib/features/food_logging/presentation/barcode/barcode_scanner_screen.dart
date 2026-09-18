import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../home/presentation/theme/dashboard_colors.dart';

/// Live camera barcode scanner. Pops with the first detected barcode's raw
/// value, or null if the user closes it without a detection.
///
/// This is a screen rather than a plain async service (see the platform
/// I/O seam note in the plan) because [MobileScanner] needs a live camera
/// preview widget — it can't be driven from inside a notifier.
class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  bool _handled = false;

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    final value = capture.barcodes.firstOrNull?.rawValue;
    if (value == null || value.isEmpty) return;
    _handled = true;
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(onDetect: _onDetect),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Align(
                alignment: Alignment.topLeft,
                child: CircleAvatar(
                  backgroundColor: DashboardColors.surface,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: DashboardColors.textPrimary),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Close',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
