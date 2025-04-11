import 'package:freezed_annotation/freezed_annotation.dart';

part 'learning_insight.freezed.dart';
part 'learning_insight.g.dart';

enum InsightType {
  @JsonValue('VOCABULARY_RATE')
  vocabularyRate,
  @JsonValue('STREAK')
  streak,
  @JsonValue('PENDING_WORDS')
  pendingWords,
  @JsonValue('DUE_TODAY')
  dueToday,
  @JsonValue('ACHIEVEMENT')
  achievement,
  @JsonValue('TIP')
  tip,
}

@freezed
abstract class LearningInsightDTO with _$LearningInsightDTO {
  const factory LearningInsightDTO({
    required InsightType type,
    required String message,
    required String icon,
    required String color,
    @Default(0.0) double dataPoint,
    @Default(0) int priority,
  }) = _LearningInsightDTO;

  factory LearningInsightDTO.fromJson(Map<String, dynamic> json) =>
      _$LearningInsightDTOFromJson(json);
}
