import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:viora/core/designsystem/component/viora_button.dart';
import 'package:viora/core/designsystem/component/viora_editorial.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/iam/presentation/ui/iam_page.dart';
import 'package:viora/features/iam/presentation/ui/onboarding_page.dart';
import 'package:viora/features/iam/presentation/ui/widgets/welcome_illustrations.dart';

/// First contact with Viora: an introduction and a plate for technical managers. The app
/// is only for them, so there's no role to choose.
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  static const path = '/welcome';

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  static const _pageTime = Duration(milliseconds: 420);
  static const _introKey = ValueKey('intro');
  static const _plateKey = ValueKey('plate');

  bool _showPlate = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PopScope(
      canPop: !_showPlate,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _showPlate = false);
      },
      child: Scaffold(
        backgroundColor: VioraColors.neutral50,
        body: SafeArea(
          child: AnimatedSwitcher(
            duration: _pageTime,
            switchInCurve: Curves.fastOutSlowIn,
            switchOutCurve: Curves.fastOutSlowIn.flipped,
            layoutBuilder: (current, previous) => Stack(
              fit: StackFit.expand,
              children: [...previous, ?current],
            ),
            transitionBuilder: _plateTransition,
            child: _showPlate
                ? _WelcomePlate(
                    key: _plateKey,
                    eyebrow: l10n.welcomePlateEyebrow,
                    dotColor: VioraColors.terracotta500,
                    title: l10n.welcomePlateTitle,
                    illustration: const ValleyPlotsIllustration(),
                    description: l10n.welcomePlateDescription,
                    descriptionInset: 12,
                    descriptionGap: 74,
                    primaryLabel: l10n.commonContinue,
                    onPrimary: () => context.push(OnboardingPage.path),
                    secondaryLabel: l10n.welcomeSkip,
                    onSecondary: () => context.push(OnboardingPage.path),
                  )
                : _WelcomePlate(
                    key: _introKey,
                    eyebrow: l10n.welcomeIntroEyebrow,
                    dotColor: VioraColors.green800,
                    title: l10n.welcomeIntroTitle,
                    illustration: const OliveBranchIllustration(),
                    description: l10n.welcomeIntroDescription,
                    descriptionGap: 42,
                    primaryLabel: l10n.welcomeStart,
                    onPrimary: () => setState(() => _showPlate = true),
                    secondaryLabel: l10n.welcomeHaveAccount,
                    onSecondary: () => context.push(IamPage.path),
                  ),
          ),
        ),
      ),
    );
  }

  /// The plates travel a quarter of the width in the direction of the step. The incoming one
  /// fades for the whole move, the outgoing one is gone by the middle of it.
  Widget _plateTransition(Widget child, Animation<double> animation) {
    final incoming = child.key == (_showPlate ? _plateKey : _introKey);
    // Forward, the second plate comes from the right and the first one leaves to the left.
    final fromRight = child.key == _plateKey;
    return AnimatedBuilder(
      animation: animation,
      child: IgnorePointer(ignoring: !incoming, child: child),
      builder: (context, child) {
        final hidden = 1 - animation.value;
        return FractionalTranslation(
          translation: Offset((fromRight ? 0.25 : -0.25) * hidden, 0),
          child: Opacity(
            opacity: incoming ? animation.value : (1 - hidden * 2).clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
    );
  }
}

class _WelcomePlate extends StatelessWidget {
  const _WelcomePlate({
    super.key,
    required this.eyebrow,
    required this.dotColor,
    required this.title,
    required this.illustration,
    required this.description,
    this.descriptionInset = 0,
    required this.descriptionGap,
    required this.primaryLabel,
    required this.onPrimary,
    required this.secondaryLabel,
    required this.onSecondary,
  });

  final String eyebrow;
  final Color dotColor;
  final String title;
  final Widget illustration;
  final String description;
  final double descriptionInset;
  final double descriptionGap;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String secondaryLabel;
  final VoidCallback onSecondary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 20),
      child: Column(
        children: [
          VioraEyebrow(eyebrow, dotColor: dotColor),
          const SizedBox(height: 13),
          VioraEditorialTitle(
            title,
            fontSize: 40,
            lineHeight: 44,
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: Center(
              // Short phones give up illustration, never the buttons.
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 300, maxHeight: 300),
                child: illustration,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: descriptionInset),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 21 / 14,
                    letterSpacing: 0,
                    color: VioraColors.neutral700,
                  ),
            ),
          ),
          SizedBox(height: descriptionGap),
          VioraButton(label: primaryLabel, onPressed: onPrimary),
          const SizedBox(height: 6),
          VioraTextButton(label: secondaryLabel, onPressed: onSecondary),
        ],
      ),
    );
  }
}
