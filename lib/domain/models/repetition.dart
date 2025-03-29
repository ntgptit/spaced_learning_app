// lib/domain/models/repetition.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'repetition.freezed.dart';
part 'repetition.g.dart';

/// Enum for repetition order
enum RepetitionOrder {
  @JsonValue('FIRST_REPETITION')
  firstRepetition,
  @JsonValue('SECOND_REPETITION')
  secondRepetition,
  @JsonValue('THIRD_REPETITION')
  thirdRepetition,
  @JsonValue('FOURTH_REPETITION')
  fourthRepetition,
  @JsonValue('FIFTH_REPETITION')
  fifthRepetition,
}

/// Enum for repetition status
enum RepetitionStatus {
  @JsonValue('NOT_STARTED')
  notStarted,
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('SKIPPED')
  skipped,
}

/// Repetition model
@freezed
abstract class Repetition with _$Repetition {
  const factory Repetition({
    required String id,
    required String moduleProgressId,
    required RepetitionOrder repetitionOrder,
    @Default(RepetitionStatus.notStarted) RepetitionStatus status,
    DateTime? reviewDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Repetition;

  factory Repetition.fromJson(Map<String, dynamic> json) =>
      _$RepetitionFromJson(json);
}
