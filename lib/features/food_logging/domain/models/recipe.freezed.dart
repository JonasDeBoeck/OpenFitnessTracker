// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecipeIngredient {

 int? get id; int get foodId; String get foodName; double get grams; double get caloriesPer100g; double get proteinPer100g; double get fatPer100g; double get carbsPer100g;
/// Create a copy of RecipeIngredient
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipeIngredientCopyWith<RecipeIngredient> get copyWith => _$RecipeIngredientCopyWithImpl<RecipeIngredient>(this as RecipeIngredient, _$identity);

  /// Serializes this RecipeIngredient to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RecipeIngredient;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecipeIngredient&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.foodId, _this.foodId) || other.foodId == _this.foodId)&&(identical(other.foodName, _this.foodName) || other.foodName == _this.foodName)&&(identical(other.grams, _this.grams) || other.grams == _this.grams)&&(identical(other.caloriesPer100g, _this.caloriesPer100g) || other.caloriesPer100g == _this.caloriesPer100g)&&(identical(other.proteinPer100g, _this.proteinPer100g) || other.proteinPer100g == _this.proteinPer100g)&&(identical(other.fatPer100g, _this.fatPer100g) || other.fatPer100g == _this.fatPer100g)&&(identical(other.carbsPer100g, _this.carbsPer100g) || other.carbsPer100g == _this.carbsPer100g));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RecipeIngredient;
  return Object.hash(runtimeType,_this.id,_this.foodId,_this.foodName,_this.grams,_this.caloriesPer100g,_this.proteinPer100g,_this.fatPer100g,_this.carbsPer100g);
}

@override
String toString() {
  final _this = this as RecipeIngredient;
  return 'RecipeIngredient(id: ${_this.id}, foodId: ${_this.foodId}, foodName: ${_this.foodName}, grams: ${_this.grams}, caloriesPer100g: ${_this.caloriesPer100g}, proteinPer100g: ${_this.proteinPer100g}, fatPer100g: ${_this.fatPer100g}, carbsPer100g: ${_this.carbsPer100g})';
}


}

