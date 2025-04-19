// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vocabulary_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VocabularyStats {

 int get totalWords; int get learnedWords; int get pendingWords; double get vocabularyCompletionRate; double get weeklyNewWordsRate;
/// Create a copy of VocabularyStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VocabularyStatsCopyWith<VocabularyStats> get copyWith => _$VocabularyStatsCopyWithImpl<VocabularyStats>(this as VocabularyStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VocabularyStats&&(identical(other.totalWords, totalWords) || other.totalWords == totalWords)&&(identical(other.learnedWords, learnedWords) || other.learnedWords == learnedWords)&&(identical(other.pendingWords, pendingWords) || other.pendingWords == pendingWords)&&(identical(other.vocabularyCompletionRate, vocabularyCompletionRate) || other.vocabularyCompletionRate == vocabularyCompletionRate)&&(identical(other.weeklyNewWordsRate, weeklyNewWordsRate) || other.weeklyNewWordsRate == weeklyNewWordsRate));
}


@override
int get hashCode => Object.hash(runtimeType,totalWords,learnedWords,pendingWords,vocabularyCompletionRate,weeklyNewWordsRate);

@override
String toString() {
  return 'VocabularyStats(totalWords: $totalWords, learnedWords: $learnedWords, pendingWords: $pendingWords, vocabularyCompletionRate: $vocabularyCompletionRate, weeklyNewWordsRate: $weeklyNewWordsRate)';
}


}

/// @nodoc
abstract mixin class $VocabularyStatsCopyWith<$Res>  {
  factory $VocabularyStatsCopyWith(VocabularyStats value, $Res Function(VocabularyStats) _then) = _$VocabularyStatsCopyWithImpl;
@useResult
$Res call({
 int totalWords, int learnedWords, int pendingWords, double vocabularyCompletionRate, double weeklyNewWordsRate
});




}
/// @nodoc
class _$VocabularyStatsCopyWithImpl<$Res>
    implements $VocabularyStatsCopyWith<$Res> {
  _$VocabularyStatsCopyWithImpl(this._self, this._then);

  final VocabularyStats _self;
  final $Res Function(VocabularyStats) _then;

/// Create a copy of VocabularyStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalWords = null,Object? learnedWords = null,Object? pendingWords = null,Object? vocabularyCompletionRate = null,Object? weeklyNewWordsRate = null,}) {
  return _then(_self.copyWith(
totalWords: null == totalWords ? _self.totalWords : totalWords // ignore: cast_nullable_to_non_nullable
as int,learnedWords: null == learnedWords ? _self.learnedWords : learnedWords // ignore: cast_nullable_to_non_nullable
as int,pendingWords: null == pendingWords ? _self.pendingWords : pendingWords // ignore: cast_nullable_to_non_nullable
as int,vocabularyCompletionRate: null == vocabularyCompletionRate ? _self.vocabularyCompletionRate : vocabularyCompletionRate // ignore: cast_nullable_to_non_nullable
as double,weeklyNewWordsRate: null == weeklyNewWordsRate ? _self.weeklyNewWordsRate : weeklyNewWordsRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// @nodoc


class _VocabularyStats implements VocabularyStats {
  const _VocabularyStats({required this.totalWords, required this.learnedWords, required this.pendingWords, required this.vocabularyCompletionRate, required this.weeklyNewWordsRate});
  

@override final  int totalWords;
@override final  int learnedWords;
@override final  int pendingWords;
@override final  double vocabularyCompletionRate;
@override final  double weeklyNewWordsRate;

/// Create a copy of VocabularyStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VocabularyStatsCopyWith<_VocabularyStats> get copyWith => __$VocabularyStatsCopyWithImpl<_VocabularyStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VocabularyStats&&(identical(other.totalWords, totalWords) || other.totalWords == totalWords)&&(identical(other.learnedWords, learnedWords) || other.learnedWords == learnedWords)&&(identical(other.pendingWords, pendingWords) || other.pendingWords == pendingWords)&&(identical(other.vocabularyCompletionRate, vocabularyCompletionRate) || other.vocabularyCompletionRate == vocabularyCompletionRate)&&(identical(other.weeklyNewWordsRate, weeklyNewWordsRate) || other.weeklyNewWordsRate == weeklyNewWordsRate));
}


@override
int get hashCode => Object.hash(runtimeType,totalWords,learnedWords,pendingWords,vocabularyCompletionRate,weeklyNewWordsRate);

@override
String toString() {
  return 'VocabularyStats(totalWords: $totalWords, learnedWords: $learnedWords, pendingWords: $pendingWords, vocabularyCompletionRate: $vocabularyCompletionRate, weeklyNewWordsRate: $weeklyNewWordsRate)';
}


}

/// @nodoc
abstract mixin class _$VocabularyStatsCopyWith<$Res> implements $VocabularyStatsCopyWith<$Res> {
  factory _$VocabularyStatsCopyWith(_VocabularyStats value, $Res Function(_VocabularyStats) _then) = __$VocabularyStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalWords, int learnedWords, int pendingWords, double vocabularyCompletionRate, double weeklyNewWordsRate
});




}
/// @nodoc
class __$VocabularyStatsCopyWithImpl<$Res>
    implements _$VocabularyStatsCopyWith<$Res> {
  __$VocabularyStatsCopyWithImpl(this._self, this._then);

  final _VocabularyStats _self;
  final $Res Function(_VocabularyStats) _then;

/// Create a copy of VocabularyStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalWords = null,Object? learnedWords = null,Object? pendingWords = null,Object? vocabularyCompletionRate = null,Object? weeklyNewWordsRate = null,}) {
  return _then(_VocabularyStats(
totalWords: null == totalWords ? _self.totalWords : totalWords // ignore: cast_nullable_to_non_nullable
as int,learnedWords: null == learnedWords ? _self.learnedWords : learnedWords // ignore: cast_nullable_to_non_nullable
as int,pendingWords: null == pendingWords ? _self.pendingWords : pendingWords // ignore: cast_nullable_to_non_nullable
as int,vocabularyCompletionRate: null == vocabularyCompletionRate ? _self.vocabularyCompletionRate : vocabularyCompletionRate // ignore: cast_nullable_to_non_nullable
as double,weeklyNewWordsRate: null == weeklyNewWordsRate ? _self.weeklyNewWordsRate : weeklyNewWordsRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
