
part of 'repetition.dart';


_Repetition _$RepetitionFromJson(Map<String, dynamic> json) => _Repetition(
  id: json['id'] as String,
  moduleProgressId: json['moduleProgressId'] as String,
  repetitionOrder: $enumDecode(
    _$RepetitionOrderEnumMap,
    json['repetitionOrder'],
  ),
  status:
      $enumDecodeNullable(_$RepetitionStatusEnumMap, json['status']) ??
      RepetitionStatus.notStarted,
  reviewDate:
      json['reviewDate'] == null
          ? null
          : DateTime.parse(json['reviewDate'] as String),
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$RepetitionToJson(_Repetition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'moduleProgressId': instance.moduleProgressId,
      'repetitionOrder': _$RepetitionOrderEnumMap[instance.repetitionOrder]!,
      'status': _$RepetitionStatusEnumMap[instance.status]!,
      'reviewDate': instance.reviewDate?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$RepetitionOrderEnumMap = {
  RepetitionOrder.firstRepetition: 'FIRST_REPETITION',
  RepetitionOrder.secondRepetition: 'SECOND_REPETITION',
  RepetitionOrder.thirdRepetition: 'THIRD_REPETITION',
  RepetitionOrder.fourthRepetition: 'FOURTH_REPETITION',
  RepetitionOrder.fifthRepetition: 'FIFTH_REPETITION',
};

const _$RepetitionStatusEnumMap = {
  RepetitionStatus.notStarted: 'NOT_STARTED',
  RepetitionStatus.completed: 'COMPLETED',
  RepetitionStatus.skipped: 'SKIPPED',
};