/// @nodoc
abstract mixin class $RecipeIngredientCopyWith<$Res>  {
  factory $RecipeIngredientCopyWith(RecipeIngredient value, $Res Function(RecipeIngredient) _then) = _$RecipeIngredientCopyWithImpl;
@useResult
$Res call({
 int? id, int foodId, String foodName, double grams, double caloriesPer100g, double proteinPer100g, double fatPer100g, double carbsPer100g
});




}
/// @nodoc
class _$RecipeIngredientCopyWithImpl<$Res>
    implements $RecipeIngredientCopyWith<$Res> {
  _$RecipeIngredientCopyWithImpl(this._self, this._then);

  final RecipeIngredient _self;
  final $Res Function(RecipeIngredient) _then;

/// Create a copy of RecipeIngredient
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? foodId = null,Object? foodName = null,Object? grams = null,Object? caloriesPer100g = null,Object? proteinPer100g = null,Object? fatPer100g = null,Object? carbsPer100g = null,}) {
  return _then(RecipeIngredient(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,foodId: null == foodId ? _self.foodId : foodId // ignore: cast_nullable_to_non_nullable
as int,foodName: null == foodName ? _self.foodName : foodName // ignore: cast_nullable_to_non_nullable
as String,grams: null == grams ? _self.grams : grams // ignore: cast_nullable_to_non_nullable
as double,caloriesPer100g: null == caloriesPer100g ? _self.caloriesPer100g : caloriesPer100g // ignore: cast_nullable_to_non_nullable
as double,proteinPer100g: null == proteinPer100g ? _self.proteinPer100g : proteinPer100g // ignore: cast_nullable_to_non_nullable
as double,fatPer100g: null == fatPer100g ? _self.fatPer100g : fatPer100g // ignore: cast_nullable_to_non_nullable
as double,carbsPer100g: null == carbsPer100g ? _self.carbsPer100g : carbsPer100g // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [RecipeIngredient].
extension RecipeIngredientPatterns on RecipeIngredient {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecipeIngredient value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecipeIngredient() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecipeIngredient value)  $default,){
final _that = this;
switch (_that) {
case _RecipeIngredient():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecipeIngredient value)?  $default,){
final _that = this;
switch (_that) {
case _RecipeIngredient() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int foodId,  String foodName,  double grams,  double caloriesPer100g,  double proteinPer100g,  double fatPer100g,  double carbsPer100g)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecipeIngredient() when $default != null:
return $default(_that.id,_that.foodId,_that.foodName,_that.grams,_that.caloriesPer100g,_that.proteinPer100g,_that.fatPer100g,_that.carbsPer100g);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int foodId,  String foodName,  double grams,  double caloriesPer100g,  double proteinPer100g,  double fatPer100g,  double carbsPer100g)  $default,) {final _that = this;
switch (_that) {
case _RecipeIngredient():
return $default(_that.id,_that.foodId,_that.foodName,_that.grams,_that.caloriesPer100g,_that.proteinPer100g,_that.fatPer100g,_that.carbsPer100g);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int foodId,  String foodName,  double grams,  double caloriesPer100g,  double proteinPer100g,  double fatPer100g,  double carbsPer100g)?  $default,) {final _that = this;
switch (_that) {
case _RecipeIngredient() when $default != null:
return $default(_that.id,_that.foodId,_that.foodName,_that.grams,_that.caloriesPer100g,_that.proteinPer100g,_that.fatPer100g,_that.carbsPer100g);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecipeIngredient extends RecipeIngredient {
  const _RecipeIngredient({this.id, required this.foodId, required this.foodName, required this.grams, required this.caloriesPer100g, required this.proteinPer100g, required this.fatPer100g, required this.carbsPer100g}): super._();
  factory _RecipeIngredient.fromJson(Map<String, dynamic> json) => _$RecipeIngredientFromJson(json);

@override final  int? id;
@override final  int foodId;
@override final  String foodName;
@override final  double grams;
@override final  double caloriesPer100g;
@override final  double proteinPer100g;
@override final  double fatPer100g;
@override final  double carbsPer100g;

/// Create a copy of RecipeIngredient
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipeIngredientCopyWith<_RecipeIngredient> get copyWith => __$RecipeIngredientCopyWithImpl<_RecipeIngredient>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecipeIngredientToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecipeIngredient&&(identical(other.id, id) || other.id == id)&&(identical(other.foodId, foodId) || other.foodId == foodId)&&(identical(other.foodName, foodName) || other.foodName == foodName)&&(identical(other.grams, grams) || other.grams == grams)&&(identical(other.caloriesPer100g, caloriesPer100g) || other.caloriesPer100g == caloriesPer100g)&&(identical(other.proteinPer100g, proteinPer100g) || other.proteinPer100g == proteinPer100g)&&(identical(other.fatPer100g, fatPer100g) || other.fatPer100g == fatPer100g)&&(identical(other.carbsPer100g, carbsPer100g) || other.carbsPer100g == carbsPer100g));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,foodId,foodName,grams,caloriesPer100g,proteinPer100g,fatPer100g,carbsPer100g);
}

@override
String toString() {
    return 'RecipeIngredient(id: $id, foodId: $foodId, foodName: $foodName, grams: $grams, caloriesPer100g: $caloriesPer100g, proteinPer100g: $proteinPer100g, fatPer100g: $fatPer100g, carbsPer100g: $carbsPer100g)';
}


}

