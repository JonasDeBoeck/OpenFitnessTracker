// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_recipe_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreateRecipeFormState {

 String? get photoPath; String get name; List<String> get labels; List<RecipeIngredient> get ingredients; int? get servings; String? get prepTime; String? get cookTime; String get instructionsText; bool get showInstructions; bool get isFavorite; bool get isSaving; bool get isPickingPhoto; String? get photoError; String? get nameError; String? get saveError; Recipe? get savedRecipe;
/// Create a copy of CreateRecipeFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateRecipeFormStateCopyWith<CreateRecipeFormState> get copyWith => _$CreateRecipeFormStateCopyWithImpl<CreateRecipeFormState>(this as CreateRecipeFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CreateRecipeFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateRecipeFormState&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.labels, _this.labels)&&const DeepCollectionEquality().equals(other.ingredients, _this.ingredients)&&(identical(other.servings, _this.servings) || other.servings == _this.servings)&&(identical(other.prepTime, _this.prepTime) || other.prepTime == _this.prepTime)&&(identical(other.cookTime, _this.cookTime) || other.cookTime == _this.cookTime)&&(identical(other.instructionsText, _this.instructionsText) || other.instructionsText == _this.instructionsText)&&(identical(other.showInstructions, _this.showInstructions) || other.showInstructions == _this.showInstructions)&&(identical(other.isFavorite, _this.isFavorite) || other.isFavorite == _this.isFavorite)&&(identical(other.isSaving, _this.isSaving) || other.isSaving == _this.isSaving)&&(identical(other.isPickingPhoto, _this.isPickingPhoto) || other.isPickingPhoto == _this.isPickingPhoto)&&(identical(other.photoError, _this.photoError) || other.photoError == _this.photoError)&&(identical(other.nameError, _this.nameError) || other.nameError == _this.nameError)&&(identical(other.saveError, _this.saveError) || other.saveError == _this.saveError)&&(identical(other.savedRecipe, _this.savedRecipe) || other.savedRecipe == _this.savedRecipe));
}


@override
int get hashCode {
  final _this = this as CreateRecipeFormState;
  return Object.hash(runtimeType,_this.photoPath,_this.name,const DeepCollectionEquality().hash(_this.labels),const DeepCollectionEquality().hash(_this.ingredients),_this.servings,_this.prepTime,_this.cookTime,_this.instructionsText,_this.showInstructions,_this.isFavorite,_this.isSaving,_this.isPickingPhoto,_this.photoError,_this.nameError,_this.saveError,_this.savedRecipe);
}

@override
String toString() {
  final _this = this as CreateRecipeFormState;
  return 'CreateRecipeFormState(photoPath: ${_this.photoPath}, name: ${_this.name}, labels: ${_this.labels}, ingredients: ${_this.ingredients}, servings: ${_this.servings}, prepTime: ${_this.prepTime}, cookTime: ${_this.cookTime}, instructionsText: ${_this.instructionsText}, showInstructions: ${_this.showInstructions}, isFavorite: ${_this.isFavorite}, isSaving: ${_this.isSaving}, isPickingPhoto: ${_this.isPickingPhoto}, photoError: ${_this.photoError}, nameError: ${_this.nameError}, saveError: ${_this.saveError}, savedRecipe: ${_this.savedRecipe})';
}


}

