import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';
import '../../domain/models/diary_entry.dart';
import '../../domain/models/food.dart';
import '../providers/diary_providers.dart';
import '../providers/food_detail_providers.dart';
import '../providers/recipe_detail_providers.dart';
import 'piece_aware_quantity_field.dart';

/// Bottom sheet for editing an already-logged entry's quantity — opened by
/// tapping a meal item row on the Goals/Diary screens. Re-fetches the
/// entry's underlying [Food]/[Recipe] for a live kcal preview as the
/// stepper moves, then saves via [DiaryEntryController.updateQuantity].
class EditDiaryEntrySheet extends ConsumerStatefulWidget {
  const EditDiaryEntrySheet({
    super.key,
    required this.entry,
    required this.date,
  });

  final DiaryEntry entry;
  final DateTime date;

  @override
  ConsumerState<EditDiaryEntrySheet> createState() =>
      _EditDiaryEntrySheetState();
}

class _EditDiaryEntrySheetState extends ConsumerState<EditDiaryEntrySheet> {
  late double _grams;
  String? _unitLabel;
  double? _unitCount;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _grams = widget.entry.quantityGrams;
    _unitLabel = widget.entry.loggedUnitLabel;
    _unitCount = widget.entry.loggedUnitCount;
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await ref
        .read(diaryEntryControllerProvider.notifier)
        .updateQuantity(
          date: widget.date,
          entry: widget.entry,
          newGrams: _grams,
          unitLabel: _unitLabel,
          unitCount: _unitCount,
        );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    Food? food;
    double? previewCalories;
    if (entry.foodId != null) {
      food = ref.watch(foodByIdProvider(entry.foodId!)).value;
      previewCalories = food?.scaledTo(_grams).calories;
    } else if (entry.recipeId != null) {
      previewCalories = ref
          .watch(recipeByIdProvider(entry.recipeId!))
          .value
          ?.scaledTo(_grams)
          .calories;
    }
    previewCalories ??= entry.calories * (_grams / entry.quantityGrams);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Edit ${entry.displayName}', style: DashboardTextStyles.dialogTitle),
          const SizedBox(height: 14),
          PieceAwareQuantityField(
            grams: _grams,
            pieceLabel: food?.pieceLabel,
            pieceWeightGrams: food?.pieceWeightGrams,
            initialUnitCount: widget.entry.loggedUnitCount,
            showCard: false,
            minGrams: 5,
            maxGrams: 2000,
            onChanged: (quantity) => setState(() {
              _grams = quantity.grams;
              _unitLabel = quantity.unitLabel;
              _unitCount = quantity.unitCount;
            }),
          ),
          const SizedBox(height: 14),
          Text(
            '${previewCalories.toStringAsFixed(0)} kcal',
            textAlign: TextAlign.center,
            style: DashboardTextStyles.editKcalPreview,
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 48,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: DashboardColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _isSaving ? null : _save,
              child: Text(
                _isSaving ? 'Saving…' : 'Save changes',
                style: DashboardTextStyles.sheetButtonLabel,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
