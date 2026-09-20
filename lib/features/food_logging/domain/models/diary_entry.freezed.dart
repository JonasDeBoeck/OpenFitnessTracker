// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diary_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DiaryEntry {

 int? get id; int? get foodId; String? get foodName; int? get recipeId; String? get recipeName; MealType get mealType; DateTime get loggedAt; double get quantityGrams; double get calories; double get protein; double get fat; double get carbs; double? get fiber; double? get sugar; double? get sodiumMg; double? get cholesterolMg; double? get potassiumMg; double? get calciumMg; double? get ironMg; double? get vitaminCMg; double? get vitaminDMcg;
/// Create a copy of DiaryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiaryEntryCopyWith<DiaryEntry> get copyWith => _$DiaryEntryCopyWithImpl<DiaryEntry>(this as DiaryEntry, _$identity);

  /// Serializes this DiaryEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DiaryEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiaryEntry&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.foodId, _this.foodId) || other.foodId == _this.foodId)&&(identical(other.foodName, _this.foodName) || other.foodName == _this.foodName)&&(identical(other.recipeId, _this.recipeId) || other.recipeId == _this.recipeId)&&(identical(other.recipeName, _this.recipeName) || other.recipeName == _this.recipeName)&&(identical(other.mealType, _this.mealType) || other.mealType == _this.mealType)&&(identical(other.loggedAt, _this.loggedAt) || other.loggedAt == _this.loggedAt)&&(identical(other.quantityGrams, _this.quantityGrams) || other.quantityGrams == _this.quantityGrams)&&(identical(other.calories, _this.calories) || other.calories == _this.calories)&&(identical(other.protein, _this.protein) || other.protein == _this.protein)&&(identical(other.fat, _this.fat) || other.fat == _this.fat)&&(identical(other.carbs, _this.carbs) || other.carbs == _this.carbs)&&(identical(other.fiber, _this.fiber) || other.fiber == _this.fiber)&&(identical(other.sugar, _this.sugar) || other.sugar == _this.sugar)&&(identical(other.sodiumMg, _this.sodiumMg) || other.sodiumMg == _this.sodiumMg)&&(identical(other.cholesterolMg, _this.cholesterolMg) || other.cholesterolMg == _this.cholesterolMg)&&(identical(other.potassiumMg, _this.potassiumMg) || other.potassiumMg == _this.potassiumMg)&&(identical(other.calciumMg, _this.calciumMg) || other.calciumMg == _this.calciumMg)&&(identical(other.ironMg, _this.ironMg) || other.ironMg == _this.ironMg)&&(identical(other.vitaminCMg, _this.vitaminCMg) || other.vitaminCMg == _this.vitaminCMg)&&(identical(other.vitaminDMcg, _this.vitaminDMcg) || other.vitaminDMcg == _this.vitaminDMcg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DiaryEntry;
  return Object.hashAll([runtimeType,_this.id,_this.foodId,_this.foodName,_this.recipeId,_this.recipeName,_this.mealType,_this.loggedAt,_this.quantityGrams,_this.calories,_this.protein,_this.fat,_this.carbs,_this.fiber,_this.sugar,_this.sodiumMg,_this.cholesterolMg,_this.potassiumMg,_this.calciumMg,_this.ironMg,_this.vitaminCMg,_this.vitaminDMcg]);
}

@override
String toString() {
  final _this = this as DiaryEntry;
  return 'DiaryEntry(id: ${_this.id}, foodId: ${_this.foodId}, foodName: ${_this.foodName}, recipeId: ${_this.recipeId}, recipeName: ${_this.recipeName}, mealType: ${_this.mealType}, loggedAt: ${_this.loggedAt}, quantityGrams: ${_this.quantityGrams}, calories: ${_this.calories}, protein: ${_this.protein}, fat: ${_this.fat}, carbs: ${_this.carbs}, fiber: ${_this.fiber}, sugar: ${_this.sugar}, sodiumMg: ${_this.sodiumMg}, cholesterolMg: ${_this.cholesterolMg}, potassiumMg: ${_this.potassiumMg}, calciumMg: ${_this.calciumMg}, ironMg: ${_this.ironMg}, vitaminCMg: ${_this.vitaminCMg}, vitaminDMcg: ${_this.vitaminDMcg})';
}


}

