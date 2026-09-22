// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_wizard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingWizardState {

 int get currentStep; String? get name; Sex? get sex; int? get age; double? get heightCm; double? get weightKg; ActivityLevel? get activityLevel; Goal? get goal; bool get manualCalorieMethod; double? get manualMaintenanceCalories; UserProfile? get result; bool get isSaving; String? get saveError;
/// Create a copy of OnboardingWizardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingWizardStateCopyWith<OnboardingWizardState> get copyWith => _$OnboardingWizardStateCopyWithImpl<OnboardingWizardState>(this as OnboardingWizardState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OnboardingWizardState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingWizardState&&(identical(other.currentStep, _this.currentStep) || other.currentStep == _this.currentStep)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.sex, _this.sex) || other.sex == _this.sex)&&(identical(other.age, _this.age) || other.age == _this.age)&&(identical(other.heightCm, _this.heightCm) || other.heightCm == _this.heightCm)&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg)&&(identical(other.activityLevel, _this.activityLevel) || other.activityLevel == _this.activityLevel)&&(identical(other.goal, _this.goal) || other.goal == _this.goal)&&(identical(other.manualCalorieMethod, _this.manualCalorieMethod) || other.manualCalorieMethod == _this.manualCalorieMethod)&&(identical(other.manualMaintenanceCalories, _this.manualMaintenanceCalories) || other.manualMaintenanceCalories == _this.manualMaintenanceCalories)&&(identical(other.result, _this.result) || other.result == _this.result)&&(identical(other.isSaving, _this.isSaving) || other.isSaving == _this.isSaving)&&(identical(other.saveError, _this.saveError) || other.saveError == _this.saveError));
}


@override
int get hashCode {
  final _this = this as OnboardingWizardState;
  return Object.hash(runtimeType,_this.currentStep,_this.name,_this.sex,_this.age,_this.heightCm,_this.weightKg,_this.activityLevel,_this.goal,_this.manualCalorieMethod,_this.manualMaintenanceCalories,_this.result,_this.isSaving,_this.saveError);
}

@override
String toString() {
  final _this = this as OnboardingWizardState;
  return 'OnboardingWizardState(currentStep: ${_this.currentStep}, name: ${_this.name}, sex: ${_this.sex}, age: ${_this.age}, heightCm: ${_this.heightCm}, weightKg: ${_this.weightKg}, activityLevel: ${_this.activityLevel}, goal: ${_this.goal}, manualCalorieMethod: ${_this.manualCalorieMethod}, manualMaintenanceCalories: ${_this.manualMaintenanceCalories}, result: ${_this.result}, isSaving: ${_this.isSaving}, saveError: ${_this.saveError})';
}


}

