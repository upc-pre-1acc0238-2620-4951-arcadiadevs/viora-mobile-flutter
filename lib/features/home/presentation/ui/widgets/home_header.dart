import 'package:flutter/material.dart';
import 'package:viora/core/designsystem/component/viora_avatar.dart';
import 'package:viora/core/designsystem/component/viora_circle_button.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';
import 'package:viora/core/l10n/app_localizations.dart';

/// Avatar, greeting with the organization and role («Cooperativa Olivar del Sur · técnico»),
/// and alerts bell.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.onOpenAlerts,
    required this.onOpenAccount,
    this.displayName,
    this.organizationName,
    this.hasUnreadAlerts = false,
  });

  final VoidCallback onOpenAlerts;
  final VoidCallback onOpenAccount;
  final String? displayName;
  final String? organizationName;
  final bool hasUnreadAlerts;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);
    final name = displayName?.trim() ?? '';
    final organization = organizationName;
    final subtitle = organization == null ? null : l10n.homeManagerSubtitle(organization);

    return Row(
      children: [
        Semantics(
          button: true,
          label: l10n.accountTitle,
          onTap: onOpenAccount,
          excludeSemantics: true,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onOpenAccount,
            child: VioraAvatar(name: name),
          ),
        ),
        const SizedBox(width: Spacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.isEmpty
                    ? l10n.homeGreetingAnonymous
                    : l10n.homeGreeting(name.split(' ').first),
                style: textTheme.titleMedium?.copyWith(
                  letterSpacing: 0,
                  color: VioraColors.neutral900,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    letterSpacing: 0,
                    color: VioraColors.neutral600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: Spacing.sm),
        VioraCircleButton(
          iconAsset: VioraIcons.notifications,
          label: l10n.homeAlerts,
          showBadge: hasUnreadAlerts,
          onPressed: onOpenAlerts,
        ),
      ],
    );
  }
}
