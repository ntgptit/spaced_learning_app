import 'package:spaced_learning_app/domain/models/repetition.dart';

class RepetitionUtils {
  static Map<String, List<Repetition>> groupByCycle(
    List<Repetition> repetitions,
  ) {
    final groupedByCycle = <String, List<Repetition>>{};
    final sortedRepetitions = List<Repetition>.from(repetitions)..sort((a, b) {
      if (a.createdAt == null && b.createdAt == null) return 0;
      if (a.createdAt == null) return 1;
      if (b.createdAt == null) return -1;
      return a.createdAt!.compareTo(b.createdAt!);
    });

    int cycleIndex = 1;
    int currentGroupCount = 0;
    String currentKey = '';
    int repIndex = 0;

    while (repIndex < sortedRepetitions.length) {
      final rep = sortedRepetitions[repIndex];
      if (currentGroupCount < 5) {
        if (currentGroupCount == 0) {
          currentKey = 'Cycle $cycleIndex';
          groupedByCycle[currentKey] = [];
        }
        groupedByCycle[currentKey]!.add(rep);
        currentGroupCount++;
        repIndex++;
      } else {
        cycleIndex++;
        currentGroupCount = 0;
      }
    }

    for (final key in groupedByCycle.keys) {
      groupedByCycle[key]!.sort(
        (a, b) => a.repetitionOrder.index.compareTo(b.repetitionOrder.index),
      );
    }

    return groupedByCycle;
  }
}
