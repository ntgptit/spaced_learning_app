import 'package:flutter/material.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/presentation/widgets/repetition/repetition_card.dart';

/// Widget hiển thị một section chứa danh sách các RepetitionCard.
class RepetitionSectionWidget extends StatelessWidget {
  final List<Repetition> repetitions;
  final bool isHistory;
  final Future<void> Function(String)? onMarkCompleted;
  final Future<void> Function(String)? onMarkSkipped;
  // Cập nhật signature của onReschedule callback
  final Future<void> Function(BuildContext, String, DateTime, bool)?
  onReschedule;

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
    final sortedRepetitions = List<Repetition>.from(repetitions)..sort(
      (a, b) => a.repetitionOrder.index.compareTo(b.repetitionOrder.index),
    );

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedRepetitions.length,
      itemBuilder: (context, index) {
        final repetition = sortedRepetitions[index];
        return RepetitionCard(
          key: ValueKey(repetition.id),
          repetition: repetition,
          isHistory: isHistory,
          onMarkCompleted:
              isHistory ? null : () => onMarkCompleted?.call(repetition.id),
          onSkip: isHistory ? null : () => onMarkSkipped?.call(repetition.id),
          // Cập nhật cách gọi onReschedule
          onReschedule:
              isHistory
                  ? null
                  : (currentDate) {
                    // Thêm tham số currentDate để phù hợp với signature Function(DateTime)?
                    _showReschedulePicker(context, repetition.id, currentDate);
                  },
        );
      },
    );
  }

  // Thêm phương thức hiển thị dialog cho reschedule
  Future<void> _showReschedulePicker(
    BuildContext context,
    String repetitionId,
    DateTime currentDate,
  ) async {
    DateTime selectedDate = currentDate;
    bool rescheduleFollowing = false;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder:
              (context, setState) => AlertDialog(
                title: const Text('Reschedule Repetition'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Select new date:'),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      width: 300,
                      child: CalendarDatePicker(
                        initialDate: selectedDate,
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 7),
                        ),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        onDateChanged: (date) {
                          setState(() {
                            selectedDate = date;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Reschedule following repetitions'),
                      subtitle: const Text(
                        'Adjust all future repetitions based on this new date',
                      ),
                      value: rescheduleFollowing,
                      onChanged: (value) {
                        setState(() {
                          rescheduleFollowing = value;
                        });
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed:
                        () => Navigator.pop(context, {
                          'date': selectedDate,
                          'rescheduleFollowing': rescheduleFollowing,
                        }),
                    child: const Text('Reschedule'),
                  ),
                ],
              ),
        );
      },
    );

    if (result != null) {
      final selectedDate = result['date'] as DateTime;
      final rescheduleFollowing = result['rescheduleFollowing'] as bool;

      await onReschedule?.call(
        context,
        repetitionId,
        selectedDate,
        rescheduleFollowing,
      );
    }
  }
}
