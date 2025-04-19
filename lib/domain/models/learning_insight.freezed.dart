// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learning_insight.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LearningInsightDTO {

 InsightType get type; String get message; String get icon; String get color; double get dataPoint; int get priority;
/// Create a copy of LearningInsightDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LearningInsightDTOCopyWith<LearningInsightDTO> get copyWith => _$LearningInsightDTOCopyWithImpl<LearningInsightDTO>(this as LearningInsightDTO, _$identity);

  /// Serializes this LearningInsightDTO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LearningInsightDTO&&(identical(other.type, type) || other.type == type)&&(identical(other.message, message) || other.message == message)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.dataPoint, dataPoint) || other.dataPoint == dataPoint)&&(identical(other.priority, priority) || other.priority == priority));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,message,icon,color,dataPoint,priority);

@override
String toString() {
  return 'LearningInsightDTO(type: $type, message: $message, icon: $icon, color: $color, dataPoint: $dataPoint, priority: $priority)';
}


}

/// @nodoc
abstract mixin class $LearningInsightDTOCopyWith<$Res>  {
  factory $LearningInsightDTOCopyWith(LearningInsightDTO value, $Res Function(LearningInsightDTO) _then) = _$LearningInsightDTOCopyWithImpl;
@useResult
$Res call({
 InsightType type, String message, String icon, String color, double dataPoint, int priority
});




}
/// @nodoc
class _$LearningInsightDTOCopyWithImpl<$Res>
    implements $LearningInsightDTOCopyWith<$Res> {
  _$LearningInsightDTOCopyWithImpl(this._self, this._then);

  final LearningInsightDTO _self;
  final $Res Function(LearningInsightDTO) _then;

/// Create a copy of LearningInsightDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? message = null,Object? icon = null,Object? color = null,Object? dataPoint = null,Object? priority = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as InsightType,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,dataPoint: null == dataPoint ? _self.dataPoint : dataPoint // ignore: cast_nullable_to_non_nullable
as double,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _LearningInsightDTO implements LearningInsightDTO {
  const _LearningInsightDTO({required this.type, required this.message, required this.icon, required this.color, this.dataPoint = 0.0, this.priority = 0});
  factory _LearningInsightDTO.fromJson(Map<String, dynamic> json) => _$LearningInsightDTOFromJson(json);

@override final  InsightType type;
@override final  String message;
@override final  String icon;
@override final  String color;
@override@JsonKey() final  double dataPoint;
@override@JsonKey() final  int priority;

/// Create a copy of LearningInsightDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LearningInsightDTOCopyWith<_LearningInsightDTO> get copyWith => __$LearningInsightDTOCopyWithImpl<_LearningInsightDTO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LearningInsightDTOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LearningInsightDTO&&(identical(other.type, type) || other.type == type)&&(identical(other.message, message) || other.message == message)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.dataPoint, dataPoint) || other.dataPoint == dataPoint)&&(identical(other.priority, priority) || other.priority == priority));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,message,icon,color,dataPoint,priority);

@override
String toString() {
  return 'LearningInsightDTO(type: $type, message: $message, icon: $icon, color: $color, dataPoint: $dataPoint, priority: $priority)';
}


}

/// @nodoc
abstract mixin class _$LearningInsightDTOCopyWith<$Res> implements $LearningInsightDTOCopyWith<$Res> {
  factory _$LearningInsightDTOCopyWith(_LearningInsightDTO value, $Res Function(_LearningInsightDTO) _then) = __$LearningInsightDTOCopyWithImpl;
@override @useResult
$Res call({
 InsightType type, String message, String icon, String color, double dataPoint, int priority
});




}
/// @nodoc
class __$LearningInsightDTOCopyWithImpl<$Res>
    implements _$LearningInsightDTOCopyWith<$Res> {
  __$LearningInsightDTOCopyWithImpl(this._self, this._then);

  final _LearningInsightDTO _self;
  final $Res Function(_LearningInsightDTO) _then;

/// Create a copy of LearningInsightDTO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? message = null,Object? icon = null,Object? color = null,Object? dataPoint = null,Object? priority = null,}) {
  return _then(_LearningInsightDTO(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as InsightType,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,dataPoint: null == dataPoint ? _self.dataPoint : dataPoint // ignore: cast_nullable_to_non_nullable
as double,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
