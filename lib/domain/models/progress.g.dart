// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProgressSummary _$ProgressSummaryFromJson(Map<String, dynamic> json) =>
    _ProgressSummary(
      id: json['id'] as String,
      moduleId: json['moduleId'] as String,
      userId: json['userId'] as String,
      firstLearningDate:
          json['firstLearningDate'] == null
              ? null
              : DateTime.parse(json['firstLearningDate'] as String),
      cyclesStudied:
          $enumDecodeNullable(_$CycleStudiedEnumMap, json['cyclesStudied']) ??
          CycleStudied.firstTime,
      nextStudyDate:
          json['nextStudyDate'] == null
              ? null
              : DateTime.parse(json['nextStudyDate'] as String),
      percentComplete: (json['percentComplete'] as num?)?.toDouble() ?? 0,
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      updatedAt:
          json['updatedAt'] == null
              ? null
              : DateTime.parse(json['updatedAt'] as String),
      repetitionCount: (json['repetitionCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ProgressSummaryToJson(_ProgressSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'moduleId': instance.moduleId,
      'userId': instance.userId,
      'firstLearningDate': instance.firstLearningDate?.toIso8601String(),
      'cyclesStudied': _$CycleStudiedEnumMap[instance.cyclesStudied]!,
      'nextStudyDate': instance.nextStudyDate?.toIso8601String(),
      'percentComplete': instance.percentComplete,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'repetitionCount': instance.repetitionCount,
    };

const _$CycleStudiedEnumMap = {
  CycleStudied.firstTime: 'FIRST_TIME',
  CycleStudied.firstReview: 'FIRST_REVIEW',
  CycleStudied.secondReview: 'SECOND_REVIEW',
  CycleStudied.thirdReview: 'THIRD_REVIEW',
  CycleStudied.moreThanThreeReviews: 'MORE_THAN_THREE_REVIEWS',
};

_ProgressDetail _$ProgressDetailFromJson(Map<String, dynamic> json) =>
    _ProgressDetail(
      id: json['id'] as String,
      moduleId: json['moduleId'] as String,
      moduleTitle: json['moduleTitle'] as String?,
      userId: json['userId'] as String,
      userName: json['userName'] as String?,
      firstLearningDate:
          json['firstLearningDate'] == null
              ? null
              : DateTime.parse(json['firstLearningDate'] as String),
      cyclesStudied:
          $enumDecodeNullable(_$CycleStudiedEnumMap, json['cyclesStudied']) ??
          CycleStudied.firstTime,
      nextStudyDate:
          json['nextStudyDate'] == null
              ? null
              : DateTime.parse(json['nextStudyDate'] as String),
      percentComplete: (json['percentComplete'] as num?)?.toDouble() ?? 0,
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      updatedAt:
          json['updatedAt'] == null
              ? null
              : DateTime.parse(json['updatedAt'] as String),
      repetitions:
          (json['repetitions'] as List<dynamic>?)
              ?.map((e) => Repetition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ProgressDetailToJson(_ProgressDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'moduleId': instance.moduleId,
      'moduleTitle': instance.moduleTitle,
      'userId': instance.userId,
      'userName': instance.userName,
      'firstLearningDate': instance.firstLearningDate?.toIso8601String(),
      'cyclesStudied': _$CycleStudiedEnumMap[instance.cyclesStudied]!,
      'nextStudyDate': instance.nextStudyDate?.toIso8601String(),
      'percentComplete': instance.percentComplete,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'repetitions': instance.repetitions,
    };
