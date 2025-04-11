
part of 'module.dart';


_ModuleSummary _$ModuleSummaryFromJson(Map<String, dynamic> json) =>
    _ModuleSummary(
      id: json['id'] as String,
      bookId: json['bookId'] as String,
      moduleNo: (json['moduleNo'] as num).toInt(),
      title: json['title'] as String,
      wordCount: (json['wordCount'] as num?)?.toInt(),
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      updatedAt:
          json['updatedAt'] == null
              ? null
              : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ModuleSummaryToJson(_ModuleSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookId': instance.bookId,
      'moduleNo': instance.moduleNo,
      'title': instance.title,
      'wordCount': instance.wordCount,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_ModuleDetail _$ModuleDetailFromJson(Map<String, dynamic> json) =>
    _ModuleDetail(
      id: json['id'] as String,
      bookId: json['bookId'] as String,
      bookName: json['bookName'] as String?,
      moduleNo: (json['moduleNo'] as num).toInt(),
      title: json['title'] as String,
      wordCount: (json['wordCount'] as num?)?.toInt(),
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      updatedAt:
          json['updatedAt'] == null
              ? null
              : DateTime.parse(json['updatedAt'] as String),
      progress:
          (json['progress'] as List<dynamic>?)
              ?.map((e) => ProgressSummary.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ModuleDetailToJson(_ModuleDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookId': instance.bookId,
      'bookName': instance.bookName,
      'moduleNo': instance.moduleNo,
      'title': instance.title,
      'wordCount': instance.wordCount,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'progress': instance.progress,
    };
