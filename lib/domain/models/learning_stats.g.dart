// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LearningStatsDTO _$LearningStatsDTOFromJson(
  Map<String, dynamic> json,
) => _LearningStatsDTO(
  totalModules: (json['totalModules'] as num?)?.toInt() ?? 0,
  completedModules: (json['completedModules'] as num?)?.toInt() ?? 0,
  inProgressModules: (json['inProgressModules'] as num?)?.toInt() ?? 0,
  moduleCompletionRate:
      (json['moduleCompletionRate'] as num?)?.toDouble() ?? 0.0,
  dueToday: (json['dueToday'] as num?)?.toInt() ?? 0,
  dueThisWeek: (json['dueThisWeek'] as num?)?.toInt() ?? 0,
  dueThisMonth: (json['dueThisMonth'] as num?)?.toInt() ?? 0,
  wordsDueToday: (json['wordsDueToday'] as num?)?.toInt() ?? 0,
  wordsDueThisWeek: (json['wordsDueThisWeek'] as num?)?.toInt() ?? 0,
  wordsDueThisMonth: (json['wordsDueThisMonth'] as num?)?.toInt() ?? 0,
  completedToday: (json['completedToday'] as num?)?.toInt() ?? 0,
  completedThisWeek: (json['completedThisWeek'] as num?)?.toInt() ?? 0,
  completedThisMonth: (json['completedThisMonth'] as num?)?.toInt() ?? 0,
  wordsCompletedToday: (json['wordsCompletedToday'] as num?)?.toInt() ?? 0,
  wordsCompletedThisWeek:
      (json['wordsCompletedThisWeek'] as num?)?.toInt() ?? 0,
  wordsCompletedThisMonth:
      (json['wordsCompletedThisMonth'] as num?)?.toInt() ?? 0,
  streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
  streakWeeks: (json['streakWeeks'] as num?)?.toInt() ?? 0,
  longestStreakDays: (json['longestStreakDays'] as num?)?.toInt() ?? 0,
  totalWords: (json['totalWords'] as num?)?.toInt() ?? 0,
  totalCompletedModules: (json['totalCompletedModules'] as num?)?.toInt() ?? 0,
  totalInProgressModules:
      (json['totalInProgressModules'] as num?)?.toInt() ?? 0,
  learnedWords: (json['learnedWords'] as num?)?.toInt() ?? 0,
  pendingWords: (json['pendingWords'] as num?)?.toInt() ?? 0,
  vocabularyCompletionRate:
      (json['vocabularyCompletionRate'] as num?)?.toDouble() ?? 0.0,
  weeklyNewWordsRate: (json['weeklyNewWordsRate'] as num?)?.toDouble() ?? 0.0,
  learningInsights:
      (json['learningInsights'] as List<dynamic>?)
          ?.map((e) => LearningInsightDTO.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  lastUpdated:
      json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
);

Map<String, dynamic> _$LearningStatsDTOToJson(_LearningStatsDTO instance) =>
    <String, dynamic>{
      'totalModules': instance.totalModules,
      'completedModules': instance.completedModules,
      'inProgressModules': instance.inProgressModules,
      'moduleCompletionRate': instance.moduleCompletionRate,
      'dueToday': instance.dueToday,
      'dueThisWeek': instance.dueThisWeek,
      'dueThisMonth': instance.dueThisMonth,
      'wordsDueToday': instance.wordsDueToday,
      'wordsDueThisWeek': instance.wordsDueThisWeek,
      'wordsDueThisMonth': instance.wordsDueThisMonth,
      'completedToday': instance.completedToday,
      'completedThisWeek': instance.completedThisWeek,
      'completedThisMonth': instance.completedThisMonth,
      'wordsCompletedToday': instance.wordsCompletedToday,
      'wordsCompletedThisWeek': instance.wordsCompletedThisWeek,
      'wordsCompletedThisMonth': instance.wordsCompletedThisMonth,
      'streakDays': instance.streakDays,
      'streakWeeks': instance.streakWeeks,
      'longestStreakDays': instance.longestStreakDays,
      'totalWords': instance.totalWords,
      'totalCompletedModules': instance.totalCompletedModules,
      'totalInProgressModules': instance.totalInProgressModules,
      'learnedWords': instance.learnedWords,
      'pendingWords': instance.pendingWords,
      'vocabularyCompletionRate': instance.vocabularyCompletionRate,
      'weeklyNewWordsRate': instance.weeklyNewWordsRate,
      'learningInsights': instance.learningInsights,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };
