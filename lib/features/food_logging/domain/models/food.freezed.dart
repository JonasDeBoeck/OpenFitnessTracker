// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Food {

 int? get id; String get name; String? get brand; String? get store; String? get barcode; String? get photoPath; double? get caloriesPer100g; double? get proteinPer100g; double? get fatPer100g; double? get carbsPer100g; double? get fiberPer100g; double? get sugarPer100g; double? get sodiumMgPer100g; double? get cholesterolMgPer100g; double? get potassiumMgPer100g; double? get calciumMgPer100g; double? get ironMgPer100g; double? get vitaminCMgPer100g; double? get vitaminDMcgPer100g; bool get isFavorite; DateTime? get createdAt;
/// Create a copy of Food
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodCopyWith<Food> get copyWith => _$FoodCopyWithImpl<Food>(this as Food, _$identity);

  /// Serializes this Food to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Food;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Food&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.brand, _this.brand) || other.brand == _this.brand)&&(identical(other.store, _this.store) || other.store == _this.store)&&(identical(other.barcode, _this.barcode) || other.barcode == _this.barcode)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath)&&(identical(other.caloriesPer100g, _this.caloriesPer100g) || other.caloriesPer100g == _this.caloriesPer100g)&&(identical(other.proteinPer100g, _this.proteinPer100g) || other.proteinPer100g == _this.proteinPer100g)&&(identical(other.fatPer100g, _this.fatPer100g) || other.fatPer100g == _this.fatPer100g)&&(identical(other.carbsPer100g, _this.carbsPer100g) || other.carbsPer100g == _this.carbsPer100g)&&(identical(other.fiberPer100g, _this.fiberPer100g) || other.fiberPer100g == _this.fiberPer100g)&&(identical(other.sugarPer100g, _this.sugarPer100g) || other.sugarPer100g == _this.sugarPer100g)&&(identical(other.sodiumMgPer100g, _this.sodiumMgPer100g) || other.sodiumMgPer100g == _this.sodiumMgPer100g)&&(identical(other.cholesterolMgPer100g, _this.cholesterolMgPer100g) || other.cholesterolMgPer100g == _this.cholesterolMgPer100g)&&(identical(other.potassiumMgPer100g, _this.potassiumMgPer100g) || other.potassiumMgPer100g == _this.potassiumMgPer100g)&&(identical(other.calciumMgPer100g, _this.calciumMgPer100g) || other.calciumMgPer100g == _this.calciumMgPer100g)&&(identical(other.ironMgPer100g, _this.ironMgPer100g) || other.ironMgPer100g == _this.ironMgPer100g)&&(identical(other.vitaminCMgPer100g, _this.vitaminCMgPer100g) || other.vitaminCMgPer100g == _this.vitaminCMgPer100g)&&(identical(other.vitaminDMcgPer100g, _this.vitaminDMcgPer100g) || other.vitaminDMcgPer100g == _this.vitaminDMcgPer100g)&&(identical(other.isFavorite, _this.isFavorite) || other.isFavorite == _this.isFavorite)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Food;
  return Object.hashAll([runtimeType,_this.id,_this.name,_this.brand,_this.store,_this.barcode,_this.photoPath,_this.caloriesPer100g,_this.proteinPer100g,_this.fatPer100g,_this.carbsPer100g,_this.fiberPer100g,_this.sugarPer100g,_this.sodiumMgPer100g,_this.cholesterolMgPer100g,_this.potassiumMgPer100g,_this.calciumMgPer100g,_this.ironMgPer100g,_this.vitaminCMgPer100g,_this.vitaminDMcgPer100g,_this.isFavorite,_this.createdAt]);
}

