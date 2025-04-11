
part of 'repetition.dart';


T _$identity<T>(T value) => value;

mixin _$Repetition {

 String get id; String get moduleProgressId; RepetitionOrder get repetitionOrder; RepetitionStatus get status; DateTime? get reviewDate; DateTime? get createdAt; DateTime? get updatedAt;
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RepetitionCopyWith<Repetition> get copyWith => _$RepetitionCopyWithImpl<Repetition>(this as Repetition, _$identity);

  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Repetition&&(identical(other.id, id) || other.id == id)&&(identical(other.moduleProgressId, moduleProgressId) || other.moduleProgressId == moduleProgressId)&&(identical(other.repetitionOrder, repetitionOrder) || other.repetitionOrder == repetitionOrder)&&(identical(other.status, status) || other.status == status)&&(identical(other.reviewDate, reviewDate) || other.reviewDate == reviewDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,moduleProgressId,repetitionOrder,status,reviewDate,createdAt,updatedAt);

@override
String toString() {
  return 'Repetition(id: $id, moduleProgressId: $moduleProgressId, repetitionOrder: $repetitionOrder, status: $status, reviewDate: $reviewDate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

abstract mixin class $RepetitionCopyWith<$Res>  {
  factory $RepetitionCopyWith(Repetition value, $Res Function(Repetition) _then) = _$RepetitionCopyWithImpl;
@useResult
$Res call({
 String id, String moduleProgressId, RepetitionOrder repetitionOrder, RepetitionStatus status, DateTime? reviewDate, DateTime? createdAt, DateTime? updatedAt
});




}
class _$RepetitionCopyWithImpl<$Res>
    implements $RepetitionCopyWith<$Res> {
  _$RepetitionCopyWithImpl(this._self, this._then);

  final Repetition _self;
  final $Res Function(Repetition) _then;

@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? moduleProgressId = null,Object? repetitionOrder = null,Object? status = null,Object? reviewDate = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,moduleProgressId: null == moduleProgressId ? _self.moduleProgressId : moduleProgressId // ignore: cast_nullable_to_non_nullable
as String,repetitionOrder: null == repetitionOrder ? _self.repetitionOrder : repetitionOrder // ignore: cast_nullable_to_non_nullable
as RepetitionOrder,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RepetitionStatus,reviewDate: freezed == reviewDate ? _self.reviewDate : reviewDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


@JsonSerializable()

class _Repetition implements Repetition {
  const _Repetition({required this.id, required this.moduleProgressId, required this.repetitionOrder, this.status = RepetitionStatus.notStarted, this.reviewDate, this.createdAt, this.updatedAt});
  factory _Repetition.fromJson(Map<String, dynamic> json) => _$RepetitionFromJson(json);

@override final  String id;
@override final  String moduleProgressId;
@override final  RepetitionOrder repetitionOrder;
@override@JsonKey() final  RepetitionStatus status;
@override final  DateTime? reviewDate;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RepetitionCopyWith<_Repetition> get copyWith => __$RepetitionCopyWithImpl<_Repetition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RepetitionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Repetition&&(identical(other.id, id) || other.id == id)&&(identical(other.moduleProgressId, moduleProgressId) || other.moduleProgressId == moduleProgressId)&&(identical(other.repetitionOrder, repetitionOrder) || other.repetitionOrder == repetitionOrder)&&(identical(other.status, status) || other.status == status)&&(identical(other.reviewDate, reviewDate) || other.reviewDate == reviewDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,moduleProgressId,repetitionOrder,status,reviewDate,createdAt,updatedAt);

@override
String toString() {
  return 'Repetition(id: $id, moduleProgressId: $moduleProgressId, repetitionOrder: $repetitionOrder, status: $status, reviewDate: $reviewDate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

abstract mixin class _$RepetitionCopyWith<$Res> implements $RepetitionCopyWith<$Res> {
  factory _$RepetitionCopyWith(_Repetition value, $Res Function(_Repetition) _then) = __$RepetitionCopyWithImpl;
@override @useResult
$Res call({
 String id, String moduleProgressId, RepetitionOrder repetitionOrder, RepetitionStatus status, DateTime? reviewDate, DateTime? createdAt, DateTime? updatedAt
});




}
class __$RepetitionCopyWithImpl<$Res>
    implements _$RepetitionCopyWith<$Res> {
  __$RepetitionCopyWithImpl(this._self, this._then);

  final _Repetition _self;
  final $Res Function(_Repetition) _then;

@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? moduleProgressId = null,Object? repetitionOrder = null,Object? status = null,Object? reviewDate = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Repetition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,moduleProgressId: null == moduleProgressId ? _self.moduleProgressId : moduleProgressId // ignore: cast_nullable_to_non_nullable
as String,repetitionOrder: null == repetitionOrder ? _self.repetitionOrder : repetitionOrder // ignore: cast_nullable_to_non_nullable
as RepetitionOrder,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RepetitionStatus,reviewDate: freezed == reviewDate ? _self.reviewDate : reviewDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

