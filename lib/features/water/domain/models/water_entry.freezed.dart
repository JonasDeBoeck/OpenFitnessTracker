// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'water_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WaterEntry {

 int? get id; DateTime get loggedAt; double get milliliters;
/// Create a copy of WaterEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WaterEntryCopyWith<WaterEntry> get copyWith => _$WaterEntryCopyWithImpl<WaterEntry>(this as WaterEntry, _$identity);

  /// Serializes this WaterEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WaterEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WaterEntry&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.loggedAt, _this.loggedAt) || other.loggedAt == _this.loggedAt)&&(identical(other.milliliters, _this.milliliters) || other.milliliters == _this.milliliters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WaterEntry;
  return Object.hash(runtimeType,_this.id,_this.loggedAt,_this.milliliters);
}

@override
String toString() {
  final _this = this as WaterEntry;
  return 'WaterEntry(id: ${_this.id}, loggedAt: ${_this.loggedAt}, milliliters: ${_this.milliliters})';
}


}

/// @nodoc
abstract mixin class $WaterEntryCopyWith<$Res>  {
  factory $WaterEntryCopyWith(WaterEntry value, $Res Function(WaterEntry) _then) = _$WaterEntryCopyWithImpl;
@useResult
$Res call({
 int? id, DateTime loggedAt, double milliliters
});




}
/// @nodoc
class _$WaterEntryCopyWithImpl<$Res>
    implements $WaterEntryCopyWith<$Res> {
  _$WaterEntryCopyWithImpl(this._self, this._then);

  final WaterEntry _self;
  final $Res Function(WaterEntry) _then;

/// Create a copy of WaterEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? loggedAt = null,Object? milliliters = null,}) {
  return _then(WaterEntry(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,loggedAt: null == loggedAt ? _self.loggedAt : loggedAt // ignore: cast_nullable_to_non_nullable
as DateTime,milliliters: null == milliliters ? _self.milliliters : milliliters // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [WaterEntry].
extension WaterEntryPatterns on WaterEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WaterEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WaterEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WaterEntry value)  $default,){
final _that = this;
switch (_that) {
case _WaterEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WaterEntry value)?  $default,){
final _that = this;
switch (_that) {
case _WaterEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  DateTime loggedAt,  double milliliters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WaterEntry() when $default != null:
return $default(_that.id,_that.loggedAt,_that.milliliters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  DateTime loggedAt,  double milliliters)  $default,) {final _that = this;
switch (_that) {
case _WaterEntry():
return $default(_that.id,_that.loggedAt,_that.milliliters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  DateTime loggedAt,  double milliliters)?  $default,) {final _that = this;
switch (_that) {
case _WaterEntry() when $default != null:
return $default(_that.id,_that.loggedAt,_that.milliliters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WaterEntry implements WaterEntry {
  const _WaterEntry({this.id, required this.loggedAt, required this.milliliters});
  factory _WaterEntry.fromJson(Map<String, dynamic> json) => _$WaterEntryFromJson(json);

@override final  int? id;
@override final  DateTime loggedAt;
@override final  double milliliters;

/// Create a copy of WaterEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WaterEntryCopyWith<_WaterEntry> get copyWith => __$WaterEntryCopyWithImpl<_WaterEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WaterEntryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WaterEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.loggedAt, loggedAt) || other.loggedAt == loggedAt)&&(identical(other.milliliters, milliliters) || other.milliliters == milliliters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,loggedAt,milliliters);
}

@override
String toString() {
    return 'WaterEntry(id: $id, loggedAt: $loggedAt, milliliters: $milliliters)';
}


}

/// @nodoc
abstract mixin class _$WaterEntryCopyWith<$Res> implements $WaterEntryCopyWith<$Res> {
  factory _$WaterEntryCopyWith(_WaterEntry value, $Res Function(_WaterEntry) _then) = __$WaterEntryCopyWithImpl;
@override @useResult
$Res call({
 int? id, DateTime loggedAt, double milliliters
});




}
/// @nodoc
class __$WaterEntryCopyWithImpl<$Res>
    implements _$WaterEntryCopyWith<$Res> {
  __$WaterEntryCopyWithImpl(this._self, this._then);

  final _WaterEntry _self;
  final $Res Function(_WaterEntry) _then;

/// Create a copy of WaterEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? loggedAt = null,Object? milliliters = null,}) {
  return _then(_WaterEntry(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,loggedAt: null == loggedAt ? _self.loggedAt : loggedAt // ignore: cast_nullable_to_non_nullable
as DateTime,milliliters: null == milliliters ? _self.milliliters : milliliters // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
