// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learning_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LearningStatsDTO {

 int get totalModules; Map<String, int> get cycleStats; int get dueToday; int get dueThisWeek; int get dueThisMonth; int get wordsDueToday; int get wordsDueThisWeek; int get wordsDueThisMonth; int get completedToday; int get completedThisWeek; int get completedThisMonth; int get wordsCompletedToday; int get wordsCompletedThisWeek; int get wordsCompletedThisMonth; int get streakDays; int get streakWeeks; int get longestStreakDays; int get totalWords; int get totalCompletedModules; int get totalInProgressModules; int get learnedWords; int get pendingWords; double get vocabularyCompletionRate; double get weeklyNewWordsRate; List<LearningInsightRespone> get learningInsights; DateTime? get lastUpdated;
/// Create a copy of LearningStatsDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LearningStatsDTOCopyWith<LearningStatsDTO> get copyWith => _$LearningStatsDTOCopyWithImpl<LearningStatsDTO>(this as LearningStatsDTO, _$identity);

  /// Serializes this LearningStatsDTO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LearningStatsDTO&&(identical(other.totalModules, totalModules) || other.totalModules == totalModules)&&const DeepCollectionEquality().equals(other.cycleStats, cycleStats)&&(identical(other.dueToday, dueToday) || other.dueToday == dueToday)&&(identical(other.dueThisWeek, dueThisWeek) || other.dueThisWeek == dueThisWeek)&&(identical(other.dueThisMonth, dueThisMonth) || other.dueThisMonth == dueThisMonth)&&(identical(other.wordsDueToday, wordsDueToday) || other.wordsDueToday == wordsDueToday)&&(identical(other.wordsDueThisWeek, wordsDueThisWeek) || other.wordsDueThisWeek == wordsDueThisWeek)&&(identical(other.wordsDueThisMonth, wordsDueThisMonth) || other.wordsDueThisMonth == wordsDueThisMonth)&&(identical(other.completedToday, completedToday) || other.completedToday == completedToday)&&(identical(other.completedThisWeek, completedThisWeek) || other.completedThisWeek == completedThisWeek)&&(identical(other.completedThisMonth, completedThisMonth) || other.completedThisMonth == completedThisMonth)&&(identical(other.wordsCompletedToday, wordsCompletedToday) || other.wordsCompletedToday == wordsCompletedToday)&&(identical(other.wordsCompletedThisWeek, wordsCompletedThisWeek) || other.wordsCompletedThisWeek == wordsCompletedThisWeek)&&(identical(other.wordsCompletedThisMonth, wordsCompletedThisMonth) || other.wordsCompletedThisMonth == wordsCompletedThisMonth)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.streakWeeks, streakWeeks) || other.streakWeeks == streakWeeks)&&(identical(other.longestStreakDays, longestStreakDays) || other.longestStreakDays == longestStreakDays)&&(identical(other.totalWords, totalWords) || other.totalWords == totalWords)&&(identical(other.totalCompletedModules, totalCompletedModules) || other.totalCompletedModules == totalCompletedModules)&&(identical(other.totalInProgressModules, totalInProgressModules) || other.totalInProgressModules == totalInProgressModules)&&(identical(other.learnedWords, learnedWords) || other.learnedWords == learnedWords)&&(identical(other.pendingWords, pendingWords) || other.pendingWords == pendingWords)&&(identical(other.vocabularyCompletionRate, vocabularyCompletionRate) || other.vocabularyCompletionRate == vocabularyCompletionRate)&&(identical(other.weeklyNewWordsRate, weeklyNewWordsRate) || other.weeklyNewWordsRate == weeklyNewWordsRate)&&const DeepCollectionEquality().equals(other.learningInsights, learningInsights)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,totalModules,const DeepCollectionEquality().hash(cycleStats),dueToday,dueThisWeek,dueThisMonth,wordsDueToday,wordsDueThisWeek,wordsDueThisMonth,completedToday,completedThisWeek,completedThisMonth,wordsCompletedToday,wordsCompletedThisWeek,wordsCompletedThisMonth,streakDays,streakWeeks,longestStreakDays,totalWords,totalCompletedModules,totalInProgressModules,learnedWords,pendingWords,vocabularyCompletionRate,weeklyNewWordsRate,const DeepCollectionEquality().hash(learningInsights),lastUpdated]);

