
part of 'book.dart';


T _$identity<T>(T value) => value;

mixin _$BookSummary {

 String get id; String get name; BookStatus get status; DifficultyLevel? get difficultyLevel; String? get category; DateTime? get createdAt; DateTime? get updatedAt; int get moduleCount;
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookSummaryCopyWith<BookSummary> get copyWith => _$BookSummaryCopyWithImpl<BookSummary>(this as BookSummary, _$identity);

  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.difficultyLevel, difficultyLevel) || other.difficultyLevel == difficultyLevel)&&(identical(other.category, category) || other.category == category)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.moduleCount, moduleCount) || other.moduleCount == moduleCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,status,difficultyLevel,category,createdAt,updatedAt,moduleCount);

@override
String toString() {
  return 'BookSummary(id: $id, name: $name, status: $status, difficultyLevel: $difficultyLevel, category: $category, createdAt: $createdAt, updatedAt: $updatedAt, moduleCount: $moduleCount)';
}


}

abstract mixin class $BookSummaryCopyWith<$Res>  {
  factory $BookSummaryCopyWith(BookSummary value, $Res Function(BookSummary) _then) = _$BookSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String name, BookStatus status, DifficultyLevel? difficultyLevel, String? category, DateTime? createdAt, DateTime? updatedAt, int moduleCount
});




}
class _$BookSummaryCopyWithImpl<$Res>
    implements $BookSummaryCopyWith<$Res> {
  _$BookSummaryCopyWithImpl(this._self, this._then);

  final BookSummary _self;
  final $Res Function(BookSummary) _then;

@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? status = null,Object? difficultyLevel = freezed,Object? category = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? moduleCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookStatus,difficultyLevel: freezed == difficultyLevel ? _self.difficultyLevel : difficultyLevel // ignore: cast_nullable_to_non_nullable
as DifficultyLevel?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,moduleCount: null == moduleCount ? _self.moduleCount : moduleCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


@JsonSerializable()

class _BookSummary implements BookSummary {
  const _BookSummary({required this.id, required this.name, required this.status, this.difficultyLevel, this.category, this.createdAt, this.updatedAt, this.moduleCount = 0});
  factory _BookSummary.fromJson(Map<String, dynamic> json) => _$BookSummaryFromJson(json);

@override final  String id;
@override final  String name;
@override final  BookStatus status;
@override final  DifficultyLevel? difficultyLevel;
@override final  String? category;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override@JsonKey() final  int moduleCount;

@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookSummaryCopyWith<_BookSummary> get copyWith => __$BookSummaryCopyWithImpl<_BookSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.difficultyLevel, difficultyLevel) || other.difficultyLevel == difficultyLevel)&&(identical(other.category, category) || other.category == category)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.moduleCount, moduleCount) || other.moduleCount == moduleCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,status,difficultyLevel,category,createdAt,updatedAt,moduleCount);

@override
String toString() {
  return 'BookSummary(id: $id, name: $name, status: $status, difficultyLevel: $difficultyLevel, category: $category, createdAt: $createdAt, updatedAt: $updatedAt, moduleCount: $moduleCount)';
}


}

abstract mixin class _$BookSummaryCopyWith<$Res> implements $BookSummaryCopyWith<$Res> {
  factory _$BookSummaryCopyWith(_BookSummary value, $Res Function(_BookSummary) _then) = __$BookSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, BookStatus status, DifficultyLevel? difficultyLevel, String? category, DateTime? createdAt, DateTime? updatedAt, int moduleCount
});




}
class __$BookSummaryCopyWithImpl<$Res>
    implements _$BookSummaryCopyWith<$Res> {
  __$BookSummaryCopyWithImpl(this._self, this._then);

  final _BookSummary _self;
  final $Res Function(_BookSummary) _then;

@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? status = null,Object? difficultyLevel = freezed,Object? category = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? moduleCount = null,}) {
  return _then(_BookSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookStatus,difficultyLevel: freezed == difficultyLevel ? _self.difficultyLevel : difficultyLevel // ignore: cast_nullable_to_non_nullable
as DifficultyLevel?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,moduleCount: null == moduleCount ? _self.moduleCount : moduleCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


mixin _$BookDetail {

 String get id; String get name; String? get description; BookStatus get status; DifficultyLevel? get difficultyLevel; String? get category; DateTime? get createdAt; DateTime? get updatedAt; List<ModuleDetail> get modules;
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookDetailCopyWith<BookDetail> get copyWith => _$BookDetailCopyWithImpl<BookDetail>(this as BookDetail, _$identity);

  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.difficultyLevel, difficultyLevel) || other.difficultyLevel == difficultyLevel)&&(identical(other.category, category) || other.category == category)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.modules, modules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,status,difficultyLevel,category,createdAt,updatedAt,const DeepCollectionEquality().hash(modules));

