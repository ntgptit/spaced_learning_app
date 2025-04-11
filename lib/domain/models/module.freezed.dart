
part of 'module.dart';


T _$identity<T>(T value) => value;

mixin _$ModuleSummary {

 String get id; String get bookId; int get moduleNo; String get title; int? get wordCount; DateTime? get createdAt; DateTime? get updatedAt;
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModuleSummaryCopyWith<ModuleSummary> get copyWith => _$ModuleSummaryCopyWithImpl<ModuleSummary>(this as ModuleSummary, _$identity);

  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModuleSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.moduleNo, moduleNo) || other.moduleNo == moduleNo)&&(identical(other.title, title) || other.title == title)&&(identical(other.wordCount, wordCount) || other.wordCount == wordCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookId,moduleNo,title,wordCount,createdAt,updatedAt);

@override
String toString() {
  return 'ModuleSummary(id: $id, bookId: $bookId, moduleNo: $moduleNo, title: $title, wordCount: $wordCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

abstract mixin class $ModuleSummaryCopyWith<$Res>  {
  factory $ModuleSummaryCopyWith(ModuleSummary value, $Res Function(ModuleSummary) _then) = _$ModuleSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String bookId, int moduleNo, String title, int? wordCount, DateTime? createdAt, DateTime? updatedAt
});




}
class _$ModuleSummaryCopyWithImpl<$Res>
    implements $ModuleSummaryCopyWith<$Res> {
  _$ModuleSummaryCopyWithImpl(this._self, this._then);

  final ModuleSummary _self;
  final $Res Function(ModuleSummary) _then;

@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bookId = null,Object? moduleNo = null,Object? title = null,Object? wordCount = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,moduleNo: null == moduleNo ? _self.moduleNo : moduleNo // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,wordCount: freezed == wordCount ? _self.wordCount : wordCount // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


@JsonSerializable()

class _ModuleSummary implements ModuleSummary {
  const _ModuleSummary({required this.id, required this.bookId, required this.moduleNo, required this.title, this.wordCount, this.createdAt, this.updatedAt});
  factory _ModuleSummary.fromJson(Map<String, dynamic> json) => _$ModuleSummaryFromJson(json);

@override final  String id;
@override final  String bookId;
@override final  int moduleNo;
@override final  String title;
@override final  int? wordCount;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModuleSummaryCopyWith<_ModuleSummary> get copyWith => __$ModuleSummaryCopyWithImpl<_ModuleSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ModuleSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModuleSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.moduleNo, moduleNo) || other.moduleNo == moduleNo)&&(identical(other.title, title) || other.title == title)&&(identical(other.wordCount, wordCount) || other.wordCount == wordCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookId,moduleNo,title,wordCount,createdAt,updatedAt);

@override
String toString() {
  return 'ModuleSummary(id: $id, bookId: $bookId, moduleNo: $moduleNo, title: $title, wordCount: $wordCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

abstract mixin class _$ModuleSummaryCopyWith<$Res> implements $ModuleSummaryCopyWith<$Res> {
  factory _$ModuleSummaryCopyWith(_ModuleSummary value, $Res Function(_ModuleSummary) _then) = __$ModuleSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String bookId, int moduleNo, String title, int? wordCount, DateTime? createdAt, DateTime? updatedAt
});




}
class __$ModuleSummaryCopyWithImpl<$Res>
    implements _$ModuleSummaryCopyWith<$Res> {
  __$ModuleSummaryCopyWithImpl(this._self, this._then);

  final _ModuleSummary _self;
  final $Res Function(_ModuleSummary) _then;

@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bookId = null,Object? moduleNo = null,Object? title = null,Object? wordCount = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_ModuleSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,moduleNo: null == moduleNo ? _self.moduleNo : moduleNo // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,wordCount: freezed == wordCount ? _self.wordCount : wordCount // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


mixin _$ModuleDetail {

 String get id; String get bookId; String? get bookName; int get moduleNo; String get title; int? get wordCount; DateTime? get createdAt; DateTime? get updatedAt; List<ProgressSummary> get progress;
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModuleDetailCopyWith<ModuleDetail> get copyWith => _$ModuleDetailCopyWithImpl<ModuleDetail>(this as ModuleDetail, _$identity);

  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModuleDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.bookName, bookName) || other.bookName == bookName)&&(identical(other.moduleNo, moduleNo) || other.moduleNo == moduleNo)&&(identical(other.title, title) || other.title == title)&&(identical(other.wordCount, wordCount) || other.wordCount == wordCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.progress, progress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookId,bookName,moduleNo,title,wordCount,createdAt,updatedAt,const DeepCollectionEquality().hash(progress));

