// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookSummary _$BookSummaryFromJson(Map<String, dynamic> json) => _BookSummary(
  id: json['id'] as String,
  name: json['name'] as String,
  status: $enumDecode(_$BookStatusEnumMap, json['status']),
  difficultyLevel: $enumDecodeNullable(
    _$DifficultyLevelEnumMap,
    json['difficultyLevel'],
  ),
  category: json['category'] as String?,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
  moduleCount: (json['moduleCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$BookSummaryToJson(_BookSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': _$BookStatusEnumMap[instance.status]!,
      'difficultyLevel': _$DifficultyLevelEnumMap[instance.difficultyLevel],
      'category': instance.category,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'moduleCount': instance.moduleCount,
    };

const _$BookStatusEnumMap = {
  BookStatus.published: 'PUBLISHED',
  BookStatus.draft: 'DRAFT',
  BookStatus.archived: 'ARCHIVED',
};

const _$DifficultyLevelEnumMap = {
  DifficultyLevel.beginner: 'BEGINNER',
  DifficultyLevel.intermediate: 'INTERMEDIATE',
  DifficultyLevel.advanced: 'ADVANCED',
  DifficultyLevel.expert: 'EXPERT',
};

_BookDetail _$BookDetailFromJson(Map<String, dynamic> json) => _BookDetail(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  status: $enumDecode(_$BookStatusEnumMap, json['status']),
  difficultyLevel: $enumDecodeNullable(
    _$DifficultyLevelEnumMap,
    json['difficultyLevel'],
  ),
  category: json['category'] as String?,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
  modules:
      (json['modules'] as List<dynamic>?)
          ?.map((e) => ModuleDetail.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$BookDetailToJson(_BookDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'status': _$BookStatusEnumMap[instance.status]!,
      'difficultyLevel': _$DifficultyLevelEnumMap[instance.difficultyLevel],
      'category': instance.category,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'modules': instance.modules,
    };
