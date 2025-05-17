// lib/presentation/widgets/common/dialog/sl_dialog_button_bar.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

/// A widget that arranges dialog action buttons according to Material 3 guidelines.
/// It enforces the "no else" rule by handling button presence declaratively.
class SlDialogButtonBar extends StatelessWidget {
  final Widget? confirmButton;
  final Widget? cancelButton;
  final Widget? neutralButton; // Optional third button (e.g., "Learn More")
  final MainAxisAlignment alignment;
  final double spacing;

  const SlDialogButtonBar({
    super.key,
    this.confirmButton,
    this.cancelButton,
    this.neutralButton,
    this.alignment = MainAxisAlignment.end,
    this.spacing = AppDimens.spaceS,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> buttons = [];

    if (neutralButton != null) {
      buttons.add(neutralButton!);
    }
    // Spacer if neutral and other buttons exist
    if (neutralButton != null &&
        (cancelButton != null || confirmButton != null)) {
      buttons.add(const Spacer());
    }

    if (cancelButton != null) {
      buttons.add(cancelButton!);
    }

    if (confirmButton != null) {
      // Add spacing if cancel button is also present
      if (cancelButton != null) {
        buttons.add(SizedBox(width: spacing));
      }
      buttons.add(confirmButton!);
    }

    if (buttons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: AppDimens.paddingM),
      child: Row(mainAxisAlignment: alignment, children: buttons),
    );
  }
}
