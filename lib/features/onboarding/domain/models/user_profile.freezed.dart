// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfile {

 int? get id; String get name; Sex get sex; int get age; double get heightCm; double get weightKg; ActivityLevel get activityLevel; Goal get goal; double get bmr; double get tdee; double get targetCalories; double get proteinGrams; double get fatGrams; double get carbGrams; double get waterTargetMl; DateTime? get createdAt;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.sex, _this.sex) || other.sex == _this.sex)&&(identical(other.age, _this.age) || other.age == _this.age)&&(identical(other.heightCm, _this.heightCm) || other.heightCm == _this.heightCm)&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg)&&(identical(other.activityLevel, _this.activityLevel) || other.activityLevel == _this.activityLevel)&&(identical(other.goal, _this.goal) || other.goal == _this.goal)&&(identical(other.bmr, _this.bmr) || other.bmr == _this.bmr)&&(identical(other.tdee, _this.tdee) || other.tdee == _this.tdee)&&(identical(other.targetCalories, _this.targetCalories) || other.targetCalories == _this.targetCalories)&&(identical(other.proteinGrams, _this.proteinGrams) || other.proteinGrams == _this.proteinGrams)&&(identical(other.fatGrams, _this.fatGrams) || other.fatGrams == _this.fatGrams)&&(identical(other.carbGrams, _this.carbGrams) || other.carbGrams == _this.carbGrams)&&(identical(other.waterTargetMl, _this.waterTargetMl) || other.waterTargetMl == _this.waterTargetMl)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserProfile;
  return Object.hash(runtimeType,_this.id,_this.name,_this.sex,_this.age,_this.heightCm,_this.weightKg,_this.activityLevel,_this.goal,_this.bmr,_this.tdee,_this.targetCalories,_this.proteinGrams,_this.fatGrams,_this.carbGrams,_this.waterTargetMl,_this.createdAt);
}

@override
String toString() {
  final _this = this as UserProfile;
  return 'UserProfile(id: ${_this.id}, name: ${_this.name}, sex: ${_this.sex}, age: ${_this.age}, heightCm: ${_this.heightCm}, weightKg: ${_this.weightKg}, activityLevel: ${_this.activityLevel}, goal: ${_this.goal}, bmr: ${_this.bmr}, tdee: ${_this.tdee}, targetCalories: ${_this.targetCalories}, proteinGrams: ${_this.proteinGrams}, fatGrams: ${_this.fatGrams}, carbGrams: ${_this.carbGrams}, waterTargetMl: ${_this.waterTargetMl}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 int? id, String name, Sex sex, int age, double heightCm, double weightKg, ActivityLevel activityLevel, Goal goal, double bmr, double tdee, double targetCalories, double proteinGrams, double fatGrams, double carbGrams, double waterTargetMl, DateTime? createdAt
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? sex = null,Object? age = null,Object? heightCm = null,Object? weightKg = null,Object? activityLevel = null,Object? goal = null,Object? bmr = null,Object? tdee = null,Object? targetCalories = null,Object? proteinGrams = null,Object? fatGrams = null,Object? carbGrams = null,Object? waterTargetMl = null,Object? createdAt = freezed,}) {
  return _then(UserProfile(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sex: null == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as Sex,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,heightCm: null == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as double,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,activityLevel: null == activityLevel ? _self.activityLevel : activityLevel // ignore: cast_nullable_to_non_nullable
as ActivityLevel,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as Goal,bmr: null == bmr ? _self.bmr : bmr // ignore: cast_nullable_to_non_nullable
as double,tdee: null == tdee ? _self.tdee : tdee // ignore: cast_nullable_to_non_nullable
as double,targetCalories: null == targetCalories ? _self.targetCalories : targetCalories // ignore: cast_nullable_to_non_nullable
as double,proteinGrams: null == proteinGrams ? _self.proteinGrams : proteinGrams // ignore: cast_nullable_to_non_nullable
as double,fatGrams: null == fatGrams ? _self.fatGrams : fatGrams // ignore: cast_nullable_to_non_nullable
as double,carbGrams: null == carbGrams ? _self.carbGrams : carbGrams // ignore: cast_nullable_to_non_nullable
as double,waterTargetMl: null == waterTargetMl ? _self.waterTargetMl : waterTargetMl // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String name,  Sex sex,  int age,  double heightCm,  double weightKg,  ActivityLevel activityLevel,  Goal goal,  double bmr,  double tdee,  double targetCalories,  double proteinGrams,  double fatGrams,  double carbGrams,  double waterTargetMl,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.name,_that.sex,_that.age,_that.heightCm,_that.weightKg,_that.activityLevel,_that.goal,_that.bmr,_that.tdee,_that.targetCalories,_that.proteinGrams,_that.fatGrams,_that.carbGrams,_that.waterTargetMl,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String name,  Sex sex,  int age,  double heightCm,  double weightKg,  ActivityLevel activityLevel,  Goal goal,  double bmr,  double tdee,  double targetCalories,  double proteinGrams,  double fatGrams,  double carbGrams,  double waterTargetMl,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.id,_that.name,_that.sex,_that.age,_that.heightCm,_that.weightKg,_that.activityLevel,_that.goal,_that.bmr,_that.tdee,_that.targetCalories,_that.proteinGrams,_that.fatGrams,_that.carbGrams,_that.waterTargetMl,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String name,  Sex sex,  int age,  double heightCm,  double weightKg,  ActivityLevel activityLevel,  Goal goal,  double bmr,  double tdee,  double targetCalories,  double proteinGrams,  double fatGrams,  double carbGrams,  double waterTargetMl,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.name,_that.sex,_that.age,_that.heightCm,_that.weightKg,_that.activityLevel,_that.goal,_that.bmr,_that.tdee,_that.targetCalories,_that.proteinGrams,_that.fatGrams,_that.carbGrams,_that.waterTargetMl,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfile implements UserProfile {
  const _UserProfile({this.id, required this.name, required this.sex, required this.age, required this.heightCm, required this.weightKg, required this.activityLevel, required this.goal, required this.bmr, required this.tdee, required this.targetCalories, required this.proteinGrams, required this.fatGrams, required this.carbGrams, required this.waterTargetMl, this.createdAt});
  factory _UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

@override final  int? id;
@override final  String name;
@override final  Sex sex;
@override final  int age;
@override final  double heightCm;
@override final  double weightKg;
@override final  ActivityLevel activityLevel;
@override final  Goal goal;
@override final  double bmr;
@override final  double tdee;
@override final  double targetCalories;
@override final  double proteinGrams;
@override final  double fatGrams;
@override final  double carbGrams;
@override final  double waterTargetMl;
@override final  DateTime? createdAt;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.age, age) || other.age == age)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.activityLevel, activityLevel) || other.activityLevel == activityLevel)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.bmr, bmr) || other.bmr == bmr)&&(identical(other.tdee, tdee) || other.tdee == tdee)&&(identical(other.targetCalories, targetCalories) || other.targetCalories == targetCalories)&&(identical(other.proteinGrams, proteinGrams) || other.proteinGrams == proteinGrams)&&(identical(other.fatGrams, fatGrams) || other.fatGrams == fatGrams)&&(identical(other.carbGrams, carbGrams) || other.carbGrams == carbGrams)&&(identical(other.waterTargetMl, waterTargetMl) || other.waterTargetMl == waterTargetMl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,sex,age,heightCm,weightKg,activityLevel,goal,bmr,tdee,targetCalories,proteinGrams,fatGrams,carbGrams,waterTargetMl,createdAt);
}

