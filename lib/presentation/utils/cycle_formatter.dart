import 'dart:ui';

import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';

/// Tiện ích để định dạng enum CycleStudied thành chuỗi thân thiện với người dùng
class CycleFormatter {
  /// Chuyển đổi enum CycleStudied thành chuỗi thân thiện với người dùng
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

  /// Trả về mô tả chi tiết về chu kỳ học tập
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

  /// Trả về màu gợi ý cho từng chu kỳ học tập từ AppColors
  static Color getColor(CycleStudied cycle) {
    switch (cycle) {
      case CycleStudied.firstTime:
        return AppColors.infoLight; // Purple (Info)
      case CycleStudied.firstReview:
        return AppColors.successLight; // Green (Success)
      case CycleStudied.secondReview:
        return AppColors.darkOnSecondary; // Accent Green
      case CycleStudied.thirdReview:
        return AppColors.infoDark; // Lighter Purple
      case CycleStudied.moreThanThreeReviews:
        return AppColors.darkTertiary; // Purple 200
    }
  }
}