@override
String toString() {
  return 'LearningStatsDTO(totalModules: $totalModules, cycleStats: $cycleStats, dueToday: $dueToday, dueThisWeek: $dueThisWeek, dueThisMonth: $dueThisMonth, wordsDueToday: $wordsDueToday, wordsDueThisWeek: $wordsDueThisWeek, wordsDueThisMonth: $wordsDueThisMonth, completedToday: $completedToday, completedThisWeek: $completedThisWeek, completedThisMonth: $completedThisMonth, wordsCompletedToday: $wordsCompletedToday, wordsCompletedThisWeek: $wordsCompletedThisWeek, wordsCompletedThisMonth: $wordsCompletedThisMonth, streakDays: $streakDays, streakWeeks: $streakWeeks, longestStreakDays: $longestStreakDays, totalWords: $totalWords, totalCompletedModules: $totalCompletedModules, totalInProgressModules: $totalInProgressModules, learnedWords: $learnedWords, pendingWords: $pendingWords, vocabularyCompletionRate: $vocabularyCompletionRate, weeklyNewWordsRate: $weeklyNewWordsRate, learningInsights: $learningInsights, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class $LearningStatsDTOCopyWith<$Res>  {
  factory $LearningStatsDTOCopyWith(LearningStatsDTO value, $Res Function(LearningStatsDTO) _then) = _$LearningStatsDTOCopyWithImpl;
@useResult
$Res call({
 int totalModules, Map<String, int> cycleStats, int dueToday, int dueThisWeek, int dueThisMonth, int wordsDueToday, int wordsDueThisWeek, int wordsDueThisMonth, int completedToday, int completedThisWeek, int completedThisMonth, int wordsCompletedToday, int wordsCompletedThisWeek, int wordsCompletedThisMonth, int streakDays, int streakWeeks, int longestStreakDays, int totalWords, int totalCompletedModules, int totalInProgressModules, int learnedWords, int pendingWords, double vocabularyCompletionRate, double weeklyNewWordsRate, List<LearningInsightRespone> learningInsights, DateTime? lastUpdated
});




}
/// @nodoc
class _$LearningStatsDTOCopyWithImpl<$Res>
    implements $LearningStatsDTOCopyWith<$Res> {
  _$LearningStatsDTOCopyWithImpl(this._self, this._then);

  final LearningStatsDTO _self;
  final $Res Function(LearningStatsDTO) _then;

/// Create a copy of LearningStatsDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalModules = null,Object? cycleStats = null,Object? dueToday = null,Object? dueThisWeek = null,Object? dueThisMonth = null,Object? wordsDueToday = null,Object? wordsDueThisWeek = null,Object? wordsDueThisMonth = null,Object? completedToday = null,Object? completedThisWeek = null,Object? completedThisMonth = null,Object? wordsCompletedToday = null,Object? wordsCompletedThisWeek = null,Object? wordsCompletedThisMonth = null,Object? streakDays = null,Object? streakWeeks = null,Object? longestStreakDays = null,Object? totalWords = null,Object? totalCompletedModules = null,Object? totalInProgressModules = null,Object? learnedWords = null,Object? pendingWords = null,Object? vocabularyCompletionRate = null,Object? weeklyNewWordsRate = null,Object? learningInsights = null,Object? lastUpdated = freezed,}) {
  return _then(_self.copyWith(
totalModules: null == totalModules ? _self.totalModules : totalModules // ignore: cast_nullable_to_non_nullable
as int,cycleStats: null == cycleStats ? _self.cycleStats : cycleStats // ignore: cast_nullable_to_non_nullable
as Map<String, int>,dueToday: null == dueToday ? _self.dueToday : dueToday // ignore: cast_nullable_to_non_nullable
as int,dueThisWeek: null == dueThisWeek ? _self.dueThisWeek : dueThisWeek // ignore: cast_nullable_to_non_nullable
as int,dueThisMonth: null == dueThisMonth ? _self.dueThisMonth : dueThisMonth // ignore: cast_nullable_to_non_nullable
as int,wordsDueToday: null == wordsDueToday ? _self.wordsDueToday : wordsDueToday // ignore: cast_nullable_to_non_nullable
as int,wordsDueThisWeek: null == wordsDueThisWeek ? _self.wordsDueThisWeek : wordsDueThisWeek // ignore: cast_nullable_to_non_nullable
as int,wordsDueThisMonth: null == wordsDueThisMonth ? _self.wordsDueThisMonth : wordsDueThisMonth // ignore: cast_nullable_to_non_nullable
as int,completedToday: null == completedToday ? _self.completedToday : completedToday // ignore: cast_nullable_to_non_nullable
as int,completedThisWeek: null == completedThisWeek ? _self.completedThisWeek : completedThisWeek // ignore: cast_nullable_to_non_nullable
as int,completedThisMonth: null == completedThisMonth ? _self.completedThisMonth : completedThisMonth // ignore: cast_nullable_to_non_nullable
as int,wordsCompletedToday: null == wordsCompletedToday ? _self.wordsCompletedToday : wordsCompletedToday // ignore: cast_nullable_to_non_nullable
as int,wordsCompletedThisWeek: null == wordsCompletedThisWeek ? _self.wordsCompletedThisWeek : wordsCompletedThisWeek // ignore: cast_nullable_to_non_nullable
as int,wordsCompletedThisMonth: null == wordsCompletedThisMonth ? _self.wordsCompletedThisMonth : wordsCompletedThisMonth // ignore: cast_nullable_to_non_nullable
as int,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,streakWeeks: null == streakWeeks ? _self.streakWeeks : streakWeeks // ignore: cast_nullable_to_non_nullable
as int,longestStreakDays: null == longestStreakDays ? _self.longestStreakDays : longestStreakDays // ignore: cast_nullable_to_non_nullable
as int,totalWords: null == totalWords ? _self.totalWords : totalWords // ignore: cast_nullable_to_non_nullable
as int,totalCompletedModules: null == totalCompletedModules ? _self.totalCompletedModules : totalCompletedModules // ignore: cast_nullable_to_non_nullable
as int,totalInProgressModules: null == totalInProgressModules ? _self.totalInProgressModules : totalInProgressModules // ignore: cast_nullable_to_non_nullable
as int,learnedWords: null == learnedWords ? _self.learnedWords : learnedWords // ignore: cast_nullable_to_non_nullable
as int,pendingWords: null == pendingWords ? _self.pendingWords : pendingWords // ignore: cast_nullable_to_non_nullable
as int,vocabularyCompletionRate: null == vocabularyCompletionRate ? _self.vocabularyCompletionRate : vocabularyCompletionRate // ignore: cast_nullable_to_non_nullable
as double,weeklyNewWordsRate: null == weeklyNewWordsRate ? _self.weeklyNewWordsRate : weeklyNewWordsRate // ignore: cast_nullable_to_non_nullable
as double,learningInsights: null == learningInsights ? _self.learningInsights : learningInsights // ignore: cast_nullable_to_non_nullable
as List<LearningInsightRespone>,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _LearningStatsDTO implements LearningStatsDTO {
  const _LearningStatsDTO({this.totalModules = 0, final  Map<String, int> cycleStats = const {'FIRST_TIME' : 0, 'FIRST_REVIEW' : 0, 'SECOND_REVIEW' : 0, 'THIRD_REVIEW' : 0, 'MORE_THAN_THREE_REVIEWS' : 0}, this.dueToday = 0, this.dueThisWeek = 0, this.dueThisMonth = 0, this.wordsDueToday = 0, this.wordsDueThisWeek = 0, this.wordsDueThisMonth = 0, this.completedToday = 0, this.completedThisWeek = 0, this.completedThisMonth = 0, this.wordsCompletedToday = 0, this.wordsCompletedThisWeek = 0, this.wordsCompletedThisMonth = 0, this.streakDays = 0, this.streakWeeks = 0, this.longestStreakDays = 0, this.totalWords = 0, this.totalCompletedModules = 0, this.totalInProgressModules = 0, this.learnedWords = 0, this.pendingWords = 0, this.vocabularyCompletionRate = 0.0, this.weeklyNewWordsRate = 0.0, final  List<LearningInsightRespone> learningInsights = const [], this.lastUpdated}): _cycleStats = cycleStats,_learningInsights = learningInsights;
  factory _LearningStatsDTO.fromJson(Map<String, dynamic> json) => _$LearningStatsDTOFromJson(json);

@override@JsonKey() final  int totalModules;
 final  Map<String, int> _cycleStats;
@override@JsonKey() Map<String, int> get cycleStats {
  if (_cycleStats is EqualUnmodifiableMapView) return _cycleStats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_cycleStats);
}

@override@JsonKey() final  int dueToday;
@override@JsonKey() final  int dueThisWeek;
@override@JsonKey() final  int dueThisMonth;
@override@JsonKey() final  int wordsDueToday;
@override@JsonKey() final  int wordsDueThisWeek;
@override@JsonKey() final  int wordsDueThisMonth;
@override@JsonKey() final  int completedToday;
@override@JsonKey() final  int completedThisWeek;
@override@JsonKey() final  int completedThisMonth;
@override@JsonKey() final  int wordsCompletedToday;
@override@JsonKey() final  int wordsCompletedThisWeek;
@override@JsonKey() final  int wordsCompletedThisMonth;
@override@JsonKey() final  int streakDays;
@override@JsonKey() final  int streakWeeks;
@override@JsonKey() final  int longestStreakDays;
@override@JsonKey() final  int totalWords;
@override@JsonKey() final  int totalCompletedModules;
@override@JsonKey() final  int totalInProgressModules;
@override@JsonKey() final  int learnedWords;
@override@JsonKey() final  int pendingWords;
@override@JsonKey() final  double vocabularyCompletionRate;
@override@JsonKey() final  double weeklyNewWordsRate;
 final  List<LearningInsightRespone> _learningInsights;
@override@JsonKey() List<LearningInsightRespone> get learningInsights {
  if (_learningInsights is EqualUnmodifiableListView) return _learningInsights;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_learningInsights);
}

@override final  DateTime? lastUpdated;

/// Create a copy of LearningStatsDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LearningStatsDTOCopyWith<_LearningStatsDTO> get copyWith => __$LearningStatsDTOCopyWithImpl<_LearningStatsDTO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LearningStatsDTOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LearningStatsDTO&&(identical(other.totalModules, totalModules) || other.totalModules == totalModules)&&const DeepCollectionEquality().equals(other._cycleStats, _cycleStats)&&(identical(other.dueToday, dueToday) || other.dueToday == dueToday)&&(identical(other.dueThisWeek, dueThisWeek) || other.dueThisWeek == dueThisWeek)&&(identical(other.dueThisMonth, dueThisMonth) || other.dueThisMonth == dueThisMonth)&&(identical(other.wordsDueToday, wordsDueToday) || other.wordsDueToday == wordsDueToday)&&(identical(other.wordsDueThisWeek, wordsDueThisWeek) || other.wordsDueThisWeek == wordsDueThisWeek)&&(identical(other.wordsDueThisMonth, wordsDueThisMonth) || other.wordsDueThisMonth == wordsDueThisMonth)&&(identical(other.completedToday, completedToday) || other.completedToday == completedToday)&&(identical(other.completedThisWeek, completedThisWeek) || other.completedThisWeek == completedThisWeek)&&(identical(other.completedThisMonth, completedThisMonth) || other.completedThisMonth == completedThisMonth)&&(identical(other.wordsCompletedToday, wordsCompletedToday) || other.wordsCompletedToday == wordsCompletedToday)&&(identical(other.wordsCompletedThisWeek, wordsCompletedThisWeek) || other.wordsCompletedThisWeek == wordsCompletedThisWeek)&&(identical(other.wordsCompletedThisMonth, wordsCompletedThisMonth) || other.wordsCompletedThisMonth == wordsCompletedThisMonth)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.streakWeeks, streakWeeks) || other.streakWeeks == streakWeeks)&&(identical(other.longestStreakDays, longestStreakDays) || other.longestStreakDays == longestStreakDays)&&(identical(other.totalWords, totalWords) || other.totalWords == totalWords)&&(identical(other.totalCompletedModules, totalCompletedModules) || other.totalCompletedModules == totalCompletedModules)&&(identical(other.totalInProgressModules, totalInProgressModules) || other.totalInProgressModules == totalInProgressModules)&&(identical(other.learnedWords, learnedWords) || other.learnedWords == learnedWords)&&(identical(other.pendingWords, pendingWords) || other.pendingWords == pendingWords)&&(identical(other.vocabularyCompletionRate, vocabularyCompletionRate) || other.vocabularyCompletionRate == vocabularyCompletionRate)&&(identical(other.weeklyNewWordsRate, weeklyNewWordsRate) || other.weeklyNewWordsRate == weeklyNewWordsRate)&&const DeepCollectionEquality().equals(other._learningInsights, _learningInsights)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,totalModules,const DeepCollectionEquality().hash(_cycleStats),dueToday,dueThisWeek,dueThisMonth,wordsDueToday,wordsDueThisWeek,wordsDueThisMonth,completedToday,completedThisWeek,completedThisMonth,wordsCompletedToday,wordsCompletedThisWeek,wordsCompletedThisMonth,streakDays,streakWeeks,longestStreakDays,totalWords,totalCompletedModules,totalInProgressModules,learnedWords,pendingWords,vocabularyCompletionRate,weeklyNewWordsRate,const DeepCollectionEquality().hash(_learningInsights),lastUpdated]);

@override
String toString() {
  return 'LearningStatsDTO(totalModules: $totalModules, cycleStats: $cycleStats, dueToday: $dueToday, dueThisWeek: $dueThisWeek, dueThisMonth: $dueThisMonth, wordsDueToday: $wordsDueToday, wordsDueThisWeek: $wordsDueThisWeek, wordsDueThisMonth: $wordsDueThisMonth, completedToday: $completedToday, completedThisWeek: $completedThisWeek, completedThisMonth: $completedThisMonth, wordsCompletedToday: $wordsCompletedToday, wordsCompletedThisWeek: $wordsCompletedThisWeek, wordsCompletedThisMonth: $wordsCompletedThisMonth, streakDays: $streakDays, streakWeeks: $streakWeeks, longestStreakDays: $longestStreakDays, totalWords: $totalWords, totalCompletedModules: $totalCompletedModules, totalInProgressModules: $totalInProgressModules, learnedWords: $learnedWords, pendingWords: $pendingWords, vocabularyCompletionRate: $vocabularyCompletionRate, weeklyNewWordsRate: $weeklyNewWordsRate, learningInsights: $learningInsights, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class _$LearningStatsDTOCopyWith<$Res> implements $LearningStatsDTOCopyWith<$Res> {
  factory _$LearningStatsDTOCopyWith(_LearningStatsDTO value, $Res Function(_LearningStatsDTO) _then) = __$LearningStatsDTOCopyWithImpl;
@override @useResult
$Res call({
 int totalModules, Map<String, int> cycleStats, int dueToday, int dueThisWeek, int dueThisMonth, int wordsDueToday, int wordsDueThisWeek, int wordsDueThisMonth, int completedToday, int completedThisWeek, int completedThisMonth, int wordsCompletedToday, int wordsCompletedThisWeek, int wordsCompletedThisMonth, int streakDays, int streakWeeks, int longestStreakDays, int totalWords, int totalCompletedModules, int totalInProgressModules, int learnedWords, int pendingWords, double vocabularyCompletionRate, double weeklyNewWordsRate, List<LearningInsightRespone> learningInsights, DateTime? lastUpdated
});




}
/// @nodoc
class __$LearningStatsDTOCopyWithImpl<$Res>
    implements _$LearningStatsDTOCopyWith<$Res> {
  __$LearningStatsDTOCopyWithImpl(this._self, this._then);

  final _LearningStatsDTO _self;
  final $Res Function(_LearningStatsDTO) _then;

/// Create a copy of LearningStatsDTO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalModules = null,Object? cycleStats = null,Object? dueToday = null,Object? dueThisWeek = null,Object? dueThisMonth = null,Object? wordsDueToday = null,Object? wordsDueThisWeek = null,Object? wordsDueThisMonth = null,Object? completedToday = null,Object? completedThisWeek = null,Object? completedThisMonth = null,Object? wordsCompletedToday = null,Object? wordsCompletedThisWeek = null,Object? wordsCompletedThisMonth = null,Object? streakDays = null,Object? streakWeeks = null,Object? longestStreakDays = null,Object? totalWords = null,Object? totalCompletedModules = null,Object? totalInProgressModules = null,Object? learnedWords = null,Object? pendingWords = null,Object? vocabularyCompletionRate = null,Object? weeklyNewWordsRate = null,Object? learningInsights = null,Object? lastUpdated = freezed,}) {
  return _then(_LearningStatsDTO(
totalModules: null == totalModules ? _self.totalModules : totalModules // ignore: cast_nullable_to_non_nullable
as int,cycleStats: null == cycleStats ? _self._cycleStats : cycleStats // ignore: cast_nullable_to_non_nullable
as Map<String, int>,dueToday: null == dueToday ? _self.dueToday : dueToday // ignore: cast_nullable_to_non_nullable
as int,dueThisWeek: null == dueThisWeek ? _self.dueThisWeek : dueThisWeek // ignore: cast_nullable_to_non_nullable
as int,dueThisMonth: null == dueThisMonth ? _self.dueThisMonth : dueThisMonth // ignore: cast_nullable_to_non_nullable
as int,wordsDueToday: null == wordsDueToday ? _self.wordsDueToday : wordsDueToday // ignore: cast_nullable_to_non_nullable
as int,wordsDueThisWeek: null == wordsDueThisWeek ? _self.wordsDueThisWeek : wordsDueThisWeek // ignore: cast_nullable_to_non_nullable
as int,wordsDueThisMonth: null == wordsDueThisMonth ? _self.wordsDueThisMonth : wordsDueThisMonth // ignore: cast_nullable_to_non_nullable
as int,completedToday: null == completedToday ? _self.completedToday : completedToday // ignore: cast_nullable_to_non_nullable
as int,completedThisWeek: null == completedThisWeek ? _self.completedThisWeek : completedThisWeek // ignore: cast_nullable_to_non_nullable
as int,completedThisMonth: null == completedThisMonth ? _self.completedThisMonth : completedThisMonth // ignore: cast_nullable_to_non_nullable
as int,wordsCompletedToday: null == wordsCompletedToday ? _self.wordsCompletedToday : wordsCompletedToday // ignore: cast_nullable_to_non_nullable
as int,wordsCompletedThisWeek: null == wordsCompletedThisWeek ? _self.wordsCompletedThisWeek : wordsCompletedThisWeek // ignore: cast_nullable_to_non_nullable
as int,wordsCompletedThisMonth: null == wordsCompletedThisMonth ? _self.wordsCompletedThisMonth : wordsCompletedThisMonth // ignore: cast_nullable_to_non_nullable
as int,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,streakWeeks: null == streakWeeks ? _self.streakWeeks : streakWeeks // ignore: cast_nullable_to_non_nullable
as int,longestStreakDays: null == longestStreakDays ? _self.longestStreakDays : longestStreakDays // ignore: cast_nullable_to_non_nullable
as int,totalWords: null == totalWords ? _self.totalWords : totalWords // ignore: cast_nullable_to_non_nullable
as int,totalCompletedModules: null == totalCompletedModules ? _self.totalCompletedModules : totalCompletedModules // ignore: cast_nullable_to_non_nullable
as int,totalInProgressModules: null == totalInProgressModules ? _self.totalInProgressModules : totalInProgressModules // ignore: cast_nullable_to_non_nullable
as int,learnedWords: null == learnedWords ? _self.learnedWords : learnedWords // ignore: cast_nullable_to_non_nullable
as int,pendingWords: null == pendingWords ? _self.pendingWords : pendingWords // ignore: cast_nullable_to_non_nullable
as int,vocabularyCompletionRate: null == vocabularyCompletionRate ? _self.vocabularyCompletionRate : vocabularyCompletionRate // ignore: cast_nullable_to_non_nullable
as double,weeklyNewWordsRate: null == weeklyNewWordsRate ? _self.weeklyNewWordsRate : weeklyNewWordsRate // ignore: cast_nullable_to_non_nullable
as double,learningInsights: null == learningInsights ? _self._learningInsights : learningInsights // ignore: cast_nullable_to_non_nullable
as List<LearningInsightRespone>,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
