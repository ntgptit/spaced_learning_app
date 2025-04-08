// lib/domain/models/progress.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';

part 'progress.freezed.dart';
part 'progress.g.dart';

/// Enum for cycle studied status
enum CycleStudied {
  @JsonValue('FIRST_TIME')
  firstTime,
  @JsonValue('FIRST_REVIEW')
  firstReview,
  @JsonValue('SECOND_REVIEW')
  secondReview,
  @JsonValue('THIRD_REVIEW')
  thirdReview,
  @JsonValue('MORE_THAN_THREE_REVIEWS')
  moreThanThreeReviews,
}

/// Progress summary model with basic information
@freezed
abstract class ProgressSummary with _$ProgressSummary {
  const factory ProgressSummary({
    required String id,
    required String moduleId,
    DateTime? firstLearningDate,
    @Default(CycleStudied.firstTime) CycleStudied cyclesStudied,
    DateTime? nextStudyDate,
    @Default(0) double percentComplete,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(0) int repetitionCount,
  }) = _ProgressSummary;

  factory ProgressSummary.fromJson(Map<String, dynamic> json) =>
      _$ProgressSummaryFromJson(json);
}

/// Detailed progress model including repetitions
@freezed
abstract class ProgressDetail with _$ProgressDetail {
  const factory ProgressDetail({
    required String id,
    required String moduleId,
    String? moduleTitle,
    String? userName,
    DateTime? firstLearningDate,
    @Default(CycleStudied.firstTime) CycleStudied cyclesStudied,
    DateTime? nextStudyDate,
    @Default(0) double percentComplete,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default([]) List<Repetition> repetitions,
  }) = _ProgressDetail;

  factory ProgressDetail.fromJson(Map<String, dynamic> json) =>
      _$ProgressDetailFromJson(json);
}
