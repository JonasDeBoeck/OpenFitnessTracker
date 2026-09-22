import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'confirm_exit_dialog.dart';

/// Wraps a bottom-nav tab root screen so that pressing the system back
/// button prompts the user to confirm before the app exits, instead of
/// quitting immediately. Every tab is reached via `context.go`, which
/// replaces rather than pushes, so none of them ever have a previous route
/// for the system's default back handling to fall back to.
class ExitConfirmationScope extends StatelessWidget {
  const ExitConfirmationScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final confirmed = await showConfirmExitDialog(context);
        if (confirmed) SystemNavigator.pop();
      },
      child: child,
    );
  }
}