/// @nodoc
abstract mixin class $CreateRecipeFormStateCopyWith<$Res>  {
  factory $CreateRecipeFormStateCopyWith(CreateRecipeFormState value, $Res Function(CreateRecipeFormState) _then) = _$CreateRecipeFormStateCopyWithImpl;
@useResult
$Res call({
 String? photoPath, String name, List<String> labels, List<RecipeIngredient> ingredients, int? servings, String? prepTime, String? cookTime, String instructionsText, bool showInstructions, bool isFavorite, bool isSaving, bool isPickingPhoto, String? photoError, String? nameError, String? saveError, Recipe? savedRecipe
});


$RecipeCopyWith<$Res>? get savedRecipe;

}
/// @nodoc
class _$CreateRecipeFormStateCopyWithImpl<$Res>
    implements $CreateRecipeFormStateCopyWith<$Res> {
  _$CreateRecipeFormStateCopyWithImpl(this._self, this._then);

  final CreateRecipeFormState _self;
  final $Res Function(CreateRecipeFormState) _then;

/// Create a copy of CreateRecipeFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? photoPath = freezed,Object? name = null,Object? labels = null,Object? ingredients = null,Object? servings = freezed,Object? prepTime = freezed,Object? cookTime = freezed,Object? instructionsText = null,Object? showInstructions = null,Object? isFavorite = null,Object? isSaving = null,Object? isPickingPhoto = null,Object? photoError = freezed,Object? nameError = freezed,Object? saveError = freezed,Object? savedRecipe = freezed,}) {
  return _then(CreateRecipeFormState(
photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<String>,ingredients: null == ingredients ? _self.ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<RecipeIngredient>,servings: freezed == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as int?,prepTime: freezed == prepTime ? _self.prepTime : prepTime // ignore: cast_nullable_to_non_nullable
as String?,cookTime: freezed == cookTime ? _self.cookTime : cookTime // ignore: cast_nullable_to_non_nullable
as String?,instructionsText: null == instructionsText ? _self.instructionsText : instructionsText // ignore: cast_nullable_to_non_nullable
as String,showInstructions: null == showInstructions ? _self.showInstructions : showInstructions // ignore: cast_nullable_to_non_nullable
as bool,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,isPickingPhoto: null == isPickingPhoto ? _self.isPickingPhoto : isPickingPhoto // ignore: cast_nullable_to_non_nullable
as bool,photoError: freezed == photoError ? _self.photoError : photoError // ignore: cast_nullable_to_non_nullable
as String?,nameError: freezed == nameError ? _self.nameError : nameError // ignore: cast_nullable_to_non_nullable
as String?,saveError: freezed == saveError ? _self.saveError : saveError // ignore: cast_nullable_to_non_nullable
as String?,savedRecipe: freezed == savedRecipe ? _self.savedRecipe : savedRecipe // ignore: cast_nullable_to_non_nullable
as Recipe?,
  ));
}
/// Create a copy of CreateRecipeFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecipeCopyWith<$Res>? get savedRecipe {
    if (_self.savedRecipe == null) {
    return null;
  }

  return $RecipeCopyWith<$Res>(_self.savedRecipe!, (value) {
    return _then(_self.copyWith(savedRecipe: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreateRecipeFormState].
extension CreateRecipeFormStatePatterns on CreateRecipeFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateRecipeFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateRecipeFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateRecipeFormState value)  $default,){
final _that = this;
switch (_that) {
case _CreateRecipeFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateRecipeFormState value)?  $default,){
final _that = this;
switch (_that) {
case _CreateRecipeFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? photoPath,  String name,  List<String> labels,  List<RecipeIngredient> ingredients,  int? servings,  String? prepTime,  String? cookTime,  String instructionsText,  bool showInstructions,  bool isFavorite,  bool isSaving,  bool isPickingPhoto,  String? photoError,  String? nameError,  String? saveError,  Recipe? savedRecipe)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateRecipeFormState() when $default != null:
return $default(_that.photoPath,_that.name,_that.labels,_that.ingredients,_that.servings,_that.prepTime,_that.cookTime,_that.instructionsText,_that.showInstructions,_that.isFavorite,_that.isSaving,_that.isPickingPhoto,_that.photoError,_that.nameError,_that.saveError,_that.savedRecipe);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? photoPath,  String name,  List<String> labels,  List<RecipeIngredient> ingredients,  int? servings,  String? prepTime,  String? cookTime,  String instructionsText,  bool showInstructions,  bool isFavorite,  bool isSaving,  bool isPickingPhoto,  String? photoError,  String? nameError,  String? saveError,  Recipe? savedRecipe)  $default,) {final _that = this;
switch (_that) {
case _CreateRecipeFormState():
return $default(_that.photoPath,_that.name,_that.labels,_that.ingredients,_that.servings,_that.prepTime,_that.cookTime,_that.instructionsText,_that.showInstructions,_that.isFavorite,_that.isSaving,_that.isPickingPhoto,_that.photoError,_that.nameError,_that.saveError,_that.savedRecipe);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? photoPath,  String name,  List<String> labels,  List<RecipeIngredient> ingredients,  int? servings,  String? prepTime,  String? cookTime,  String instructionsText,  bool showInstructions,  bool isFavorite,  bool isSaving,  bool isPickingPhoto,  String? photoError,  String? nameError,  String? saveError,  Recipe? savedRecipe)?  $default,) {final _that = this;
switch (_that) {
case _CreateRecipeFormState() when $default != null:
return $default(_that.photoPath,_that.name,_that.labels,_that.ingredients,_that.servings,_that.prepTime,_that.cookTime,_that.instructionsText,_that.showInstructions,_that.isFavorite,_that.isSaving,_that.isPickingPhoto,_that.photoError,_that.nameError,_that.saveError,_that.savedRecipe);case _:
  return null;

}
}

}

