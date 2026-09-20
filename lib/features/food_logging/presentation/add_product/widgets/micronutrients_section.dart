import 'package:flutter/material.dart';

import '../../../../home/presentation/theme/dashboard_colors.dart';
import '../../../../home/presentation/theme/dashboard_text_styles.dart';

/// Fiber/sugar/sodium are always visible; the rest of the micronutrients
/// are behind an "Add more" toggle, matching the approved design.
class MicronutrientsSection extends StatelessWidget {
  const MicronutrientsSection({
    super.key,
    required this.fiberController,
    required this.onFiberChanged,
    required this.sugarController,
    required this.onSugarChanged,
    required this.sodiumController,
    required this.onSodiumChanged,
    required this.showMore,
    required this.onToggleShowMore,
    required this.cholesterolController,
    required this.onCholesterolChanged,
    required this.potassiumController,
    required this.onPotassiumChanged,
    required this.calciumController,
    required this.onCalciumChanged,
    required this.ironController,
    required this.onIronChanged,
    required this.vitaminCController,
    required this.onVitaminCChanged,
    required this.vitaminDController,
    required this.onVitaminDChanged,
  });

  final TextEditingController fiberController;
  final ValueChanged<String> onFiberChanged;
  final TextEditingController sugarController;
  final ValueChanged<String> onSugarChanged;
  final TextEditingController sodiumController;
  final ValueChanged<String> onSodiumChanged;

  final bool showMore;
  final VoidCallback onToggleShowMore;

  final TextEditingController cholesterolController;
  final ValueChanged<String> onCholesterolChanged;
  final TextEditingController potassiumController;
  final ValueChanged<String> onPotassiumChanged;
  final TextEditingController calciumController;
  final ValueChanged<String> onCalciumChanged;
  final TextEditingController ironController;
  final ValueChanged<String> onIronChanged;
  final TextEditingController vitaminCController;
  final ValueChanged<String> onVitaminCChanged;
  final TextEditingController vitaminDController;
  final ValueChanged<String> onVitaminDChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Micronutrients (optional, per 100 g)', style: DashboardTextStyles.mealKcal),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _MicroField(label: 'Fiber (g)', controller: fiberController, onChanged: onFiberChanged)),
            const SizedBox(width: 10),
            Expanded(child: _MicroField(label: 'Sugar (g)', controller: sugarController, onChanged: onSugarChanged)),
            const SizedBox(width: 10),
            Expanded(child: _MicroField(label: 'Sodium (mg)', controller: sodiumController, onChanged: onSodiumChanged)),
          ],
        ),
        if (showMore) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _MicroField(label: 'Cholesterol (mg)', controller: cholesterolController, onChanged: onCholesterolChanged)),
              const SizedBox(width: 10),
              Expanded(child: _MicroField(label: 'Potassium (mg)', controller: potassiumController, onChanged: onPotassiumChanged)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _MicroField(label: 'Calcium (mg)', controller: calciumController, onChanged: onCalciumChanged)),
              const SizedBox(width: 10),
              Expanded(child: _MicroField(label: 'Iron (mg)', controller: ironController, onChanged: onIronChanged)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _MicroField(label: 'Vitamin C (mg)', controller: vitaminCController, onChanged: onVitaminCChanged)),
              const SizedBox(width: 10),
              Expanded(child: _MicroField(label: 'Vitamin D (mcg)', controller: vitaminDController, onChanged: onVitaminDChanged)),
            ],
          ),
        ],
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: onToggleShowMore,
            style: TextButton.styleFrom(foregroundColor: DashboardColors.primary, padding: EdgeInsets.zero),
            child: Text(showMore ? 'Show fewer micronutrients' : 'Add more micronutrients'),
          ),
        ),
      ],
    );
  }
}

class _MicroField extends StatelessWidget {
  const _MicroField({required this.label, required this.controller, required this.onChanged});

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: DashboardTextStyles.mealKcal),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: DashboardTextStyles.mealItemName,
          decoration: InputDecoration(
            isDense: true,
            hintText: '0',
            filled: true,
            fillColor: DashboardColors.card,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}
