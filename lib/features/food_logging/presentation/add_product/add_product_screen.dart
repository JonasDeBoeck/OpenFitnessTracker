import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/router/app_routes.dart';
import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';
import '../../presentation/providers/add_product_form_state.dart';
import '../providers/add_product_notifier.dart';
import '../widgets/meal_type_picker.dart';
import 'add_product_launch_args.dart';
import 'widgets/micronutrients_section.dart';
import 'widgets/photo_picker_field.dart';

/// Creates a new food in the local catalog. Optionally pre-filled with a
/// barcode (when reached from a scan that found no existing match) and/or
/// a preset meal type (when reached from a specific meal's "Add food").
class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key, this.args});

  final AddProductLaunchArgs? args;

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  late final _provider = addProductProvider(
    prefillBarcode: widget.args?.prefillBarcode,
    presetMealType: widget.args?.mealType,
  );

  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _storeController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _fatController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fiberController = TextEditingController();
  final _sugarController = TextEditingController();
  final _sodiumController = TextEditingController();
  final _cholesterolController = TextEditingController();
  final _potassiumController = TextEditingController();
  final _calciumController = TextEditingController();
  final _ironController = TextEditingController();
  final _vitaminCController = TextEditingController();
  final _vitaminDController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _barcodeController.text = widget.args?.prefillBarcode ?? '';
  }

  @override
  void dispose() {
    for (final controller in [
      _nameController, _brandController, _storeController, _barcodeController,
      _caloriesController, _proteinController, _fatController, _carbsController,
      _fiberController, _sugarController, _sodiumController,
      _cholesterolController, _potassiumController, _calciumController,
      _ironController, _vitaminCController, _vitaminDController,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  double? _parse(String text) => text.trim().isEmpty ? null : double.tryParse(text.trim());

  /// After OCR fills fields programmatically, controllers need to catch up
  /// to the fresh notifier state — this is the only time they're pushed
  /// state-to-controller; every other update flows controller-to-state via
  /// onChanged, so live typing is never fought or reformatted.
  void _syncControllersFromState(AddProductFormState state) {
    _caloriesController.text = state.caloriesPer100g?.toString() ?? '';
    _proteinController.text = state.proteinPer100g?.toString() ?? '';
    _fatController.text = state.fatPer100g?.toString() ?? '';
    _carbsController.text = state.carbsPer100g?.toString() ?? '';
    _fiberController.text = state.fiberPer100g?.toString() ?? '';
    _sugarController.text = state.sugarPer100g?.toString() ?? '';
    _sodiumController.text = state.sodiumMgPer100g?.toString() ?? '';
    _cholesterolController.text = state.cholesterolMgPer100g?.toString() ?? '';
    _potassiumController.text = state.potassiumMgPer100g?.toString() ?? '';
    _calciumController.text = state.calciumMgPer100g?.toString() ?? '';
    _ironController.text = state.ironMgPer100g?.toString() ?? '';
    _vitaminCController.text = state.vitaminCMgPer100g?.toString() ?? '';
    _vitaminDController.text = state.vitaminDMcgPer100g?.toString() ?? '';
  }

  /// Picks the raw photo, lets the user draw their own crop rectangle on
  /// [LabelCropScreen], then runs OCR on the cropped result. Navigation
  /// (pushing the crop screen and reading back its popped rectangle) has
  /// to happen here rather than in the notifier — same reason barcode
  /// scanning is a screen the caller awaits rather than a plain service
  /// call.
  Future<void> _scanNutritionLabel(ImageSource source) async {
    final notifier = ref.read(_provider.notifier);
    final rawPath = await notifier.pickLabelPhoto(source);
    if (rawPath == null || !mounted) return;

    final cropRect = await context.push<Rect>(AppRoutes.cropLabelPath, extra: rawPath);
    if (cropRect == null || !mounted) return;

    await notifier.scanCroppedLabel(imagePath: rawPath, cropRect: cropRect);
    if (!mounted) return;
    _syncControllersFromState(ref.read(_provider));
  }

  Future<void> _scanBarcodeField() async {
    final code = await context.push<String>(AppRoutes.scanBarcodePath);
    if (code == null || !mounted) return;
    _barcodeController.text = code;
    ref.read(_provider.notifier).setBarcode(code);
  }

  Future<void> _chooseLabelPhotoSource() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo of the label'),
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
    if (source != null) await _scanNutritionLabel(source);
  }

  Future<void> _save() async {
    await ref.read(_provider.notifier).save();
    if (!mounted) return;
    final state = ref.read(_provider);
    if (state.saveError != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.saveError!)));
      return;
    }
    if (state.macroMismatchWarning != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.macroMismatchWarning!)),
      );
    }
    if (state.savedFood != null) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);
    final notifier = ref.read(_provider.notifier);

    return Scaffold(
      backgroundColor: DashboardColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 14, 24, 6),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back, color: DashboardColors.textPrimary),
                  ),
                  Expanded(child: Text('Add manually', style: DashboardTextStyles.topbarTitle)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                children: [
                  PhotoPickerField(
                    photoPath: state.photoPath,
                    isPicking: state.isPickingPhoto,
                    onPick: (source) => notifier.pickPhoto(source),
                    onRemove: notifier.clearPhoto,
                  ),
                  const SizedBox(height: 16),
                  _LabeledField(
                    label: 'Food name',
                    controller: _nameController,
                    onChanged: (v) {
                      notifier.setName(v);
                    },
                    hint: 'e.g. Homemade lasagna',
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: _LabeledField(
                          label: 'Barcode',
                          controller: _barcodeController,
                          onChanged: notifier.setBarcode,
                          hint: 'Not scanned yet',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: DashboardColors.primary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                          tooltip: 'Scan barcode',
                          onPressed: _scanBarcodeField,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "There's no external product database — scanning just links this "
                    'barcode to the food you create here.',
                    style: DashboardTextStyles.mealKcal.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _LabeledField(
                          label: 'Brand',
                          controller: _brandController,
                          onChanged: notifier.setBrand,
                          hint: 'e.g. Chicken Co.',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _LabeledField(
                          label: 'Store',
                          controller: _storeController,
                          onChanged: notifier.setStore,
                          hint: "e.g. Trader Joe's",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: DashboardColors.gaugeCardBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Nutrition label',
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: DashboardColors.primaryDark,
                                ),
                              ),
                            ),
                            if (state.ocrPer100gColumnFound == true)
                              const _Badge(text: 'Auto-filled'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (state.isScanningLabel)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _chooseLabelPhotoSource,
                              icon: const Icon(Icons.camera_alt_outlined, size: 16),
                              label: const Text('Scan nutrition label'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: DashboardColors.primary,
                                foregroundColor: DashboardColors.surface,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          "Take a photo of the label and we'll read the macros and any listed "
                          "micronutrients into the fields below — check them before saving.",
                          style: DashboardTextStyles.mealKcal,
                        ),
                        if (state.ocrPer100gColumnFound == false)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              "Couldn't find a per-100g column on that label, so nothing was "
                              "filled in — please enter the values per 100 g yourself.",
                              style: DashboardTextStyles.mealKcal.copyWith(color: const Color(0xFFA34B3E)),
                            ),
                          ),
                        if (state.ocrError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(state.ocrError!, style: DashboardTextStyles.mealKcal.copyWith(color: const Color(0xFFA34B3E))),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (state.macroMismatchWarning != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _WarningBanner(text: state.macroMismatchWarning!),
                    ),
                  Text('Calories (kcal per 100 g)', style: DashboardTextStyles.mealKcal),
                  const SizedBox(height: 4),
                  _NumberField(controller: _caloriesController, onChanged: (v) => notifier.setCalories(_parse(v))),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _LabeledNumberField(
                          label: 'Protein (g)',
                          controller: _proteinController,
                          onChanged: (v) => notifier.setProtein(_parse(v)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _LabeledNumberField(
                          label: 'Fat (g)',
                          controller: _fatController,
                          onChanged: (v) => notifier.setFat(_parse(v)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _LabeledNumberField(
                          label: 'Carbs (g)',
                          controller: _carbsController,
                          onChanged: (v) => notifier.setCarbs(_parse(v)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  MicronutrientsSection(
                    fiberController: _fiberController,
                    onFiberChanged: (v) => notifier.setFiber(_parse(v)),
                    sugarController: _sugarController,
                    onSugarChanged: (v) => notifier.setSugar(_parse(v)),
                    sodiumController: _sodiumController,
                    onSodiumChanged: (v) => notifier.setSodium(_parse(v)),
                    showMore: state.showMoreMicronutrients,
                    onToggleShowMore: notifier.toggleShowMoreMicronutrients,
                    cholesterolController: _cholesterolController,
                    onCholesterolChanged: (v) => notifier.setCholesterol(_parse(v)),
                    potassiumController: _potassiumController,
                    onPotassiumChanged: (v) => notifier.setPotassium(_parse(v)),
                    calciumController: _calciumController,
                    onCalciumChanged: (v) => notifier.setCalcium(_parse(v)),
                    ironController: _ironController,
                    onIronChanged: (v) => notifier.setIron(_parse(v)),
                    vitaminCController: _vitaminCController,
                    onVitaminCChanged: (v) => notifier.setVitaminC(_parse(v)),
                    vitaminDController: _vitaminDController,
                    onVitaminDChanged: (v) => notifier.setVitaminD(_parse(v)),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(color: DashboardColors.card, borderRadius: BorderRadius.circular(14)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Also log to a meal today', style: DashboardTextStyles.macroName),
                        _PillSwitch(
                          value: state.logToMealEnabled,
                          onChanged: notifier.setLogToMealEnabled,
                        ),
                      ],
                    ),
                  ),
                  if (state.logToMealEnabled) ...[
                    const SizedBox(height: 14),
                    Text('Add to meal', style: DashboardTextStyles.mealKcal),
                    const SizedBox(height: 8),
                    MealTypePicker(selected: state.mealType, onSelected: notifier.setMealType),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: state.isSaving || state.name.trim().isEmpty ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DashboardColors.primary,
                    foregroundColor: DashboardColors.surface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    state.isSaving
                        ? 'Saving…'
                        : state.logToMealEnabled
                            ? 'Add to ${state.mealType.label}'
                            : 'Save food',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.controller, required this.onChanged, required this.hint});

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hint;

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
          style: DashboardTextStyles.mealItemName,
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            filled: true,
            fillColor: DashboardColors.card,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
      ],
    );
  }
}

class _LabeledNumberField extends StatelessWidget {
  const _LabeledNumberField({required this.label, required this.controller, required this.onChanged});

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
        _NumberField(controller: controller, onChanged: onChanged),
      ],
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(color: DashboardColors.surface, borderRadius: BorderRadius.circular(10)),
      child: Text(
        text,
        style: DashboardTextStyles.mealKcal.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: DashboardColors.primaryDark,
        ),
      ),
    );
  }
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4E3DF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC98177), width: 1.2),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFA34B3E), size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: DashboardTextStyles.mealKcal.copyWith(color: const Color(0xFFA34B3E)))),
        ],
      ),
    );
  }
}

/// Pill-shaped on/off switch matching the design (46x26 rounded track,
/// green when on, sliding white knob) — used in place of the stock
/// Material [Switch] for a pixel-accurate look.
class _PillSwitch extends StatelessWidget {
  const _PillSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 46,
        height: 26,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? DashboardColors.primary : DashboardColors.border,
          borderRadius: BorderRadius.circular(13),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}
