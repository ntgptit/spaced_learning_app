import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spaced_learning_app/domain/models/module.dart';

part 'book.freezed.dart';
part 'book.g.dart';

/// Enum for book status
enum BookStatus {
  @JsonValue('PUBLISHED')
  published,
  @JsonValue('DRAFT')
  draft,
  @JsonValue('ARCHIVED')
  archived,
}

/// Enum for difficulty level
enum DifficultyLevel {
  @JsonValue('BEGINNER')
  beginner,
  @JsonValue('INTERMEDIATE')
  intermediate,
  @JsonValue('ADVANCED')
  advanced,
  @JsonValue('EXPERT')
  expert,
}

/// Book summary model with basic information
@freezed
abstract class BookSummary with _$BookSummary {
  const factory BookSummary({
    required String id,
    required String name,
    required BookStatus status,
    DifficultyLevel? difficultyLevel,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(0) int moduleCount,
  }) = _BookSummary;

  factory BookSummary.fromJson(Map<String, dynamic> json) =>
      _$BookSummaryFromJson(json);
}

/// Detailed book model including modules
@freezed
abstract class BookDetail with _$BookDetail {
  const factory BookDetail({
    required String id,
    required String name,
    String? description,
    required BookStatus status,
    DifficultyLevel? difficultyLevel,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default([]) List<ModuleDetail> modules,
  }) = _BookDetail;

  factory BookDetail.fromJson(Map<String, dynamic> json) =>
      _$BookDetailFromJson(json);
}
