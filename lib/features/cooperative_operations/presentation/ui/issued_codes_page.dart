import 'package:flutter/material.dart';
import 'package:viora/core/designsystem/component/viora_button.dart';
import 'package:viora/core/designsystem/component/viora_card.dart';
import 'package:viora/core/designsystem/component/viora_circle_button.dart';
import 'package:viora/core/designsystem/component/viora_editorial.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/component/viora_status_tag.dart';
import 'package:viora/core/designsystem/component/viora_voice.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/cooperative_operations/domain/entity/invitation_code.dart';
import 'package:viora/features/cooperative_operations/presentation/cooperative_formats.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/widgets/cooperative_widgets.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/widgets/share_codes.dart';

/// What G44 needs: the codes just issued and who they are from.
class IssuedCodesArgs {
  const IssuedCodesArgs({required this.issued, required this.organizationName});

  final IssuedCodes issued;
  final String organizationName;
}

/// G44 · Códigos generados: the new codes, ready to copy or send. Sending happens outside Viora.
class IssuedCodesPage extends StatelessWidget {
  const IssuedCodesPage({super.key, required this.args, required this.onClose, required this.onSeeAll});

  final IssuedCodesArgs args;
  final VoidCallback onClose;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final issued = args.issued;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.sm, Spacing.lg, Spacing.lg),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: VioraCircleButton(
                iconAsset: VioraIcons.close,
                label: MaterialLocalizations.of(context).closeButtonTooltip,
                onPressed: onClose,
              ),
            ),
            const SizedBox(height: Spacing.lg),
            VioraEditorialTitle(l10n.issuedHeadline(issued.codes.length), fontSize: 44, lineHeight: 46),
            const SizedBox(height: Spacing.sm),
            VioraVoice(text: l10n.issuedVoice(formatHectares(issued.hectaresPerCode, locale))),
            const SizedBox(height: Spacing.md),
            VioraCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.codesIssuedOn(formatDayMonth(issued.issuedAt, locale)),
                          style: textTheme.titleSmall,
                        ),
                      ),
                      VioraStatusTag(
                        label: l10n.issuedExpire(formatDayMonth(issued.expiresAt, locale)),
                        tone: VioraTagTone.info,
                      ),
                    ],
                  ),
                  for (final code in issued.codes) ...[
                    const Divider(height: Spacing.lg, color: VioraColors.neutral200),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CodeText(code),
                              Text(
                                l10n.codesPerCode(formatHectares(issued.hectaresPerCode, locale)),
                                style: textTheme.bodySmall?.copyWith(color: VioraColors.neutral600),
                              ),
                            ],
                          ),
                        ),
                        ShareCodeButton(
                          label: l10n.codesShare,
                          onPressed: () => shareCodesOnWhatsapp(
                            context,
                            organizationName: args.organizationName,
                            codes: [code],
                            expiresAt: issued.expiresAt,
                          ),
                        ),
                        VioraTextButton(label: l10n.issuedCopy, onPressed: () => copyCode(context, code)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: Spacing.md),
            CooperativeActionPill(
              label: l10n.issuedShareWhatsapp,
              iconAsset: VioraIcons.chat,
              onPressed: () => shareCodesOnWhatsapp(
                context,
                organizationName: args.organizationName,
                codes: issued.codes,
                expiresAt: issued.expiresAt,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Center(child: VioraTextButton(label: l10n.issuedSeeAll, onPressed: onSeeAll)),
          ],
        ),
      ),
    );
  }
}