/// @nodoc


class _CreateRecipeFormState implements CreateRecipeFormState {
  const _CreateRecipeFormState({this.photoPath, this.name = '',  List<String> labels = const <String>[],  List<RecipeIngredient> ingredients = const <RecipeIngredient>[], this.servings, this.prepTime, this.cookTime, this.instructionsText = '', this.showInstructions = false, this.isFavorite = false, this.isSaving = false, this.isPickingPhoto = false, this.photoError, this.nameError, this.saveError, this.savedRecipe}): _labels = labels,_ingredients = ingredients;
  

@override final  String? photoPath;
@override@JsonKey() final  String name;
 final  List<String> _labels;
@override@JsonKey() List<String> get labels {
  if (_labels is EqualUnmodifiableListView) return _labels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_labels);
}

 final  List<RecipeIngredient> _ingredients;
@override@JsonKey() List<RecipeIngredient> get ingredients {
  if (_ingredients is EqualUnmodifiableListView) return _ingredients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ingredients);
}

@override final  int? servings;
@override final  String? prepTime;
@override final  String? cookTime;
@override@JsonKey() final  String instructionsText;
@override@JsonKey() final  bool showInstructions;
@override@JsonKey() final  bool isFavorite;
@override@JsonKey() final  bool isSaving;
@override@JsonKey() final  bool isPickingPhoto;
@override final  String? photoError;
@override final  String? nameError;
@override final  String? saveError;
@override final  Recipe? savedRecipe;

/// Create a copy of CreateRecipeFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateRecipeFormStateCopyWith<_CreateRecipeFormState> get copyWith => __$CreateRecipeFormStateCopyWithImpl<_CreateRecipeFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateRecipeFormState&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.labels, _labels)&&const DeepCollectionEquality().equals(other.ingredients, _ingredients)&&(identical(other.servings, servings) || other.servings == servings)&&(identical(other.prepTime, prepTime) || other.prepTime == prepTime)&&(identical(other.cookTime, cookTime) || other.cookTime == cookTime)&&(identical(other.instructionsText, instructionsText) || other.instructionsText == instructionsText)&&(identical(other.showInstructions, showInstructions) || other.showInstructions == showInstructions)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.isPickingPhoto, isPickingPhoto) || other.isPickingPhoto == isPickingPhoto)&&(identical(other.photoError, photoError) || other.photoError == photoError)&&(identical(other.nameError, nameError) || other.nameError == nameError)&&(identical(other.saveError, saveError) || other.saveError == saveError)&&(identical(other.savedRecipe, savedRecipe) || other.savedRecipe == savedRecipe));
}


@override
int get hashCode {
    return Object.hash(runtimeType,photoPath,name,const DeepCollectionEquality().hash(_labels),const DeepCollectionEquality().hash(_ingredients),servings,prepTime,cookTime,instructionsText,showInstructions,isFavorite,isSaving,isPickingPhoto,photoError,nameError,saveError,savedRecipe);
}

