import '../../../../core/models/meal_type.dart';

/// Navigation-only bundle for opening [AddProductScreen] — go_router's
/// `extra` carries a single object, so a barcode-not-found scan result and
/// an optional preset meal travel together in this rather than as separate
/// `extra` values.
class AddProductLaunchArgs {
  const AddProductLaunchArgs({this.prefillBarcode, this.mealType});

  final String? prefillBarcode;
  final MealType? mealType;
}