@override
String toString() {
  return 'BookDetail(id: $id, name: $name, description: $description, status: $status, difficultyLevel: $difficultyLevel, category: $category, createdAt: $createdAt, updatedAt: $updatedAt, modules: $modules)';
}


}

abstract mixin class $BookDetailCopyWith<$Res>  {
  factory $BookDetailCopyWith(BookDetail value, $Res Function(BookDetail) _then) = _$BookDetailCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, BookStatus status, DifficultyLevel? difficultyLevel, String? category, DateTime? createdAt, DateTime? updatedAt, List<ModuleDetail> modules
});




}
class _$BookDetailCopyWithImpl<$Res>
    implements $BookDetailCopyWith<$Res> {
  _$BookDetailCopyWithImpl(this._self, this._then);

  final BookDetail _self;
  final $Res Function(BookDetail) _then;

@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? status = null,Object? difficultyLevel = freezed,Object? category = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? modules = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookStatus,difficultyLevel: freezed == difficultyLevel ? _self.difficultyLevel : difficultyLevel // ignore: cast_nullable_to_non_nullable
as DifficultyLevel?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,modules: null == modules ? _self.modules : modules // ignore: cast_nullable_to_non_nullable
as List<ModuleDetail>,
  ));
}

}


@JsonSerializable()

class _BookDetail implements BookDetail {
  const _BookDetail({required this.id, required this.name, this.description, required this.status, this.difficultyLevel, this.category, this.createdAt, this.updatedAt, final  List<ModuleDetail> modules = const []}): _modules = modules;
  factory _BookDetail.fromJson(Map<String, dynamic> json) => _$BookDetailFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
@override final  BookStatus status;
@override final  DifficultyLevel? difficultyLevel;
@override final  String? category;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
 final  List<ModuleDetail> _modules;
@override@JsonKey() List<ModuleDetail> get modules {
  if (_modules is EqualUnmodifiableListView) return _modules;
  return EqualUnmodifiableListView(_modules);
}


@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookDetailCopyWith<_BookDetail> get copyWith => __$BookDetailCopyWithImpl<_BookDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.difficultyLevel, difficultyLevel) || other.difficultyLevel == difficultyLevel)&&(identical(other.category, category) || other.category == category)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._modules, _modules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,status,difficultyLevel,category,createdAt,updatedAt,const DeepCollectionEquality().hash(_modules));

@override
String toString() {
  return 'BookDetail(id: $id, name: $name, description: $description, status: $status, difficultyLevel: $difficultyLevel, category: $category, createdAt: $createdAt, updatedAt: $updatedAt, modules: $modules)';
}


}

abstract mixin class _$BookDetailCopyWith<$Res> implements $BookDetailCopyWith<$Res> {
  factory _$BookDetailCopyWith(_BookDetail value, $Res Function(_BookDetail) _then) = __$BookDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, BookStatus status, DifficultyLevel? difficultyLevel, String? category, DateTime? createdAt, DateTime? updatedAt, List<ModuleDetail> modules
});




}
class __$BookDetailCopyWithImpl<$Res>
    implements _$BookDetailCopyWith<$Res> {
  __$BookDetailCopyWithImpl(this._self, this._then);

  final _BookDetail _self;
  final $Res Function(_BookDetail) _then;

@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? status = null,Object? difficultyLevel = freezed,Object? category = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? modules = null,}) {
  return _then(_BookDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookStatus,difficultyLevel: freezed == difficultyLevel ? _self.difficultyLevel : difficultyLevel // ignore: cast_nullable_to_non_nullable
as DifficultyLevel?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,modules: null == modules ? _self._modules : modules // ignore: cast_nullable_to_non_nullable
as List<ModuleDetail>,
  ));
}


}

