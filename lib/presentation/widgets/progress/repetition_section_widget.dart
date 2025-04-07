import 'package:flutter/material.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/presentation/widgets/repetition/repetition_card.dart'; // Giả định RepetitionCard đã theme-aware

/// Widget hiển thị một section chứa danh sách các RepetitionCard.
/// Giao diện phụ thuộc vào RepetitionCard.
class RepetitionSectionWidget extends StatelessWidget {
  final List<Repetition> repetitions;
  final bool isHistory; // Flag để xác định có phải màn hình lịch sử không
  // Callbacks cho các hành động (chỉ kích hoạt nếu không phải isHistory)
  final Future<void> Function(String)? onMarkCompleted;
  final Future<void> Function(String)? onMarkSkipped;
  final Future<void> Function(BuildContext, String)? onReschedule;

  const RepetitionSectionWidget({
    super.key,
    required this.repetitions,
    this.isHistory = false,
    this.onMarkCompleted,
    this.onMarkSkipped,
    this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    // Sắp xếp danh sách repetitions theo thứ tự lặp lại
    final sortedRepetitions = List<Repetition>.from(repetitions)..sort(
      (a, b) => a.repetitionOrder.index.compareTo(b.repetitionOrder.index),
    );

    // Sử dụng ListView.builder để hiển thị danh sách
    return ListView.builder(
      // shrinkWrap và physics này thường dùng khi ListView lồng trong widget cuộn khác
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedRepetitions.length,
      itemBuilder: (context, index) {
        final repetition = sortedRepetitions[index];
        // Mỗi item là một RepetitionCard
        return RepetitionCard(
          // Key giúp Flutter quản lý widget hiệu quả
          key: ValueKey(repetition.id),
          repetition: repetition,
          isHistory: isHistory,
          // Vô hiệu hóa các hành động nếu là màn hình lịch sử
          onMarkCompleted:
              isHistory ? null : () => onMarkCompleted?.call(repetition.id),
          onSkip: isHistory ? null : () => onMarkSkipped?.call(repetition.id),
          onReschedule:
              isHistory
                  ? null
                  : () => onReschedule?.call(context, repetition.id),
        );
      },
    );
  }
}
