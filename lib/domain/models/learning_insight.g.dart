// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_insight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LearningInsightDTO _$LearningInsightDTOFromJson(Map<String, dynamic> json) =>
    _LearningInsightDTO(
      type: $enumDecode(_$InsightTypeEnumMap, json['type']),
      message: json['message'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      dataPoint: (json['dataPoint'] as num?)?.toDouble() ?? 0.0,
      priority: (json['priority'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$LearningInsightDTOToJson(_LearningInsightDTO instance) =>
    <String, dynamic>{
      'type': _$InsightTypeEnumMap[instance.type]!,
      'message': instance.message,
      'icon': instance.icon,
      'color': instance.color,
      'dataPoint': instance.dataPoint,
      'priority': instance.priority,
    };

const _$InsightTypeEnumMap = {
  InsightType.vocabularyRate: 'VOCABULARY_RATE',
  InsightType.streak: 'STREAK',
  InsightType.pendingWords: 'PENDING_WORDS',
  InsightType.dueToday: 'DUE_TODAY',
  InsightType.achievement: 'ACHIEVEMENT',
  InsightType.tip: 'TIP',
};
