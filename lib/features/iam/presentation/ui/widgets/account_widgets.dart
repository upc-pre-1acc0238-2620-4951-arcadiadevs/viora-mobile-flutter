import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/core/designsystem/component/viora_editorial.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/component/viora_underline_field.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/iam/domain/exception/auth_failure.dart';
import 'package:viora/features/iam/presentation/state/iam_ui_state.dart';
import 'package:viora/features/iam/presentation/viewmodel/iam_view_model.dart';

/// One password requirement under the field.
class PasswordRule {
  const PasswordRule(this.label, {required this.met, required this.touched});

  final String label;
  final bool met;
  final bool touched;
}

class PasswordRuleRow extends StatelessWidget {
  const PasswordRuleRow({super.key, required this.rules});

  final List<PasswordRule> rules;

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;
    return Wrap(
      spacing: 16,
      runSpacing: 4,
      children: [
        for (final rule in rules)
          Builder(
            builder: (context) {
              final failed = rule.touched && !rule.met;
              final color = rule.met
                  ? VioraColors.green800
                  : failed
                      ? errorColor
                      : VioraColors.neutral500;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VioraIcon(failed ? VioraIcons.close : VioraIcons.check, size: 14, color: color),
                  const SizedBox(width: 4),
                  Text(
                    rule.label,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}

/// Code of six digits, each on its own line. It reads the keyboard through one hidden field.
class CodeInput extends StatefulWidget {
  const CodeInput({
    super.key,
    required this.code,
    required this.onChanged,
    required this.isError,
    this.length = 6,
  });

  final String code;
  final ValueChanged<String> onChanged;
  final bool isError;
  final int length;

  @override
  State<CodeInput> createState() => _CodeInputState();
}

class _CodeInputState extends State<CodeInput> {
  late final TextEditingController _controller = TextEditingController(text: widget.code);
  final FocusNode _focus = FocusNode();

  @override
  void didUpdateWidget(CodeInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.code != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.code,
        selection: TextSelection.collapsed(offset: widget.code.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;
    final digitStyle = Theme.of(context).textTheme.displaySmall?.copyWith(
          color: widget.isError ? errorColor : VioraColors.neutral900,
        );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _focus.requestFocus,
      child: Stack(
        children: [
          // Stays below the digits with no size of its own, so taps and paste still work.
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: _controller,
                focusNode: _focus,
                autofocus: true,
                keyboardType: TextInputType.number,
                autofillHints: const [AutofillHints.oneTimeCode],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(widget.length),
                ],
                onChanged: widget.onChanged,
              ),
            ),
          ),
          Row(
            children: [
              for (var i = 0; i < widget.length; i++) ...[
                if (i > 0) const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 52,
                        child: Center(
                          child: Text(
                            i < widget.code.length ? widget.code[i] : '',
                            style: digitStyle,
                          ),
                        ),
                      ),
                      Container(
                        height: widget.isError || i == widget.code.length ? 2 : 1,
                        color: widget.isError
                            ? errorColor
                            : i == widget.code.length
                                ? VioraColors.green900
                                : VioraColors.neutral300,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class UnderlinedLink extends StatelessWidget {
  const UnderlinedLink({super.key, required this.text, required this.onTap});

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                decoration: TextDecoration.underline,
                color: onTap == null ? VioraColors.neutral500 : VioraColors.neutral900,
              ),
        ),
      ),
    );
  }
}

/// Isotype on a soft circle, for a finished step.
class IsotypeBadge extends StatelessWidget {
  const IsotypeBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: VioraColors.green200.withValues(alpha: 0.55),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: VioraIcon(VioraIcons.isotype, size: 110, color: VioraColors.green800),
      ),
    );
  }
}

/// Example of an alert, as the phone would show it.
class AlertExampleCard extends StatelessWidget {
  const AlertExampleCard({
    super.key,
    required this.meta,
    required this.body,
    required this.dotColor,
    this.elevated = false,
  });

  final String meta;
  final String body;
  final Color dotColor;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        color: VioraColors.neutral0,
        border: Border.all(color: VioraColors.neutral200),
        borderRadius: BorderRadius.circular(22),
        boxShadow: elevated
            ? const [
                BoxShadow(color: Color(0x1A121A16), offset: Offset(0, 4), blurRadius: 12),
                BoxShadow(color: Color(0x24121A16), offset: Offset(0, 1), blurRadius: 2),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox.square(
                dimension: 6,
                child: DecoratedBox(
                  decoration: ShapeDecoration(color: dotColor, shape: const CircleBorder()),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  meta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.1,
                    color: VioraColors.neutral600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(body, style: textTheme.headlineSmall?.copyWith(color: VioraColors.neutral900)),
        ],
      ),
    );
  }
}

/// The form frame of the account screens, with the back label of the platform.
class IamFormFrame extends StatelessWidget {
  const IamFormFrame({
    super.key,
    required this.children,
    this.onBack,
    this.footer = const [],
  });

  final List<Widget> children;
  final VoidCallback? onBack;
  final List<Widget> footer;

  @override
  Widget build(BuildContext context) {
    return VioraFormFrame(
      onBack: onBack,
      backLabel: MaterialLocalizations.of(context).backButtonTooltip,
      footer: footer,
      children: children,
    );
  }
}

class IamEmailField extends StatelessWidget {
  const IamEmailField({
    super.key,
    required this.state,
    this.autofocus = false,
    this.showAsError = false,
    this.error,
    this.errorAction,
  });

  final IamUiState state;
  final bool autofocus;
  final bool showAsError;
  final String? error;
  final Widget? errorAction;

  @override
  Widget build(BuildContext context) {
    return VioraUnderlineField(
      label: AppLocalizations.of(context).iamEmail,
      value: state.email,
      onChanged: context.read<IamViewModel>().onEmail,
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      autofocus: autofocus,
      showAsError: showAsError,
      error: error,
      errorAction: errorAction,
    );
  }
}

/// A failure that isn't tied to one field. The ones that are, each screen shows on its field.
class IamGeneralError extends StatelessWidget {
  const IamGeneralError(this.failure, {super.key});

  final AuthFailure? failure;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final message = switch (failure) {
      AuthOffline() => l10n.iamErrorOffline,
      AuthTooManyRequests() => l10n.iamErrorWait,
      AuthUnexpected() => l10n.iamErrorGeneric,
      PhoneRejected() => l10n.iamErrorPhone,
      _ => null,
    };
    if (message == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
      ),
    );
  }
}

/// Centered result screen: an illustration, a title and the actions at the bottom.
class IamMessageScreen extends StatelessWidget {
  const IamMessageScreen({
    super.key,
    required this.art,
    required this.eyebrow,
    required this.dotColor,
    required this.title,
    required this.body,
    required this.footer,
    this.onBack,
  });

  static TextStyle? bodyStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 15,
            height: 22 / 15,
            letterSpacing: 0,
            color: VioraColors.neutral700,
          );

  final Widget art;
  final String eyebrow;
  final Color dotColor;
  final String title;
  final Widget body;
  final List<Widget> footer;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return IamFormFrame(
      onBack: onBack,
      footer: footer,
      children: [
        Center(
          child: Column(
            children: [
              art,
              const SizedBox(height: 20),
              VioraEyebrow(eyebrow, dotColor: dotColor),
              const SizedBox(height: 10),
              VioraEditorialTitle(title, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              body,
            ],
          ),
        ),
      ],
    );
  }
}
