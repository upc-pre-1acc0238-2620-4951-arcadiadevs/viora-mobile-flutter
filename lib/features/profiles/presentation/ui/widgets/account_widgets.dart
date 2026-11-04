import 'package:flutter/material.dart';
import 'package:viora/core/designsystem/component/viora_circle_button.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/theme/colors.dart';

/// Horizontal margin of the account screens.
const accountGutter = 24.0;

/// Top bar of the account screens: round back or close button and a centered title over a
/// subtitle, or [notice] in their place.
class AccountTopBar extends StatelessWidget {
  const AccountTopBar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onBack,
    this.isClose = false,
    this.notice,
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;
  final bool isClose;
  final String? notice;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final materialLabels = MaterialLocalizations.of(context);
    final notice = this.notice;
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: VioraCircleButton(
            iconAsset: isClose ? VioraIcons.close : VioraIcons.arrowBack,
            label: isClose ? materialLabels.closeButtonTooltip : materialLabels.backButtonTooltip,
            onPressed: onBack,
          ),
        ),
        if (notice != null)
          _Notice(text: notice)
        else
          Column(
            children: [
              Text(title, style: textTheme.titleSmall?.copyWith(fontSize: 15, height: 20 / 15)),
              Text(
                subtitle,
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  height: 16 / 12,
                  color: VioraColors.neutral600,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 6, 14, 6),
      decoration: const ShapeDecoration(color: VioraColors.green800, shape: StadiumBorder()),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 14,
            backgroundColor: VioraColors.harvest400,
            child: VioraIcon(VioraIcons.check, size: 16, color: VioraColors.neutral900),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 13,
                  color: VioraColors.neutral0,
                ),
          ),
        ],
      ),
    );
  }
}

/// A group of rows: the spaced capitals over a white card.
class AccountSection extends StatelessWidget {
  const AccountSection({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 11,
                  letterSpacing: 1.1,
                  color: VioraColors.neutral600,
                ),
          ),
        ),
        const SizedBox(height: 9),
        Material(
          color: VioraColors.neutral0,
          borderRadius: BorderRadius.circular(28),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (index, child) in children.indexed) ...[
                if (index > 0)
                  const Divider(height: 1, indent: 20, endIndent: 16, color: VioraColors.neutral200),
                child,
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// One row of a section: label, value and chevron. A destructive row has no chevron.
class AccountRow extends StatelessWidget {
  const AccountRow({
    super.key,
    required this.label,
    required this.onTap,
    this.value,
    this.destructive = false,
  });

  final String label;
  final String? value;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final value = this.value;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 17, 16, 17),
        child: Row(
          children: [
            Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                height: 20 / 14,
                fontWeight: destructive ? FontWeight.w500 : FontWeight.w400,
                fontVariations: [FontVariation.weight(destructive ? 500 : 400)],
                color: destructive ? VioraColors.terracotta700 : VioraColors.neutral900,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: value == null
                  ? const SizedBox.shrink()
                  : Text(
                      value,
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 13,
                        height: 20 / 13,
                        color: VioraColors.neutral600,
                      ),
                    ),
            ),
            if (!destructive) ...[
              const SizedBox(width: 8),
              const VioraIcon(VioraIcons.chevronRight, size: 20, color: VioraColors.neutral500),
            ],
          ],
        ),
      ),
    );
  }
}

/// The white field card of the account forms: a small label over the value, an optional eye
/// for secrets, and under it a helper or an error with the warning icon.
class ValidatedFieldCard extends StatefulWidget {
  const ValidatedFieldCard({
    super.key,
    required this.label,
    required this.value,
    this.onChanged,
    this.placeholder,
    this.helper,
    this.error,
    this.secret = false,
    this.revealLabel,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
  });

  final String label;
  final String value;

  /// Null makes the field read-only.
  final ValueChanged<String>? onChanged;
  final String? placeholder;
  final String? helper;
  final String? error;
  final bool secret;
  final String? revealLabel;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final VoidCallback? onSubmitted;