/// @nodoc
abstract mixin class $OnboardingWizardStateCopyWith<$Res>  {
  factory $OnboardingWizardStateCopyWith(OnboardingWizardState value, $Res Function(OnboardingWizardState) _then) = _$OnboardingWizardStateCopyWithImpl;
@useResult
$Res call({
 int currentStep, String? name, Sex? sex, int? age, double? heightCm, double? weightKg, ActivityLevel? activityLevel, Goal? goal, bool manualCalorieMethod, double? manualMaintenanceCalories, UserProfile? result, bool isSaving, String? saveError
});


$UserProfileCopyWith<$Res>? get result;

}
/// @nodoc
class _$OnboardingWizardStateCopyWithImpl<$Res>
    implements $OnboardingWizardStateCopyWith<$Res> {
  _$OnboardingWizardStateCopyWithImpl(this._self, this._then);

  final OnboardingWizardState _self;
  final $Res Function(OnboardingWizardState) _then;

/// Create a copy of OnboardingWizardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentStep = null,Object? name = freezed,Object? sex = freezed,Object? age = freezed,Object? heightCm = freezed,Object? weightKg = freezed,Object? activityLevel = freezed,Object? goal = freezed,Object? manualCalorieMethod = null,Object? manualMaintenanceCalories = freezed,Object? result = freezed,Object? isSaving = null,Object? saveError = freezed,}) {
  return _then(OnboardingWizardState(
currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as Sex?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as double?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,activityLevel: freezed == activityLevel ? _self.activityLevel : activityLevel // ignore: cast_nullable_to_non_nullable
as ActivityLevel?,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as Goal?,manualCalorieMethod: null == manualCalorieMethod ? _self.manualCalorieMethod : manualCalorieMethod // ignore: cast_nullable_to_non_nullable
as bool,manualMaintenanceCalories: freezed == manualMaintenanceCalories ? _self.manualMaintenanceCalories : manualMaintenanceCalories // ignore: cast_nullable_to_non_nullable
as double?,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as UserProfile?,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,saveError: freezed == saveError ? _self.saveError : saveError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of OnboardingWizardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileCopyWith<$Res>? get result {
    if (_self.result == null) {
    return null;
  }

  return $UserProfileCopyWith<$Res>(_self.result!, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}


/// Adds pattern-matching-related methods to [OnboardingWizardState].
extension OnboardingWizardStatePatterns on OnboardingWizardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingWizardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingWizardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingWizardState value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingWizardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingWizardState value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingWizardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentStep,  String? name,  Sex? sex,  int? age,  double? heightCm,  double? weightKg,  ActivityLevel? activityLevel,  Goal? goal,  bool manualCalorieMethod,  double? manualMaintenanceCalories,  UserProfile? result,  bool isSaving,  String? saveError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingWizardState() when $default != null:
return $default(_that.currentStep,_that.name,_that.sex,_that.age,_that.heightCm,_that.weightKg,_that.activityLevel,_that.goal,_that.manualCalorieMethod,_that.manualMaintenanceCalories,_that.result,_that.isSaving,_that.saveError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentStep,  String? name,  Sex? sex,  int? age,  double? heightCm,  double? weightKg,  ActivityLevel? activityLevel,  Goal? goal,  bool manualCalorieMethod,  double? manualMaintenanceCalories,  UserProfile? result,  bool isSaving,  String? saveError)  $default,) {final _that = this;
switch (_that) {
case _OnboardingWizardState():
return $default(_that.currentStep,_that.name,_that.sex,_that.age,_that.heightCm,_that.weightKg,_that.activityLevel,_that.goal,_that.manualCalorieMethod,_that.manualMaintenanceCalories,_that.result,_that.isSaving,_that.saveError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentStep,  String? name,  Sex? sex,  int? age,  double? heightCm,  double? weightKg,  ActivityLevel? activityLevel,  Goal? goal,  bool manualCalorieMethod,  double? manualMaintenanceCalories,  UserProfile? result,  bool isSaving,  String? saveError)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingWizardState() when $default != null:
return $default(_that.currentStep,_that.name,_that.sex,_that.age,_that.heightCm,_that.weightKg,_that.activityLevel,_that.goal,_that.manualCalorieMethod,_that.manualMaintenanceCalories,_that.result,_that.isSaving,_that.saveError);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingWizardState implements OnboardingWizardState {
  const _OnboardingWizardState({this.currentStep = 0, this.name, this.sex, this.age, this.heightCm, this.weightKg, this.activityLevel, this.goal, this.manualCalorieMethod = false, this.manualMaintenanceCalories, this.result, this.isSaving = false, this.saveError});
  

@override@JsonKey() final  int currentStep;
@override final  String? name;
@override final  Sex? sex;
@override final  int? age;
@override final  double? heightCm;
@override final  double? weightKg;
@override final  ActivityLevel? activityLevel;
@override final  Goal? goal;
@override@JsonKey() final  bool manualCalorieMethod;
@override final  double? manualMaintenanceCalories;
@override final  UserProfile? result;
@override@JsonKey() final  bool isSaving;
@override final  String? saveError;

/// Create a copy of OnboardingWizardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingWizardStateCopyWith<_OnboardingWizardState> get copyWith => __$OnboardingWizardStateCopyWithImpl<_OnboardingWizardState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingWizardState&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.name, name) || other.name == name)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.age, age) || other.age == age)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.activityLevel, activityLevel) || other.activityLevel == activityLevel)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.manualCalorieMethod, manualCalorieMethod) || other.manualCalorieMethod == manualCalorieMethod)&&(identical(other.manualMaintenanceCalories, manualMaintenanceCalories) || other.manualMaintenanceCalories == manualMaintenanceCalories)&&(identical(other.result, result) || other.result == result)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.saveError, saveError) || other.saveError == saveError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,currentStep,name,sex,age,heightCm,weightKg,activityLevel,goal,manualCalorieMethod,manualMaintenanceCalories,result,isSaving,saveError);
}

@override
String toString() {
    return 'OnboardingWizardState(currentStep: $currentStep, name: $name, sex: $sex, age: $age, heightCm: $heightCm, weightKg: $weightKg, activityLevel: $activityLevel, goal: $goal, manualCalorieMethod: $manualCalorieMethod, manualMaintenanceCalories: $manualMaintenanceCalories, result: $result, isSaving: $isSaving, saveError: $saveError)';
}


}

/// @nodoc
abstract mixin class _$OnboardingWizardStateCopyWith<$Res> implements $OnboardingWizardStateCopyWith<$Res> {
  factory _$OnboardingWizardStateCopyWith(_OnboardingWizardState value, $Res Function(_OnboardingWizardState) _then) = __$OnboardingWizardStateCopyWithImpl;
@override @useResult
$Res call({
 int currentStep, String? name, Sex? sex, int? age, double? heightCm, double? weightKg, ActivityLevel? activityLevel, Goal? goal, bool manualCalorieMethod, double? manualMaintenanceCalories, UserProfile? result, bool isSaving, String? saveError
});


@override $UserProfileCopyWith<$Res>? get result;

}
/// @nodoc
class __$OnboardingWizardStateCopyWithImpl<$Res>
    implements _$OnboardingWizardStateCopyWith<$Res> {
  __$OnboardingWizardStateCopyWithImpl(this._self, this._then);

  final _OnboardingWizardState _self;
  final $Res Function(_OnboardingWizardState) _then;

/// Create a copy of OnboardingWizardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentStep = null,Object? name = freezed,Object? sex = freezed,Object? age = freezed,Object? heightCm = freezed,Object? weightKg = freezed,Object? activityLevel = freezed,Object? goal = freezed,Object? manualCalorieMethod = null,Object? manualMaintenanceCalories = freezed,Object? result = freezed,Object? isSaving = null,Object? saveError = freezed,}) {
  return _then(_OnboardingWizardState(
currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as Sex?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as double?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,activityLevel: freezed == activityLevel ? _self.activityLevel : activityLevel // ignore: cast_nullable_to_non_nullable
as ActivityLevel?,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as Goal?,manualCalorieMethod: null == manualCalorieMethod ? _self.manualCalorieMethod : manualCalorieMethod // ignore: cast_nullable_to_non_nullable
as bool,manualMaintenanceCalories: freezed == manualMaintenanceCalories ? _self.manualMaintenanceCalories : manualMaintenanceCalories // ignore: cast_nullable_to_non_nullable
as double?,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as UserProfile?,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,saveError: freezed == saveError ? _self.saveError : saveError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of OnboardingWizardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileCopyWith<$Res>? get result {
    if (_self.result == null) {
    return null;
  }

  return $UserProfileCopyWith<$Res>(_self.result!, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}

// dart format on