/// @nodoc
abstract mixin class _$RecipeIngredientCopyWith<$Res> implements $RecipeIngredientCopyWith<$Res> {
  factory _$RecipeIngredientCopyWith(_RecipeIngredient value, $Res Function(_RecipeIngredient) _then) = __$RecipeIngredientCopyWithImpl;
@override @useResult
$Res call({
 int? id, int foodId, String foodName, double grams, double caloriesPer100g, double proteinPer100g, double fatPer100g, double carbsPer100g
});




}
/// @nodoc
class __$RecipeIngredientCopyWithImpl<$Res>
    implements _$RecipeIngredientCopyWith<$Res> {
  __$RecipeIngredientCopyWithImpl(this._self, this._then);

  final _RecipeIngredient _self;
  final $Res Function(_RecipeIngredient) _then;

/// Create a copy of RecipeIngredient
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? foodId = null,Object? foodName = null,Object? grams = null,Object? caloriesPer100g = null,Object? proteinPer100g = null,Object? fatPer100g = null,Object? carbsPer100g = null,}) {
  return _then(_RecipeIngredient(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,foodId: null == foodId ? _self.foodId : foodId // ignore: cast_nullable_to_non_nullable
as int,foodName: null == foodName ? _self.foodName : foodName // ignore: cast_nullable_to_non_nullable
as String,grams: null == grams ? _self.grams : grams // ignore: cast_nullable_to_non_nullable
as double,caloriesPer100g: null == caloriesPer100g ? _self.caloriesPer100g : caloriesPer100g // ignore: cast_nullable_to_non_nullable
as double,proteinPer100g: null == proteinPer100g ? _self.proteinPer100g : proteinPer100g // ignore: cast_nullable_to_non_nullable
as double,fatPer100g: null == fatPer100g ? _self.fatPer100g : fatPer100g // ignore: cast_nullable_to_non_nullable
as double,carbsPer100g: null == carbsPer100g ? _self.carbsPer100g : carbsPer100g // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$Recipe {

 int? get id; String get name; List<String> get labels; int? get servings; String? get prepTime; String? get cookTime; List<String> get instructions; String? get photoPath; bool get isFavorite; DateTime? get createdAt; List<RecipeIngredient> get ingredients;
/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipeCopyWith<Recipe> get copyWith => _$RecipeCopyWithImpl<Recipe>(this as Recipe, _$identity);

  /// Serializes this Recipe to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Recipe;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Recipe&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.labels, _this.labels)&&(identical(other.servings, _this.servings) || other.servings == _this.servings)&&(identical(other.prepTime, _this.prepTime) || other.prepTime == _this.prepTime)&&(identical(other.cookTime, _this.cookTime) || other.cookTime == _this.cookTime)&&const DeepCollectionEquality().equals(other.instructions, _this.instructions)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath)&&(identical(other.isFavorite, _this.isFavorite) || other.isFavorite == _this.isFavorite)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&const DeepCollectionEquality().equals(other.ingredients, _this.ingredients));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Recipe;
  return Object.hash(runtimeType,_this.id,_this.name,const DeepCollectionEquality().hash(_this.labels),_this.servings,_this.prepTime,_this.cookTime,const DeepCollectionEquality().hash(_this.instructions),_this.photoPath,_this.isFavorite,_this.createdAt,const DeepCollectionEquality().hash(_this.ingredients));
}

@override
String toString() {
  final _this = this as Recipe;
  return 'Recipe(id: ${_this.id}, name: ${_this.name}, labels: ${_this.labels}, servings: ${_this.servings}, prepTime: ${_this.prepTime}, cookTime: ${_this.cookTime}, instructions: ${_this.instructions}, photoPath: ${_this.photoPath}, isFavorite: ${_this.isFavorite}, createdAt: ${_this.createdAt}, ingredients: ${_this.ingredients})';
}


}

/// @nodoc
abstract mixin class $RecipeCopyWith<$Res>  {
  factory $RecipeCopyWith(Recipe value, $Res Function(Recipe) _then) = _$RecipeCopyWithImpl;
@useResult
$Res call({
 int? id, String name, List<String> labels, int? servings, String? prepTime, String? cookTime, List<String> instructions, String? photoPath, bool isFavorite, DateTime? createdAt, List<RecipeIngredient> ingredients
});




}
/// @nodoc
class _$RecipeCopyWithImpl<$Res>
    implements $RecipeCopyWith<$Res> {
  _$RecipeCopyWithImpl(this._self, this._then);

  final Recipe _self;
  final $Res Function(Recipe) _then;

/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? labels = null,Object? servings = freezed,Object? prepTime = freezed,Object? cookTime = freezed,Object? instructions = null,Object? photoPath = freezed,Object? isFavorite = null,Object? createdAt = freezed,Object? ingredients = null,}) {
  return _then(Recipe(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<String>,servings: freezed == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as int?,prepTime: freezed == prepTime ? _self.prepTime : prepTime // ignore: cast_nullable_to_non_nullable
as String?,cookTime: freezed == cookTime ? _self.cookTime : cookTime // ignore: cast_nullable_to_non_nullable
as String?,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as List<String>,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,ingredients: null == ingredients ? _self.ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<RecipeIngredient>,
  ));
}

}