@override
String toString() {
  return 'ModuleDetail(id: $id, bookId: $bookId, bookName: $bookName, moduleNo: $moduleNo, title: $title, wordCount: $wordCount, createdAt: $createdAt, updatedAt: $updatedAt, progress: $progress)';
}


}

abstract mixin class $ModuleDetailCopyWith<$Res>  {
  factory $ModuleDetailCopyWith(ModuleDetail value, $Res Function(ModuleDetail) _then) = _$ModuleDetailCopyWithImpl;
@useResult
$Res call({
 String id, String bookId, String? bookName, int moduleNo, String title, int? wordCount, DateTime? createdAt, DateTime? updatedAt, List<ProgressSummary> progress
});




}
class _$ModuleDetailCopyWithImpl<$Res>
    implements $ModuleDetailCopyWith<$Res> {
  _$ModuleDetailCopyWithImpl(this._self, this._then);

  final ModuleDetail _self;
  final $Res Function(ModuleDetail) _then;

@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bookId = null,Object? bookName = freezed,Object? moduleNo = null,Object? title = null,Object? wordCount = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? progress = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,bookName: freezed == bookName ? _self.bookName : bookName // ignore: cast_nullable_to_non_nullable
as String?,moduleNo: null == moduleNo ? _self.moduleNo : moduleNo // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,wordCount: freezed == wordCount ? _self.wordCount : wordCount // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as List<ProgressSummary>,
  ));
}

}


@JsonSerializable()

class _ModuleDetail implements ModuleDetail {
  const _ModuleDetail({required this.id, required this.bookId, this.bookName, required this.moduleNo, required this.title, this.wordCount, this.createdAt, this.updatedAt, final  List<ProgressSummary> progress = const []}): _progress = progress;
  factory _ModuleDetail.fromJson(Map<String, dynamic> json) => _$ModuleDetailFromJson(json);

@override final  String id;
@override final  String bookId;
@override final  String? bookName;
@override final  int moduleNo;
@override final  String title;
@override final  int? wordCount;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
 final  List<ProgressSummary> _progress;
@override@JsonKey() List<ProgressSummary> get progress {
  if (_progress is EqualUnmodifiableListView) return _progress;
  return EqualUnmodifiableListView(_progress);
}


@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModuleDetailCopyWith<_ModuleDetail> get copyWith => __$ModuleDetailCopyWithImpl<_ModuleDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ModuleDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModuleDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.bookName, bookName) || other.bookName == bookName)&&(identical(other.moduleNo, moduleNo) || other.moduleNo == moduleNo)&&(identical(other.title, title) || other.title == title)&&(identical(other.wordCount, wordCount) || other.wordCount == wordCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._progress, _progress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookId,bookName,moduleNo,title,wordCount,createdAt,updatedAt,const DeepCollectionEquality().hash(_progress));

@override
String toString() {
  return 'ModuleDetail(id: $id, bookId: $bookId, bookName: $bookName, moduleNo: $moduleNo, title: $title, wordCount: $wordCount, createdAt: $createdAt, updatedAt: $updatedAt, progress: $progress)';
}


}

abstract mixin class _$ModuleDetailCopyWith<$Res> implements $ModuleDetailCopyWith<$Res> {
  factory _$ModuleDetailCopyWith(_ModuleDetail value, $Res Function(_ModuleDetail) _then) = __$ModuleDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String bookId, String? bookName, int moduleNo, String title, int? wordCount, DateTime? createdAt, DateTime? updatedAt, List<ProgressSummary> progress
});




}
class __$ModuleDetailCopyWithImpl<$Res>
    implements _$ModuleDetailCopyWith<$Res> {
  __$ModuleDetailCopyWithImpl(this._self, this._then);

  final _ModuleDetail _self;
  final $Res Function(_ModuleDetail) _then;

@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bookId = null,Object? bookName = freezed,Object? moduleNo = null,Object? title = null,Object? wordCount = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? progress = null,}) {
  return _then(_ModuleDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,bookName: freezed == bookName ? _self.bookName : bookName // ignore: cast_nullable_to_non_nullable
as String?,moduleNo: null == moduleNo ? _self.moduleNo : moduleNo // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,wordCount: freezed == wordCount ? _self.wordCount : wordCount // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,progress: null == progress ? _self._progress : progress // ignore: cast_nullable_to_non_nullable
as List<ProgressSummary>,
  ));
}


}