/// @nodoc
abstract mixin class $DiaryEntryCopyWith<$Res>  {
  factory $DiaryEntryCopyWith(DiaryEntry value, $Res Function(DiaryEntry) _then) = _$DiaryEntryCopyWithImpl;
@useResult
$Res call({
 int? id, int? foodId, String? foodName, int? recipeId, String? recipeName, MealType mealType, DateTime loggedAt, double quantityGrams, double calories, double protein, double fat, double carbs, double? fiber, double? sugar, double? sodiumMg, double? cholesterolMg, double? potassiumMg, double? calciumMg, double? ironMg, double? vitaminCMg, double? vitaminDMcg
});




}
/// @nodoc
class _$DiaryEntryCopyWithImpl<$Res>
    implements $DiaryEntryCopyWith<$Res> {
  _$DiaryEntryCopyWithImpl(this._self, this._then);

  final DiaryEntry _self;
  final $Res Function(DiaryEntry) _then;

/// Create a copy of DiaryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? foodId = freezed,Object? foodName = freezed,Object? recipeId = freezed,Object? recipeName = freezed,Object? mealType = null,Object? loggedAt = null,Object? quantityGrams = null,Object? calories = null,Object? protein = null,Object? fat = null,Object? carbs = null,Object? fiber = freezed,Object? sugar = freezed,Object? sodiumMg = freezed,Object? cholesterolMg = freezed,Object? potassiumMg = freezed,Object? calciumMg = freezed,Object? ironMg = freezed,Object? vitaminCMg = freezed,Object? vitaminDMcg = freezed,}) {
  return _then(DiaryEntry(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,foodId: freezed == foodId ? _self.foodId : foodId // ignore: cast_nullable_to_non_nullable
as int?,foodName: freezed == foodName ? _self.foodName : foodName // ignore: cast_nullable_to_non_nullable
as String?,recipeId: freezed == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as int?,recipeName: freezed == recipeName ? _self.recipeName : recipeName // ignore: cast_nullable_to_non_nullable
as String?,mealType: null == mealType ? _self.mealType : mealType // ignore: cast_nullable_to_non_nullable
as MealType,loggedAt: null == loggedAt ? _self.loggedAt : loggedAt // ignore: cast_nullable_to_non_nullable
as DateTime,quantityGrams: null == quantityGrams ? _self.quantityGrams : quantityGrams // ignore: cast_nullable_to_non_nullable
as double,calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as double,protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double,carbs: null == carbs ? _self.carbs : carbs // ignore: cast_nullable_to_non_nullable
as double,fiber: freezed == fiber ? _self.fiber : fiber // ignore: cast_nullable_to_non_nullable
as double?,sugar: freezed == sugar ? _self.sugar : sugar // ignore: cast_nullable_to_non_nullable
as double?,sodiumMg: freezed == sodiumMg ? _self.sodiumMg : sodiumMg // ignore: cast_nullable_to_non_nullable
as double?,cholesterolMg: freezed == cholesterolMg ? _self.cholesterolMg : cholesterolMg // ignore: cast_nullable_to_non_nullable
as double?,potassiumMg: freezed == potassiumMg ? _self.potassiumMg : potassiumMg // ignore: cast_nullable_to_non_nullable
as double?,calciumMg: freezed == calciumMg ? _self.calciumMg : calciumMg // ignore: cast_nullable_to_non_nullable
as double?,ironMg: freezed == ironMg ? _self.ironMg : ironMg // ignore: cast_nullable_to_non_nullable
as double?,vitaminCMg: freezed == vitaminCMg ? _self.vitaminCMg : vitaminCMg // ignore: cast_nullable_to_non_nullable
as double?,vitaminDMcg: freezed == vitaminDMcg ? _self.vitaminDMcg : vitaminDMcg // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [DiaryEntry].
extension DiaryEntryPatterns on DiaryEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiaryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiaryEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiaryEntry value)  $default,){
final _that = this;
switch (_that) {
case _DiaryEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiaryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _DiaryEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int? foodId,  String? foodName,  int? recipeId,  String? recipeName,  MealType mealType,  DateTime loggedAt,  double quantityGrams,  double calories,  double protein,  double fat,  double carbs,  double? fiber,  double? sugar,  double? sodiumMg,  double? cholesterolMg,  double? potassiumMg,  double? calciumMg,  double? ironMg,  double? vitaminCMg,  double? vitaminDMcg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiaryEntry() when $default != null:
return $default(_that.id,_that.foodId,_that.foodName,_that.recipeId,_that.recipeName,_that.mealType,_that.loggedAt,_that.quantityGrams,_that.calories,_that.protein,_that.fat,_that.carbs,_that.fiber,_that.sugar,_that.sodiumMg,_that.cholesterolMg,_that.potassiumMg,_that.calciumMg,_that.ironMg,_that.vitaminCMg,_that.vitaminDMcg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int? foodId,  String? foodName,  int? recipeId,  String? recipeName,  MealType mealType,  DateTime loggedAt,  double quantityGrams,  double calories,  double protein,  double fat,  double carbs,  double? fiber,  double? sugar,  double? sodiumMg,  double? cholesterolMg,  double? potassiumMg,  double? calciumMg,  double? ironMg,  double? vitaminCMg,  double? vitaminDMcg)  $default,) {final _that = this;
switch (_that) {
case _DiaryEntry():
return $default(_that.id,_that.foodId,_that.foodName,_that.recipeId,_that.recipeName,_that.mealType,_that.loggedAt,_that.quantityGrams,_that.calories,_that.protein,_that.fat,_that.carbs,_that.fiber,_that.sugar,_that.sodiumMg,_that.cholesterolMg,_that.potassiumMg,_that.calciumMg,_that.ironMg,_that.vitaminCMg,_that.vitaminDMcg);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int? foodId,  String? foodName,  int? recipeId,  String? recipeName,  MealType mealType,  DateTime loggedAt,  double quantityGrams,  double calories,  double protein,  double fat,  double carbs,  double? fiber,  double? sugar,  double? sodiumMg,  double? cholesterolMg,  double? potassiumMg,  double? calciumMg,  double? ironMg,  double? vitaminCMg,  double? vitaminDMcg)?  $default,) {final _that = this;
switch (_that) {
case _DiaryEntry() when $default != null:
return $default(_that.id,_that.foodId,_that.foodName,_that.recipeId,_that.recipeName,_that.mealType,_that.loggedAt,_that.quantityGrams,_that.calories,_that.protein,_that.fat,_that.carbs,_that.fiber,_that.sugar,_that.sodiumMg,_that.cholesterolMg,_that.potassiumMg,_that.calciumMg,_that.ironMg,_that.vitaminCMg,_that.vitaminDMcg);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiaryEntry extends DiaryEntry {
  const _DiaryEntry({this.id, this.foodId, this.foodName, this.recipeId, this.recipeName, required this.mealType, required this.loggedAt, required this.quantityGrams, required this.calories, required this.protein, required this.fat, required this.carbs, this.fiber, this.sugar, this.sodiumMg, this.cholesterolMg, this.potassiumMg, this.calciumMg, this.ironMg, this.vitaminCMg, this.vitaminDMcg}): super._();
  factory _DiaryEntry.fromJson(Map<String, dynamic> json) => _$DiaryEntryFromJson(json);

@override final  int? id;
@override final  int? foodId;
@override final  String? foodName;
@override final  int? recipeId;
@override final  String? recipeName;
@override final  MealType mealType;
@override final  DateTime loggedAt;
@override final  double quantityGrams;
@override final  double calories;
@override final  double protein;
@override final  double fat;
@override final  double carbs;
@override final  double? fiber;
@override final  double? sugar;
@override final  double? sodiumMg;
@override final  double? cholesterolMg;
@override final  double? potassiumMg;
@override final  double? calciumMg;
@override final  double? ironMg;
@override final  double? vitaminCMg;
@override final  double? vitaminDMcg;

/// Create a copy of DiaryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryEntryCopyWith<_DiaryEntry> get copyWith => __$DiaryEntryCopyWithImpl<_DiaryEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiaryEntryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.foodId, foodId) || other.foodId == foodId)&&(identical(other.foodName, foodName) || other.foodName == foodName)&&(identical(other.recipeId, recipeId) || other.recipeId == recipeId)&&(identical(other.recipeName, recipeName) || other.recipeName == recipeName)&&(identical(other.mealType, mealType) || other.mealType == mealType)&&(identical(other.loggedAt, loggedAt) || other.loggedAt == loggedAt)&&(identical(other.quantityGrams, quantityGrams) || other.quantityGrams == quantityGrams)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.fat, fat) || other.fat == fat)&&(identical(other.carbs, carbs) || other.carbs == carbs)&&(identical(other.fiber, fiber) || other.fiber == fiber)&&(identical(other.sugar, sugar) || other.sugar == sugar)&&(identical(other.sodiumMg, sodiumMg) || other.sodiumMg == sodiumMg)&&(identical(other.cholesterolMg, cholesterolMg) || other.cholesterolMg == cholesterolMg)&&(identical(other.potassiumMg, potassiumMg) || other.potassiumMg == potassiumMg)&&(identical(other.calciumMg, calciumMg) || other.calciumMg == calciumMg)&&(identical(other.ironMg, ironMg) || other.ironMg == ironMg)&&(identical(other.vitaminCMg, vitaminCMg) || other.vitaminCMg == vitaminCMg)&&(identical(other.vitaminDMcg, vitaminDMcg) || other.vitaminDMcg == vitaminDMcg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,foodId,foodName,recipeId,recipeName,mealType,loggedAt,quantityGrams,calories,protein,fat,carbs,fiber,sugar,sodiumMg,cholesterolMg,potassiumMg,calciumMg,ironMg,vitaminCMg,vitaminDMcg]);
}

@override
String toString() {
    return 'DiaryEntry(id: $id, foodId: $foodId, foodName: $foodName, recipeId: $recipeId, recipeName: $recipeName, mealType: $mealType, loggedAt: $loggedAt, quantityGrams: $quantityGrams, calories: $calories, protein: $protein, fat: $fat, carbs: $carbs, fiber: $fiber, sugar: $sugar, sodiumMg: $sodiumMg, cholesterolMg: $cholesterolMg, potassiumMg: $potassiumMg, calciumMg: $calciumMg, ironMg: $ironMg, vitaminCMg: $vitaminCMg, vitaminDMcg: $vitaminDMcg)';
}


}

/// @nodoc
abstract mixin class _$DiaryEntryCopyWith<$Res> implements $DiaryEntryCopyWith<$Res> {
  factory _$DiaryEntryCopyWith(_DiaryEntry value, $Res Function(_DiaryEntry) _then) = __$DiaryEntryCopyWithImpl;
@override @useResult
$Res call({
 int? id, int? foodId, String? foodName, int? recipeId, String? recipeName, MealType mealType, DateTime loggedAt, double quantityGrams, double calories, double protein, double fat, double carbs, double? fiber, double? sugar, double? sodiumMg, double? cholesterolMg, double? potassiumMg, double? calciumMg, double? ironMg, double? vitaminCMg, double? vitaminDMcg
});




}
/// @nodoc
class __$DiaryEntryCopyWithImpl<$Res>
    implements _$DiaryEntryCopyWith<$Res> {
  __$DiaryEntryCopyWithImpl(this._self, this._then);

  final _DiaryEntry _self;
  final $Res Function(_DiaryEntry) _then;

/// Create a copy of DiaryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? foodId = freezed,Object? foodName = freezed,Object? recipeId = freezed,Object? recipeName = freezed,Object? mealType = null,Object? loggedAt = null,Object? quantityGrams = null,Object? calories = null,Object? protein = null,Object? fat = null,Object? carbs = null,Object? fiber = freezed,Object? sugar = freezed,Object? sodiumMg = freezed,Object? cholesterolMg = freezed,Object? potassiumMg = freezed,Object? calciumMg = freezed,Object? ironMg = freezed,Object? vitaminCMg = freezed,Object? vitaminDMcg = freezed,}) {
  return _then(_DiaryEntry(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,foodId: freezed == foodId ? _self.foodId : foodId // ignore: cast_nullable_to_non_nullable
as int?,foodName: freezed == foodName ? _self.foodName : foodName // ignore: cast_nullable_to_non_nullable
as String?,recipeId: freezed == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as int?,recipeName: freezed == recipeName ? _self.recipeName : recipeName // ignore: cast_nullable_to_non_nullable
as String?,mealType: null == mealType ? _self.mealType : mealType // ignore: cast_nullable_to_non_nullable
as MealType,loggedAt: null == loggedAt ? _self.loggedAt : loggedAt // ignore: cast_nullable_to_non_nullable
as DateTime,quantityGrams: null == quantityGrams ? _self.quantityGrams : quantityGrams // ignore: cast_nullable_to_non_nullable
as double,calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as double,protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double,carbs: null == carbs ? _self.carbs : carbs // ignore: cast_nullable_to_non_nullable
as double,fiber: freezed == fiber ? _self.fiber : fiber // ignore: cast_nullable_to_non_nullable
as double?,sugar: freezed == sugar ? _self.sugar : sugar // ignore: cast_nullable_to_non_nullable
as double?,sodiumMg: freezed == sodiumMg ? _self.sodiumMg : sodiumMg // ignore: cast_nullable_to_non_nullable
as double?,cholesterolMg: freezed == cholesterolMg ? _self.cholesterolMg : cholesterolMg // ignore: cast_nullable_to_non_nullable
as double?,potassiumMg: freezed == potassiumMg ? _self.potassiumMg : potassiumMg // ignore: cast_nullable_to_non_nullable
as double?,calciumMg: freezed == calciumMg ? _self.calciumMg : calciumMg // ignore: cast_nullable_to_non_nullable
as double?,ironMg: freezed == ironMg ? _self.ironMg : ironMg // ignore: cast_nullable_to_non_nullable
as double?,vitaminCMg: freezed == vitaminCMg ? _self.vitaminCMg : vitaminCMg // ignore: cast_nullable_to_non_nullable
as double?,vitaminDMcg: freezed == vitaminDMcg ? _self.vitaminDMcg : vitaminDMcg // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