/// Adds pattern-matching-related methods to [Recipe].
extension RecipePatterns on Recipe {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Recipe value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Recipe() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Recipe value)  $default,){
final _that = this;
switch (_that) {
case _Recipe():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Recipe value)?  $default,){
final _that = this;
switch (_that) {
case _Recipe() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String name,  List<String> labels,  int? servings,  String? prepTime,  String? cookTime,  List<String> instructions,  String? photoPath,  bool isFavorite,  DateTime? createdAt,  List<RecipeIngredient> ingredients)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Recipe() when $default != null:
return $default(_that.id,_that.name,_that.labels,_that.servings,_that.prepTime,_that.cookTime,_that.instructions,_that.photoPath,_that.isFavorite,_that.createdAt,_that.ingredients);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String name,  List<String> labels,  int? servings,  String? prepTime,  String? cookTime,  List<String> instructions,  String? photoPath,  bool isFavorite,  DateTime? createdAt,  List<RecipeIngredient> ingredients)  $default,) {final _that = this;
switch (_that) {
case _Recipe():
return $default(_that.id,_that.name,_that.labels,_that.servings,_that.prepTime,_that.cookTime,_that.instructions,_that.photoPath,_that.isFavorite,_that.createdAt,_that.ingredients);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String name,  List<String> labels,  int? servings,  String? prepTime,  String? cookTime,  List<String> instructions,  String? photoPath,  bool isFavorite,  DateTime? createdAt,  List<RecipeIngredient> ingredients)?  $default,) {final _that = this;
switch (_that) {
case _Recipe() when $default != null:
return $default(_that.id,_that.name,_that.labels,_that.servings,_that.prepTime,_that.cookTime,_that.instructions,_that.photoPath,_that.isFavorite,_that.createdAt,_that.ingredients);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Recipe extends Recipe {
  const _Recipe({this.id, required this.name,  List<String> labels = const <String>[], this.servings, this.prepTime, this.cookTime,  List<String> instructions = const <String>[], this.photoPath, this.isFavorite = false, this.createdAt,  List<RecipeIngredient> ingredients = const <RecipeIngredient>[]}): _labels = labels,_instructions = instructions,_ingredients = ingredients,super._();
  factory _Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

@override final  int? id;
@override final  String name;
 final  List<String> _labels;
@override@JsonKey() List<String> get labels {
  if (_labels is EqualUnmodifiableListView) return _labels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_labels);
}

@override final  int? servings;
@override final  String? prepTime;
@override final  String? cookTime;
 final  List<String> _instructions;
@override@JsonKey() List<String> get instructions {
  if (_instructions is EqualUnmodifiableListView) return _instructions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_instructions);
}

@override final  String? photoPath;
@override@JsonKey() final  bool isFavorite;
@override final  DateTime? createdAt;
 final  List<RecipeIngredient> _ingredients;
@override@JsonKey() List<RecipeIngredient> get ingredients {
  if (_ingredients is EqualUnmodifiableListView) return _ingredients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ingredients);
}


/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipeCopyWith<_Recipe> get copyWith => __$RecipeCopyWithImpl<_Recipe>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecipeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Recipe&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.labels, _labels)&&(identical(other.servings, servings) || other.servings == servings)&&(identical(other.prepTime, prepTime) || other.prepTime == prepTime)&&(identical(other.cookTime, cookTime) || other.cookTime == cookTime)&&const DeepCollectionEquality().equals(other.instructions, _instructions)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.ingredients, _ingredients));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_labels),servings,prepTime,cookTime,const DeepCollectionEquality().hash(_instructions),photoPath,isFavorite,createdAt,const DeepCollectionEquality().hash(_ingredients));
}

@override
String toString() {
    return 'Recipe(id: $id, name: $name, labels: $labels, servings: $servings, prepTime: $prepTime, cookTime: $cookTime, instructions: $instructions, photoPath: $photoPath, isFavorite: $isFavorite, createdAt: $createdAt, ingredients: $ingredients)';
}


}

/// @nodoc
abstract mixin class _$RecipeCopyWith<$Res> implements $RecipeCopyWith<$Res> {
  factory _$RecipeCopyWith(_Recipe value, $Res Function(_Recipe) _then) = __$RecipeCopyWithImpl;
@override @useResult
$Res call({
 int? id, String name, List<String> labels, int? servings, String? prepTime, String? cookTime, List<String> instructions, String? photoPath, bool isFavorite, DateTime? createdAt, List<RecipeIngredient> ingredients
});




}
/// @nodoc
class __$RecipeCopyWithImpl<$Res>
    implements _$RecipeCopyWith<$Res> {
  __$RecipeCopyWithImpl(this._self, this._then);

  final _Recipe _self;
  final $Res Function(_Recipe) _then;

/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? labels = null,Object? servings = freezed,Object? prepTime = freezed,Object? cookTime = freezed,Object? instructions = null,Object? photoPath = freezed,Object? isFavorite = null,Object? createdAt = freezed,Object? ingredients = null,}) {
  return _then(_Recipe(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,labels: null == labels ? _self._labels : labels // ignore: cast_nullable_to_non_nullable
as List<String>,servings: freezed == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as int?,prepTime: freezed == prepTime ? _self.prepTime : prepTime // ignore: cast_nullable_to_non_nullable
as String?,cookTime: freezed == cookTime ? _self.cookTime : cookTime // ignore: cast_nullable_to_non_nullable
as String?,instructions: null == instructions ? _self._instructions : instructions // ignore: cast_nullable_to_non_nullable
as List<String>,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,ingredients: null == ingredients ? _self._ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<RecipeIngredient>,
  ));
}


}

// dart format on
