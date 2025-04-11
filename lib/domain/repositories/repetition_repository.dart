import 'package:spaced_learning_app/domain/models/repetition.dart';

/// Repository interface for repetition operations
abstract class RepetitionRepository {
  /// Get all repetitions with pagination
  // Future<List<Repetition>> getAllRepetitions({int page = 0, int size = 20});

  /// Get repetition by ID
  // Future<Repetition> getRepetitionById(String id);

  /// Get repetitions by progress ID
  Future<List<Repetition>> getRepetitionsByProgressId(String progressId);

  /// Get repetition by progress ID and order
  // Future<Repetition> getRepetitionByProgressIdAndOrder(
  //   String progressId,
  //   RepetitionOrder order,
  // );

  /// Get repetitions due for review
  // Future<List<Repetition>> getDueRepetitions(
  //   String userId, {
  //   DateTime? reviewDate,
  //   RepetitionStatus? status,
  //   int page = 0,
  //   int size = 20,
  // });

  // /// Create a new repetition
  // Future<Repetition> createRepetition({
  //   required String moduleProgressId,
  //   required RepetitionOrder repetitionOrder,
  //   RepetitionStatus? status,
  //   DateTime? reviewDate,
  // });

  /// Create default repetition schedule for a progress record
  Future<List<Repetition>> createDefaultSchedule(String moduleProgressId);

  /// Update a repetition
  Future<Repetition> updateRepetition(
    String id, {
    RepetitionStatus? status,
    DateTime? reviewDate,
    bool rescheduleFollowing = false,
  });

  /// Delete a repetition
  // Future<void> deleteRepetition(String id);

  /// Count total repetitions by module progress ID
  Future<int> countByModuleProgressId(String moduleProgressId);
}
