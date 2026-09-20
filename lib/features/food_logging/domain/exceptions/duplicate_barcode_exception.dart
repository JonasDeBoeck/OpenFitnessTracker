/// Thrown by [FoodRepository] when saving a food whose barcode is already
/// linked to a different existing food.
class DuplicateBarcodeException implements Exception {
  DuplicateBarcodeException(this.barcode, this.existingFoodName);

  final String barcode;
  final String existingFoodName;

  @override
  String toString() => "This barcode is already linked to '$existingFoodName'";
}
