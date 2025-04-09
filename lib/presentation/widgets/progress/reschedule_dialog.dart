import 'package:flutter/material.dart';

class RescheduleDialog {
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required DateTime initialDate,
    required String title,
  }) async {
    DateTime selectedDate = initialDate;
    bool rescheduleFollowing = false;

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder:
          (dialogContext) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: Text(title),
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
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                          onDateChanged:
                              (date) => setState(() => selectedDate = date),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Reschedule following repetitions'),
                        subtitle: const Text(
                          'Adjust all future repetitions based on this new date',
                        ),
                        value: rescheduleFollowing,
                        onChanged:
                            (value) =>
                                setState(() => rescheduleFollowing = value),
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
          ),
    );
  }
}
