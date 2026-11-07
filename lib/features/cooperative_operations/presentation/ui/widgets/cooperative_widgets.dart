import 'package:flutter/material.dart';
import 'package:viora/core/designsystem/component/viora_button.dart';
import 'package:viora/core/designsystem/component/viora_circle_button.dart';
import 'package:viora/core/designsystem/component/viora_editorial.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/theme/app_theme.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';
import 'package:viora/core/designsystem/theme/typography.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';

/// The bar of G41 and G42: back on the left, the title and its subtitle centered. [notice]
/// takes the title's place for a moment, as the "Código revocado" pill.
class CooperativeTopBar extends StatelessWidget {
  const CooperativeTopBar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onBack,
    this.notice,
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;
  final String? notice;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final notice = this.notice;
    return SizedBox(
      height: Spacing.minTouchTarget,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: VioraCircleButton(
              iconAsset: VioraIcons.arrowBack,
              label: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: onBack,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 56),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: notice != null
                  ? _NoticePill(key: const ValueKey('notice'), text: notice)
                  : Column(
                      key: const ValueKey('title'),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(title, style: textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(
                          subtitle,
                          style: textTheme.bodySmall?.copyWith(color: VioraColors.neutral600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoticePill extends StatelessWidget {
  const _NoticePill({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: const ShapeDecoration(color: VioraColors.green800, shape: StadiumBorder()),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 6, 16, 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const DecoratedBox(
                decoration: ShapeDecoration(color: VioraColors.harvest400, shape: CircleBorder()),
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: VioraIcon(VioraIcons.check, size: 16, color: VioraColors.green900),
                ),
              ),
              const SizedBox(width: Spacing.xs),
              Text(text, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: VioraColors.neutral50)),
            ],
          ),
        ),
      ),
    );
  }
}

/// The dark pill with a yellow circle on its right: "Generar códigos", "Compartir por WhatsApp".
class CooperativeActionPill extends StatelessWidget {
  const CooperativeActionPill({
    super.key,
    required this.label,
    required this.iconAsset,
    required this.onPressed,
    this.loading = false,
    this.light = false,
  });

  final String label;
  final String iconAsset;

  /// The light version sits on the dark license card of G40.
  final bool light;

  /// Null disables it, greyed as in G43 · Cupo excedido.
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      onTap: enabled ? onPressed : null,
      child: Material(
        color: onPressed == null
            ? VioraColors.neutral200
            : light
                ? VioraColors.neutral50
                : VioraColors.green900,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          child: SizedBox(
            height: light ? 52 : 60,
            child: Row(
              children: [
                const SizedBox(width: Spacing.lg),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: onPressed == null
                              ? VioraColors.neutral600
                              : light
                                  ? VioraColors.neutral900
                                  : VioraColors.neutral50,
                          fontWeight: FontWeight.w400,
                          fontVariations: const [FontVariation.weight(400)],
                        ),
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
                  margin: const EdgeInsets.only(right: Spacing.xs),
                  decoration: ShapeDecoration(
                    color: onPressed == null ? VioraColors.neutral50 : VioraColors.harvest300,
                    shape: const CircleBorder(),
                  ),
                  child: Center(
                    child: loading
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: VioraColors.green900),
                          )
                        : VioraIcon(iconAsset, size: 22, color: VioraColors.green900),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A code written as the design does, wide and spaced: "COOP-4F9T".
class CodeText extends StatelessWidget {
  const CodeText(this.code, {super.key, this.color = VioraColors.neutral900});

  final String code;
  final Color color;

  @override
  Widget build(BuildContext context) => Text(
        code,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 17,
              letterSpacing: 1.6,
              color: color,
            ),
      );
}

/// The round icon button next to a code: shares it.
class ShareCodeButton extends StatelessWidget {
  const ShareCodeButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: VioraColors.neutral100,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: const SizedBox.square(
            dimension: 36,
            child: Center(child: VioraIcon(VioraIcons.share, size: 18, color: VioraColors.neutral900)),
          ),
        ),
      ),
    );
  }
}

/// The centered dialog of G42 (Revocar código, Código ya canjeado): a round icon, an editorial
/// title, a body, a summary box, the main action and a text action under it.
class CooperativeDialog extends StatelessWidget {
  const CooperativeDialog({
    super.key,
    required this.iconAsset,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.summary,
    required this.primaryLabel,
    required this.primaryColor,
    required this.onPrimary,
    required this.secondaryLabel,
    required this.onSecondary,
  });

  final String iconAsset;
  final Color iconBackground;
  final Color iconColor;

  /// Editorial text: the parts between asterisks go in italics.
  final String title;
  final String body;
  final Widget summary;
  final String primaryLabel;
  final Color primaryColor;
  final VoidCallback onPrimary;
  final String secondaryLabel;
  final VoidCallback onSecondary;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Dialog(
      backgroundColor: VioraColors.neutral0,
      insetPadding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.lg, Spacing.lg, Spacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: ShapeDecoration(color: iconBackground, shape: const CircleBorder()),
              child: SizedBox.square(dimension: 48, child: Center(child: VioraIcon(iconAsset, color: iconColor))),
            ),
            const SizedBox(height: Spacing.md),
            VioraEditorialTitle(title, fontSize: 28, lineHeight: 34),
            const SizedBox(height: Spacing.sm),
            Text(body, style: textTheme.bodyMedium?.copyWith(color: VioraColors.neutral700)),
            const SizedBox(height: Spacing.md),
            DecoratedBox(
              decoration: BoxDecoration(
                color: VioraColors.neutral100,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
                child: SizedBox(width: double.infinity, child: summary),
              ),
            ),
            const SizedBox(height: Spacing.md),
            Material(
              color: primaryColor,
              shape: const StadiumBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onPrimary,
                child: SizedBox(
                  height: 52,
                  width: double.infinity,
                  child: Center(
                    child: Text(primaryLabel, style: textTheme.titleSmall?.copyWith(color: VioraColors.neutral50)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Center(child: VioraTextButton(label: secondaryLabel, onPressed: onSecondary)),
          ],
        ),
      ),
    );
  }
}

/// A big serif number followed by a short line: "12 → 13 plazas", "80 ha de 62 libres".
class FigureLine extends StatelessWidget {
  const FigureLine({super.key, required this.figure, required this.text, this.color = VioraColors.neutral900});

  final String figure;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          figure,
          style: TextStyle(fontFamily: VioraFonts.newsreader, fontSize: 24, height: 1.1, color: color),
        ),
        const SizedBox(width: Spacing.sm),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color)),
        ),
      ],
    );
  }
}

/// What failed, and a way to try again.
class CooperativeFailureView extends StatelessWidget {
  const CooperativeFailureView({super.key, required this.failure, required this.onRetry});

  final CooperativeFailure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xl),
      child: Column(
        children: [
          Text(
            cooperativeFailureMessage(l10n, failure),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VioraColors.neutral700),
          ),
          const SizedBox(height: Spacing.md),
          VioraButton(label: l10n.commonRetry, onPressed: onRetry),
        ],
      ),
    );
  }
}

String cooperativeFailureMessage(AppLocalizations l10n, CooperativeFailure failure) => switch (failure) {
      CooperativeOffline() => l10n.cooperativeOffline,
      CooperativeNoLicense() => l10n.cooperativeNoLicense,
      CodesUnavailable() => l10n.issueUnavailable,
      CodeNotAvailable() => l10n.codesNotAvailable,
      _ => l10n.cooperativeUnexpected,
    };
