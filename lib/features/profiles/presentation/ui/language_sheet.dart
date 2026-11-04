import 'package:flutter/material.dart';
import 'package:viora/core/designsystem/component/viora_circle_button.dart';
import 'package:viora/core/designsystem/component/viora_editorial.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/core/locale/app_language.dart';
import 'package:viora/features/profiles/presentation/ui/widgets/account_widgets.dart';

/// Asks for the language of the app. Answers the chosen one, or null if the sheet is closed.
Future<AppLanguage?> showLanguageSheet(BuildContext context, AppLanguage current) {
  return showModalBottomSheet<AppLanguage>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: VioraColors.neutral100,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (context) => _LanguageSheet(current: current),
  );
}

class _LanguageSheet extends StatefulWidget {
  const _LanguageSheet({required this.current});

  final AppLanguage current;

  @override
  State<_LanguageSheet> createState() => _LanguageSheetState();
}

class _LanguageSheetState extends State<_LanguageSheet> {
  late AppLanguage _selected = widget.current;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(accountGutter, 0, accountGutter, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VioraEditorialTitle(l10n.languageSheetTitle, fontSize: 28, lineHeight: 32),
                      const SizedBox(height: 4),
                      Text(
                        l10n.languageSheetSubtitle,
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: 13,
                          color: VioraColors.neutral600,
                        ),
                      ),
                    ],
                  ),
                ),
                VioraCircleButton(
                  iconAsset: VioraIcons.close,
                  label: MaterialLocalizations.of(context).closeButtonTooltip,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Material(
              color: VioraColors.neutral0,
              borderRadius: BorderRadius.circular(28),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  _Option(
                    title: 'Español (Perú)',
                    sample: '12 345,6 kg · 14/05/2026',
                    selected: _selected == AppLanguage.spanish,
                    onTap: () => setState(() => _selected = AppLanguage.spanish),
                  ),
                  const Divider(height: 1, indent: 20, endIndent: 20, color: VioraColors.neutral200),
                  _Option(
                    title: 'English',
                    sample: '12,345.6 kg · 05/14/2026',
                    selected: _selected == AppLanguage.english,
                    onTap: () => setState(() => _selected = AppLanguage.english),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                l10n.languageSheetNote,
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  height: 14 / 12,
                  color: VioraColors.neutral600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            CheckmarkPillButton(
              // Each one is written in the language it switches to.
              label: _selected == AppLanguage.spanish ? 'Cambiar a Español' : 'Change to English',
              onPressed: () => Navigator.of(context).pop(_selected),
            ),
          ],
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.title,
    required this.sample,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String sample;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.bodyLarge?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontVariations: const [FontVariation.weight(500)],
                        color: VioraColors.neutral900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      sample,
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        color: VioraColors.neutral600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? VioraColors.green900 : null,
                  border: selected ? null : Border.all(color: VioraColors.neutral200, width: 2),
                ),
                child: selected
                    ? const Center(
                        child: CircleAvatar(radius: 5, backgroundColor: VioraColors.neutral0),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