  @override
  State<ValidatedFieldCard> createState() => _ValidatedFieldCardState();
}

class _ValidatedFieldCardState extends State<ValidatedFieldCard> {
  late final _controller = TextEditingController(text: widget.value);
  final _focus = FocusNode();
  bool _revealed = false;

  @override
  void didUpdateWidget(ValidatedFieldCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The state may change the text by itself: a filter, or the profile that just loaded.
    if (widget.value != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
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
    final textTheme = Theme.of(context).textTheme;
    final error = widget.error;
    final isError = error != null;
    final readOnly = widget.onChanged == null;
    final textColor = isError
        ? VioraColors.terracotta700
        : readOnly
            ? VioraColors.neutral600
            : VioraColors.neutral900;
    final inputStyle = textTheme.bodyLarge?.copyWith(
      fontSize: 15,
      height: 22 / 15,
      letterSpacing: 0,
      color: textColor,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: readOnly ? null : _focus.requestFocus,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(18, 12, widget.secret ? 6 : 18, 12),
            decoration: BoxDecoration(
              color: VioraColors.neutral0,
              borderRadius: BorderRadius.circular(24),
              border: isError
                  ? Border.all(color: VioraColors.terracotta500, width: 1.5)
                  : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.label,
                        style: textTheme.labelMedium?.copyWith(
                          fontSize: 12,
                          height: 16 / 12,
                          color: isError ? VioraColors.terracotta700 : VioraColors.neutral600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      TextField(
                        controller: _controller,
                        focusNode: _focus,
                        readOnly: readOnly,
                        obscureText: widget.secret && !_revealed,
                        autocorrect: false,
                        enableSuggestions: !widget.secret,
                        keyboardType: widget.keyboardType,
                        textCapitalization: widget.textCapitalization,
                        textInputAction: widget.textInputAction,
                        onChanged: widget.onChanged,
                        onSubmitted: (_) => widget.onSubmitted?.call(),
                        // Keeps what's under the field in sight over the keyboard.
                        scrollPadding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
                        cursorColor: VioraColors.green900,
                        style: inputStyle,
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          hintText: widget.placeholder,
                          hintStyle: inputStyle?.copyWith(color: VioraColors.neutral500),
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.secret)
                  IconButton(
                    tooltip: widget.revealLabel,
                    onPressed: () => setState(() => _revealed = !_revealed),
                    icon: const VioraIcon(
                      VioraIcons.visibility,
                      size: 22,
                      color: VioraColors.neutral500,
                    ),
                  ),
              ],
            ),
          ),
        ),
        FieldNote(text: error ?? widget.helper, isError: isError),
      ],
    );
  }
}

/// The line under a field: the helper in grey, or the error with the warning icon.
class FieldNote extends StatelessWidget {
  const FieldNote({super.key, required this.text, this.isError = false});

  final String? text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final text = this.text;
    if (text == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          if (isError) ...[
            const VioraIcon(VioraIcons.warning, size: 14, color: VioraColors.terracotta500),
            const SizedBox(width: 6),
          ],
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    height: 14 / 12,
                    color: isError ? VioraColors.terracotta700 : VioraColors.neutral600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The 60 dp dark pill with the yellow check; disabled it turns grey.
class CheckmarkPillButton extends StatelessWidget {
  const CheckmarkPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;

  /// Null disables the button.
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final active = onPressed != null || loading;
    return Material(
      color: active ? VioraColors.green900 : VioraColors.neutral200,
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: loading ? null : onPressed,
        child: SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 8, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 15,
                          height: 20 / 15,
                          color: active ? VioraColors.neutral50 : VioraColors.neutral500,
                        ),
                  ),
                ),
                CircleAvatar(
                  radius: 22,
                  backgroundColor: active ? VioraColors.harvest300 : VioraColors.neutral100,
                  child: loading
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: VioraColors.neutral900,
                          ),
                        )
                      : const VioraIcon(VioraIcons.check, size: 20, color: VioraColors.neutral900),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