@override
String toString() {
  final _this = this as Food;
  return 'Food(id: ${_this.id}, name: ${_this.name}, brand: ${_this.brand}, store: ${_this.store}, barcode: ${_this.barcode}, photoPath: ${_this.photoPath}, caloriesPer100g: ${_this.caloriesPer100g}, proteinPer100g: ${_this.proteinPer100g}, fatPer100g: ${_this.fatPer100g}, carbsPer100g: ${_this.carbsPer100g}, fiberPer100g: ${_this.fiberPer100g}, sugarPer100g: ${_this.sugarPer100g}, sodiumMgPer100g: ${_this.sodiumMgPer100g}, cholesterolMgPer100g: ${_this.cholesterolMgPer100g}, potassiumMgPer100g: ${_this.potassiumMgPer100g}, calciumMgPer100g: ${_this.calciumMgPer100g}, ironMgPer100g: ${_this.ironMgPer100g}, vitaminCMgPer100g: ${_this.vitaminCMgPer100g}, vitaminDMcgPer100g: ${_this.vitaminDMcgPer100g}, isFavorite: ${_this.isFavorite}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $FoodCopyWith<$Res>  {
  factory $FoodCopyWith(Food value, $Res Function(Food) _then) = _$FoodCopyWithImpl;
@useResult
$Res call({
 int? id, String name, String? brand, String? store, String? barcode, String? photoPath, double? caloriesPer100g, double? proteinPer100g, double? fatPer100g, double? carbsPer100g, double? fiberPer100g, double? sugarPer100g, double? sodiumMgPer100g, double? cholesterolMgPer100g, double? potassiumMgPer100g, double? calciumMgPer100g, double? ironMgPer100g, double? vitaminCMgPer100g, double? vitaminDMcgPer100g, bool isFavorite, DateTime? createdAt
});




}
/// @nodoc
class _$FoodCopyWithImpl<$Res>
    implements $FoodCopyWith<$Res> {
  _$FoodCopyWithImpl(this._self, this._then);

  final Food _self;
  final $Res Function(Food) _then;

/// Create a copy of Food
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? brand = freezed,Object? store = freezed,Object? barcode = freezed,Object? photoPath = freezed,Object? caloriesPer100g = freezed,Object? proteinPer100g = freezed,Object? fatPer100g = freezed,Object? carbsPer100g = freezed,Object? fiberPer100g = freezed,Object? sugarPer100g = freezed,Object? sodiumMgPer100g = freezed,Object? cholesterolMgPer100g = freezed,Object? potassiumMgPer100g = freezed,Object? calciumMgPer100g = freezed,Object? ironMgPer100g = freezed,Object? vitaminCMgPer100g = freezed,Object? vitaminDMcgPer100g = freezed,Object? isFavorite = null,Object? createdAt = freezed,}) {
  return _then(Food(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,store: freezed == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,caloriesPer100g: freezed == caloriesPer100g ? _self.caloriesPer100g : caloriesPer100g // ignore: cast_nullable_to_non_nullable
as double?,proteinPer100g: freezed == proteinPer100g ? _self.proteinPer100g : proteinPer100g // ignore: cast_nullable_to_non_nullable
as double?,fatPer100g: freezed == fatPer100g ? _self.fatPer100g : fatPer100g // ignore: cast_nullable_to_non_nullable
as double?,carbsPer100g: freezed == carbsPer100g ? _self.carbsPer100g : carbsPer100g // ignore: cast_nullable_to_non_nullable
as double?,fiberPer100g: freezed == fiberPer100g ? _self.fiberPer100g : fiberPer100g // ignore: cast_nullable_to_non_nullable
as double?,sugarPer100g: freezed == sugarPer100g ? _self.sugarPer100g : sugarPer100g // ignore: cast_nullable_to_non_nullable
as double?,sodiumMgPer100g: freezed == sodiumMgPer100g ? _self.sodiumMgPer100g : sodiumMgPer100g // ignore: cast_nullable_to_non_nullable
as double?,cholesterolMgPer100g: freezed == cholesterolMgPer100g ? _self.cholesterolMgPer100g : cholesterolMgPer100g // ignore: cast_nullable_to_non_nullable
as double?,potassiumMgPer100g: freezed == potassiumMgPer100g ? _self.potassiumMgPer100g : potassiumMgPer100g // ignore: cast_nullable_to_non_nullable
as double?,calciumMgPer100g: freezed == calciumMgPer100g ? _self.calciumMgPer100g : calciumMgPer100g // ignore: cast_nullable_to_non_nullable
as double?,ironMgPer100g: freezed == ironMgPer100g ? _self.ironMgPer100g : ironMgPer100g // ignore: cast_nullable_to_non_nullable
as double?,vitaminCMgPer100g: freezed == vitaminCMgPer100g ? _self.vitaminCMgPer100g : vitaminCMgPer100g // ignore: cast_nullable_to_non_nullable
as double?,vitaminDMcgPer100g: freezed == vitaminDMcgPer100g ? _self.vitaminDMcgPer100g : vitaminDMcgPer100g // ignore: cast_nullable_to_non_nullable
as double?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Food].
extension FoodPatterns on Food {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Food value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Food() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Food value)  $default,){
final _that = this;
switch (_that) {
case _Food():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Food value)?  $default,){
final _that = this;
switch (_that) {
case _Food() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String name,  String? brand,  String? store,  String? barcode,  String? photoPath,  double? caloriesPer100g,  double? proteinPer100g,  double? fatPer100g,  double? carbsPer100g,  double? fiberPer100g,  double? sugarPer100g,  double? sodiumMgPer100g,  double? cholesterolMgPer100g,  double? potassiumMgPer100g,  double? calciumMgPer100g,  double? ironMgPer100g,  double? vitaminCMgPer100g,  double? vitaminDMcgPer100g,  bool isFavorite,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Food() when $default != null:
return $default(_that.id,_that.name,_that.brand,_that.store,_that.barcode,_that.photoPath,_that.caloriesPer100g,_that.proteinPer100g,_that.fatPer100g,_that.carbsPer100g,_that.fiberPer100g,_that.sugarPer100g,_that.sodiumMgPer100g,_that.cholesterolMgPer100g,_that.potassiumMgPer100g,_that.calciumMgPer100g,_that.ironMgPer100g,_that.vitaminCMgPer100g,_that.vitaminDMcgPer100g,_that.isFavorite,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String name,  String? brand,  String? store,  String? barcode,  String? photoPath,  double? caloriesPer100g,  double? proteinPer100g,  double? fatPer100g,  double? carbsPer100g,  double? fiberPer100g,  double? sugarPer100g,  double? sodiumMgPer100g,  double? cholesterolMgPer100g,  double? potassiumMgPer100g,  double? calciumMgPer100g,  double? ironMgPer100g,  double? vitaminCMgPer100g,  double? vitaminDMcgPer100g,  bool isFavorite,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Food():
return $default(_that.id,_that.name,_that.brand,_that.store,_that.barcode,_that.photoPath,_that.caloriesPer100g,_that.proteinPer100g,_that.fatPer100g,_that.carbsPer100g,_that.fiberPer100g,_that.sugarPer100g,_that.sodiumMgPer100g,_that.cholesterolMgPer100g,_that.potassiumMgPer100g,_that.calciumMgPer100g,_that.ironMgPer100g,_that.vitaminCMgPer100g,_that.vitaminDMcgPer100g,_that.isFavorite,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String name,  String? brand,  String? store,  String? barcode,  String? photoPath,  double? caloriesPer100g,  double? proteinPer100g,  double? fatPer100g,  double? carbsPer100g,  double? fiberPer100g,  double? sugarPer100g,  double? sodiumMgPer100g,  double? cholesterolMgPer100g,  double? potassiumMgPer100g,  double? calciumMgPer100g,  double? ironMgPer100g,  double? vitaminCMgPer100g,  double? vitaminDMcgPer100g,  bool isFavorite,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Food() when $default != null:
return $default(_that.id,_that.name,_that.brand,_that.store,_that.barcode,_that.photoPath,_that.caloriesPer100g,_that.proteinPer100g,_that.fatPer100g,_that.carbsPer100g,_that.fiberPer100g,_that.sugarPer100g,_that.sodiumMgPer100g,_that.cholesterolMgPer100g,_that.potassiumMgPer100g,_that.calciumMgPer100g,_that.ironMgPer100g,_that.vitaminCMgPer100g,_that.vitaminDMcgPer100g,_that.isFavorite,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Food extends Food {
  const _Food({this.id, required this.name, this.brand, this.store, this.barcode, this.photoPath, this.caloriesPer100g, this.proteinPer100g, this.fatPer100g, this.carbsPer100g, this.fiberPer100g, this.sugarPer100g, this.sodiumMgPer100g, this.cholesterolMgPer100g, this.potassiumMgPer100g, this.calciumMgPer100g, this.ironMgPer100g, this.vitaminCMgPer100g, this.vitaminDMcgPer100g, this.isFavorite = false, this.createdAt}): super._();
  factory _Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);

@override final  int? id;
@override final  String name;
@override final  String? brand;
@override final  String? store;
@override final  String? barcode;
@override final  String? photoPath;
@override final  double? caloriesPer100g;
@override final  double? proteinPer100g;
@override final  double? fatPer100g;
@override final  double? carbsPer100g;
@override final  double? fiberPer100g;
@override final  double? sugarPer100g;
@override final  double? sodiumMgPer100g;
@override final  double? cholesterolMgPer100g;
@override final  double? potassiumMgPer100g;
@override final  double? calciumMgPer100g;
@override final  double? ironMgPer100g;
@override final  double? vitaminCMgPer100g;
@override final  double? vitaminDMcgPer100g;
@override@JsonKey() final  bool isFavorite;
@override final  DateTime? createdAt;

/// Create a copy of Food
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodCopyWith<_Food> get copyWith => __$FoodCopyWithImpl<_Food>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FoodToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Food&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.store, store) || other.store == store)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.caloriesPer100g, caloriesPer100g) || other.caloriesPer100g == caloriesPer100g)&&(identical(other.proteinPer100g, proteinPer100g) || other.proteinPer100g == proteinPer100g)&&(identical(other.fatPer100g, fatPer100g) || other.fatPer100g == fatPer100g)&&(identical(other.carbsPer100g, carbsPer100g) || other.carbsPer100g == carbsPer100g)&&(identical(other.fiberPer100g, fiberPer100g) || other.fiberPer100g == fiberPer100g)&&(identical(other.sugarPer100g, sugarPer100g) || other.sugarPer100g == sugarPer100g)&&(identical(other.sodiumMgPer100g, sodiumMgPer100g) || other.sodiumMgPer100g == sodiumMgPer100g)&&(identical(other.cholesterolMgPer100g, cholesterolMgPer100g) || other.cholesterolMgPer100g == cholesterolMgPer100g)&&(identical(other.potassiumMgPer100g, potassiumMgPer100g) || other.potassiumMgPer100g == potassiumMgPer100g)&&(identical(other.calciumMgPer100g, calciumMgPer100g) || other.calciumMgPer100g == calciumMgPer100g)&&(identical(other.ironMgPer100g, ironMgPer100g) || other.ironMgPer100g == ironMgPer100g)&&(identical(other.vitaminCMgPer100g, vitaminCMgPer100g) || other.vitaminCMgPer100g == vitaminCMgPer100g)&&(identical(other.vitaminDMcgPer100g, vitaminDMcgPer100g) || other.vitaminDMcgPer100g == vitaminDMcgPer100g)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,name,brand,store,barcode,photoPath,caloriesPer100g,proteinPer100g,fatPer100g,carbsPer100g,fiberPer100g,sugarPer100g,sodiumMgPer100g,cholesterolMgPer100g,potassiumMgPer100g,calciumMgPer100g,ironMgPer100g,vitaminCMgPer100g,vitaminDMcgPer100g,isFavorite,createdAt]);
}

