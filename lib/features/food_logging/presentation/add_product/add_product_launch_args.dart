import '../../../../core/models/meal_type.dart';
import '../../domain/models/food.dart';

/// Navigation-only bundle for opening [AddProductScreen] — go_router's
/// `extra` carries a single object, so a barcode-not-found scan result, an
/// optional preset meal, and an existing food to edit all travel together
/// in this rather than as separate `extra` values.
class AddProductLaunchArgs {
  const AddProductLaunchArgs({this.prefillBarcode, this.mealType, this.editingFood});

  final String? prefillBarcode;
  final MealType? mealType;

  /// When set, the screen opens pre-filled with this food's data and saves
  /// update it in place instead of creating a new one.
  final Food? editingFood;
}