@override
String toString() {
    return 'CreateRecipeFormState(photoPath: $photoPath, name: $name, labels: $labels, ingredients: $ingredients, servings: $servings, prepTime: $prepTime, cookTime: $cookTime, instructionsText: $instructionsText, showInstructions: $showInstructions, isFavorite: $isFavorite, isSaving: $isSaving, isPickingPhoto: $isPickingPhoto, photoError: $photoError, nameError: $nameError, saveError: $saveError, savedRecipe: $savedRecipe)';
}


}

/// @nodoc
abstract mixin class _$CreateRecipeFormStateCopyWith<$Res> implements $CreateRecipeFormStateCopyWith<$Res> {
  factory _$CreateRecipeFormStateCopyWith(_CreateRecipeFormState value, $Res Function(_CreateRecipeFormState) _then) = __$CreateRecipeFormStateCopyWithImpl;
@override @useResult
$Res call({
 String? photoPath, String name, List<String> labels, List<RecipeIngredient> ingredients, int? servings, String? prepTime, String? cookTime, String instructionsText, bool showInstructions, bool isFavorite, bool isSaving, bool isPickingPhoto, String? photoError, String? nameError, String? saveError, Recipe? savedRecipe
});


@override $RecipeCopyWith<$Res>? get savedRecipe;

}
/// @nodoc
class __$CreateRecipeFormStateCopyWithImpl<$Res>
    implements _$CreateRecipeFormStateCopyWith<$Res> {
  __$CreateRecipeFormStateCopyWithImpl(this._self, this._then);

  final _CreateRecipeFormState _self;
  final $Res Function(_CreateRecipeFormState) _then;

/// Create a copy of CreateRecipeFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? photoPath = freezed,Object? name = null,Object? labels = null,Object? ingredients = null,Object? servings = freezed,Object? prepTime = freezed,Object? cookTime = freezed,Object? instructionsText = null,Object? showInstructions = null,Object? isFavorite = null,Object? isSaving = null,Object? isPickingPhoto = null,Object? photoError = freezed,Object? nameError = freezed,Object? saveError = freezed,Object? savedRecipe = freezed,}) {
  return _then(_CreateRecipeFormState(
photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,labels: null == labels ? _self._labels : labels // ignore: cast_nullable_to_non_nullable
as List<String>,ingredients: null == ingredients ? _self._ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<RecipeIngredient>,servings: freezed == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as int?,prepTime: freezed == prepTime ? _self.prepTime : prepTime // ignore: cast_nullable_to_non_nullable
as String?,cookTime: freezed == cookTime ? _self.cookTime : cookTime // ignore: cast_nullable_to_non_nullable
as String?,instructionsText: null == instructionsText ? _self.instructionsText : instructionsText // ignore: cast_nullable_to_non_nullable
as String,showInstructions: null == showInstructions ? _self.showInstructions : showInstructions // ignore: cast_nullable_to_non_nullable
as bool,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,isPickingPhoto: null == isPickingPhoto ? _self.isPickingPhoto : isPickingPhoto // ignore: cast_nullable_to_non_nullable
as bool,photoError: freezed == photoError ? _self.photoError : photoError // ignore: cast_nullable_to_non_nullable
as String?,nameError: freezed == nameError ? _self.nameError : nameError // ignore: cast_nullable_to_non_nullable
as String?,saveError: freezed == saveError ? _self.saveError : saveError // ignore: cast_nullable_to_non_nullable
as String?,savedRecipe: freezed == savedRecipe ? _self.savedRecipe : savedRecipe // ignore: cast_nullable_to_non_nullable
as Recipe?,
  ));
}

/// Create a copy of CreateRecipeFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecipeCopyWith<$Res>? get savedRecipe {
    if (_self.savedRecipe == null) {
    return null;
  }

  return $RecipeCopyWith<$Res>(_self.savedRecipe!, (value) {
    return _then(_self.copyWith(savedRecipe: value));
  });
}
}

// dart format on