@override
String toString() {
    return 'Food(id: $id, name: $name, brand: $brand, store: $store, barcode: $barcode, photoPath: $photoPath, caloriesPer100g: $caloriesPer100g, proteinPer100g: $proteinPer100g, fatPer100g: $fatPer100g, carbsPer100g: $carbsPer100g, fiberPer100g: $fiberPer100g, sugarPer100g: $sugarPer100g, sodiumMgPer100g: $sodiumMgPer100g, cholesterolMgPer100g: $cholesterolMgPer100g, potassiumMgPer100g: $potassiumMgPer100g, calciumMgPer100g: $calciumMgPer100g, ironMgPer100g: $ironMgPer100g, vitaminCMgPer100g: $vitaminCMgPer100g, vitaminDMcgPer100g: $vitaminDMcgPer100g, isFavorite: $isFavorite, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$FoodCopyWith<$Res> implements $FoodCopyWith<$Res> {
  factory _$FoodCopyWith(_Food value, $Res Function(_Food) _then) = __$FoodCopyWithImpl;
@override @useResult
$Res call({
 int? id, String name, String? brand, String? store, String? barcode, String? photoPath, double? caloriesPer100g, double? proteinPer100g, double? fatPer100g, double? carbsPer100g, double? fiberPer100g, double? sugarPer100g, double? sodiumMgPer100g, double? cholesterolMgPer100g, double? potassiumMgPer100g, double? calciumMgPer100g, double? ironMgPer100g, double? vitaminCMgPer100g, double? vitaminDMcgPer100g, bool isFavorite, DateTime? createdAt
});




}
/// @nodoc
class __$FoodCopyWithImpl<$Res>
    implements _$FoodCopyWith<$Res> {
  __$FoodCopyWithImpl(this._self, this._then);

  final _Food _self;
  final $Res Function(_Food) _then;

/// Create a copy of Food
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? brand = freezed,Object? store = freezed,Object? barcode = freezed,Object? photoPath = freezed,Object? caloriesPer100g = freezed,Object? proteinPer100g = freezed,Object? fatPer100g = freezed,Object? carbsPer100g = freezed,Object? fiberPer100g = freezed,Object? sugarPer100g = freezed,Object? sodiumMgPer100g = freezed,Object? cholesterolMgPer100g = freezed,Object? potassiumMgPer100g = freezed,Object? calciumMgPer100g = freezed,Object? ironMgPer100g = freezed,Object? vitaminCMgPer100g = freezed,Object? vitaminDMcgPer100g = freezed,Object? isFavorite = null,Object? createdAt = freezed,}) {
  return _then(_Food(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,store: freezed == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,caloriesPer100g: freezed == caloriesPer100g ? _self.caloriesPer100g : caloriesPer100g // ignore: cast_nullable_to_non_nullable
as double?,proteinPer100g: freezed == proteinPer100g ? _self.proteinPer100g : proteinPer100g // ignore: cast_nullable_to_non_nullable
as double?,fatPer100g: freezed == fatPer100g ? _self.fatPer100g : fatPer100g // ignore: cast_nullable_to_non_nullable
as double?,carbsPer100g: freezed == carbsPer100g ? _self.carbsPer100g : carbsPer100g // ignore: cast_nullable_to_non_nullable
as double?,fiberPer100g: freezed == fiberPer100g ? _self.fiberPer100g : fiberPer100g // ignore: cast_nullable_to_non_nullable
as double?,sugarPer100g: freezed == sugarPer100g ? _self.sugarPer100g : sugarPer100g // ignore: cast_nullable_to_non_nullable
as double?,sodiumMgPer100g: freezed == sodiumMgPer100g ? _self.sodiumMgPer100g : sodiumMgPer100g // ignore: cast_nullable_to_non_nullable
as double?,cholesterolMgPer100g: freezed == cholesterolMgPer100g ? _self.cholesterolMgPer100g : cholesterolMgPer100g // ignore: cast_nullable_to_non_nullable
as double?,potassiumMgPer100g: freezed == potassiumMgPer100g ? _self.potassiumMgPer100g : potassiumMgPer100g // ignore: cast_nullable_to_non_nullable
as double?,calciumMgPer100g: freezed == calciumMgPer100g ? _self.calciumMgPer100g : calciumMgPer100g // ignore: cast_nullable_to_non_nullable
as double?,ironMgPer100g: freezed == ironMgPer100g ? _self.ironMgPer100g : ironMgPer100g // ignore: cast_nullable_to_non_nullable
as double?,vitaminCMgPer100g: freezed == vitaminCMgPer100g ? _self.vitaminCMgPer100g : vitaminCMgPer100g // ignore: cast_nullable_to_non_nullable
as double?,vitaminDMcgPer100g: freezed == vitaminDMcgPer100g ? _self.vitaminDMcgPer100g : vitaminDMcgPer100g // ignore: cast_nullable_to_non_nullable
as double?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
