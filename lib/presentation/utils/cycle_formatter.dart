import 'package:flutter/material.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';

class CycleFormatter {
  /// Convert a String to a CycleStudied enum
  static CycleStudied parseCycle(String? cycleString) {
    switch (cycleString?.toUpperCase()) {
      case 'FIRST_TIME':
        return CycleStudied.firstTime;
      case 'FIRST_REVIEW':
        return CycleStudied.firstReview;
      case 'SECOND_REVIEW':
        return CycleStudied.secondReview;
      case 'THIRD_REVIEW':
        return CycleStudied.thirdReview;
      case 'MORE_THAN_THREE_REVIEWS':
        return CycleStudied.moreThanThreeReviews;
      default:
        return CycleStudied.firstTime; // Fallback to a default value
    }
  }

  /// Format CycleStudied enum into a user-friendly string
  static String format(CycleStudied cycle) {
    switch (cycle) {
      case CycleStudied.firstTime:
        return 'First Time';
      case CycleStudied.firstReview:
        return 'First Review';
      case CycleStudied.secondReview:
        return 'Second Review';
      case CycleStudied.thirdReview:
        return 'Third Review';
      case CycleStudied.moreThanThreeReviews:
        return 'Advanced Review';
    }
  }

  /// Get detailed description for a study cycle
  static String getDescription(CycleStudied cycle) {
    switch (cycle) {
      case CycleStudied.firstTime:
        return 'Initial learning phase. Complete all 5 repetitions to move to the next cycle.';
      case CycleStudied.firstReview:
        return 'First review cycle. Reinforcing what you learned in the first cycle.';
      case CycleStudied.secondReview:
        return 'Second review cycle. Consolidating knowledge with longer intervals.';
      case CycleStudied.thirdReview:
        return 'Third review cycle. Material should be familiar at this stage.';
      case CycleStudied.moreThanThreeReviews:
        return 'Advanced review cycle. Knowledge is well-established in long-term memory.';
    }
  }

  /// Get a suggested color for each study cycle
  static Color getColor(CycleStudied cycle, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (cycle) {
      case CycleStudied.firstTime:
        return colorScheme.primary;
      case CycleStudied.firstReview:
        return colorScheme.tertiary;
      case CycleStudied.secondReview:
        return colorScheme.secondary;
      case CycleStudied.thirdReview:
        return colorScheme.primaryContainer;
      case CycleStudied.moreThanThreeReviews:
        return colorScheme.tertiaryContainer;
    }
  }
}
