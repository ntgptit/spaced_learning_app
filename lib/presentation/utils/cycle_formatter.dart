import 'package:flutter/material.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';

class CycleFormatter {
  static CycleStudied parseCycle(String? cycleString) {
    if (cycleString == null) return CycleStudied.firstTime;

    switch (cycleString.toUpperCase()) {
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

  static IconData getIcon(CycleStudied cycle) {
    switch (cycle) {
      case CycleStudied.firstTime:
        return Icons.looks_one;
      case CycleStudied.firstReview:
        return Icons.looks_two;
      case CycleStudied.secondReview:
        return Icons.looks_3;
      case CycleStudied.thirdReview:
        return Icons.looks_4;
      case CycleStudied.moreThanThreeReviews:
        return Icons.looks_5;
    }
  }

  // Thêm phương thức mới để lấy cycle name dạng hiển thị
  static String getDisplayName(CycleStudied cycle) {
    switch (cycle) {
      case CycleStudied.firstTime:
        return 'First Cycle';
      case CycleStudied.firstReview:
        return 'First Review Cycle';
      case CycleStudied.secondReview:
        return 'Second Review Cycle';
      case CycleStudied.thirdReview:
        return 'Third Review Cycle';
      case CycleStudied.moreThanThreeReviews:
        return 'Advanced Review Cycle';
    }
  }

  // Map số cycle sang enum CycleStudied
  static CycleStudied mapNumberToCycleStudied(int number) {
    switch (number) {
      case 1:
        return CycleStudied.firstTime;
      case 2:
        return CycleStudied.firstReview;
      case 3:
        return CycleStudied.secondReview;
      case 4:
        return CycleStudied.thirdReview;
      default:
        return CycleStudied.moreThanThreeReviews;
    }
  }
}
