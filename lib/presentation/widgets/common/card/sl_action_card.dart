// lib/presentation/widgets/common/card/sl_action_card.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/card/sl_card.dart';

class SlActionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> actions;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? backgroundColor;
  final double borderRadius;
  final SlCardType cardType;
  final bool actionsVertical;
  final MainAxisAlignment actionsAlignment;
  final CrossAxisAlignment actionsVerticalAlignment;

  const SlActionCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    required this.actions,
    this.padding = const EdgeInsets.all(AppDimens.paddingL),
    this.margin = const EdgeInsets.symmetric(vertical: AppDimens.paddingS),
    this.backgroundColor,
    this.borderRadius = AppDimens.radiusL,
    this.cardType = SlCardType.elevated,
    this.actionsVertical = false,
    this.actionsAlignment = MainAxisAlignment.end,
    this.actionsVerticalAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SlCard(
      type: cardType,
      backgroundColor: backgroundColor,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: AppDimens.spaceL),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle(
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      child: Text(title),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppDimens.spaceXS),
                      DefaultTextStyle(
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        child: Text(subtitle!),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceL),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildActions() {
    if (actionsVertical) {
      return Column(
        crossAxisAlignment: actionsVerticalAlignment,
        children: actions.asMap().entries.map((entry) {
          final int index = entry.key;
          final Widget action = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < actions.length - 1 ? AppDimens.paddingS : 0,
            ),
            child: action,
          );
        }).toList(),
      );
    }

    return Wrap(
      alignment: WrapAlignment.end,
      spacing: AppDimens.spaceS,
      runSpacing: AppDimens.spaceS,
      children: actions,
    );
  }

  // Factory constructor for actions with a title
  factory SlActionCard.withTitle({
    required String title,
    String? subtitle,
    required List<Widget> actions,
    Widget? leading,
    SlCardType cardType = SlCardType.elevated,
    Color? backgroundColor,
  }) {
    return SlActionCard(
      title: title,
      subtitle: subtitle,
      actions: actions,
      leading: leading,
      cardType: cardType,
      backgroundColor: backgroundColor,
    );
  }

  // Factory constructor for centered vertical actions
  factory SlActionCard.vertical({
    required String title,
    String? subtitle,
    required List<Widget> actions,
    Widget? leading,
    SlCardType cardType = SlCardType.elevated,
  }) {
    return SlActionCard(
      title: title,
      subtitle: subtitle,
      actions: actions,
      leading: leading,
      actionsVertical: true,
      actionsVerticalAlignment: CrossAxisAlignment.center,
      cardType: cardType,
    );
  }
}