@override
String toString() {
    return 'UserProfile(id: $id, name: $name, sex: $sex, age: $age, heightCm: $heightCm, weightKg: $weightKg, activityLevel: $activityLevel, goal: $goal, bmr: $bmr, tdee: $tdee, targetCalories: $targetCalories, proteinGrams: $proteinGrams, fatGrams: $fatGrams, carbGrams: $carbGrams, waterTargetMl: $waterTargetMl, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 int? id, String name, Sex sex, int age, double heightCm, double weightKg, ActivityLevel activityLevel, Goal goal, double bmr, double tdee, double targetCalories, double proteinGrams, double fatGrams, double carbGrams, double waterTargetMl, DateTime? createdAt
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? sex = null,Object? age = null,Object? heightCm = null,Object? weightKg = null,Object? activityLevel = null,Object? goal = null,Object? bmr = null,Object? tdee = null,Object? targetCalories = null,Object? proteinGrams = null,Object? fatGrams = null,Object? carbGrams = null,Object? waterTargetMl = null,Object? createdAt = freezed,}) {
  return _then(_UserProfile(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sex: null == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as Sex,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,heightCm: null == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as double,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,activityLevel: null == activityLevel ? _self.activityLevel : activityLevel // ignore: cast_nullable_to_non_nullable
as ActivityLevel,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as Goal,bmr: null == bmr ? _self.bmr : bmr // ignore: cast_nullable_to_non_nullable
as double,tdee: null == tdee ? _self.tdee : tdee // ignore: cast_nullable_to_non_nullable
as double,targetCalories: null == targetCalories ? _self.targetCalories : targetCalories // ignore: cast_nullable_to_non_nullable
as double,proteinGrams: null == proteinGrams ? _self.proteinGrams : proteinGrams // ignore: cast_nullable_to_non_nullable
as double,fatGrams: null == fatGrams ? _self.fatGrams : fatGrams // ignore: cast_nullable_to_non_nullable
as double,carbGrams: null == carbGrams ? _self.carbGrams : carbGrams // ignore: cast_nullable_to_non_nullable
as double,waterTargetMl: null == waterTargetMl ? _self.waterTargetMl : waterTargetMl // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
