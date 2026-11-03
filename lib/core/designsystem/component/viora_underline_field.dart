import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:viora/core/designsystem/theme/colors.dart';

/// Text field with a label above and a single line below. With [secret] it hides the text
/// and offers a [revealLabel] / [hideLabel] action.
class VioraUnderlineField extends StatefulWidget {
  const VioraUnderlineField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.error,
    this.showAsError = false,
    this.supporting,
    this.secret = false,
    this.revealLabel,
    this.hideLabel,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.autofocus = false,
    this.autofillHints,
    this.onSubmitted,
    this.errorAction,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final String? error;

  /// Marks the field as wrong without a message of its own.
  final bool showAsError;
  final String? supporting;
  final bool secret;
  final String? revealLabel;
  final String? hideLabel;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final Iterable<String>? autofillHints;
  final VoidCallback? onSubmitted;

  /// Tappable part after the error message.
  final Widget? errorAction;

  @override
  State<VioraUnderlineField> createState() => _VioraUnderlineFieldState();
}

class _VioraUnderlineFieldState extends State<VioraUnderlineField> {
  late final TextEditingController _controller = TextEditingController(text: widget.value);
  final FocusNode _focus = FocusNode();
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(VioraUnderlineField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The state may change the text by itself: a filter, or answers restored from disk.
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
    final errorColor = Theme.of(context).colorScheme.error;
    final isError = widget.error != null || widget.showAsError;
    final lineColor = isError
        ? errorColor
        : _focus.hasFocus
            ? VioraColors.green900
            : VioraColors.neutral300;
    final inputStyle = textTheme.bodyLarge?.copyWith(
      fontSize: 20,
      height: 28 / 20,
      letterSpacing: 0,
      color: VioraColors.neutral900,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The label belongs to the field: on a short screen it may be the only part in sight.
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _focus.requestFocus,
          child: SizedBox(
            width: double.infinity,
            child: Text(
              widget.label,
              style: textTheme.labelMedium?.copyWith(
                color: isError ? errorColor : VioraColors.neutral600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focus,
                autofocus: widget.autofocus,
                obscureText: widget.secret && !_revealed,
                autocorrect: false,
                enableSuggestions: !widget.secret,
                keyboardType: widget.keyboardType,
                textInputAction: widget.textInputAction,
                textCapitalization: widget.textCapitalization,
                inputFormatters: widget.inputFormatters,
                autofillHints: widget.autofillHints,
                onChanged: widget.onChanged,
                onSubmitted: (_) => widget.onSubmitted?.call(),
                // Also keeps what's under the line in sight over the keyboard: rules or errors.
                scrollPadding: const EdgeInsets.fromLTRB(20, 20, 20, 72),
                cursorColor: VioraColors.green900,
                style: inputStyle,
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 6),
                ),
              ),
            ),
            if (widget.secret)
              TextButton(
                onPressed: () => setState(() => _revealed = !_revealed),
                style: TextButton.styleFrom(
                  foregroundColor: VioraColors.neutral900,
                  minimumSize: const Size(44, 40),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  textStyle: textTheme.labelLarge,
                ),
                child: Text((_revealed ? widget.hideLabel : widget.revealLabel) ?? ''),
              ),
          ],
        ),
        Container(height: _focus.hasFocus || isError ? 1.5 : 1, color: lineColor),
        if (widget.error != null) ...[
          const SizedBox(height: 4),
          Text(widget.error!, style: textTheme.bodySmall?.copyWith(color: errorColor)),
          ?widget.errorAction,
        ] else if (widget.supporting != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.supporting!,
            style: textTheme.bodySmall?.copyWith(
              fontSize: 13,
              height: 18 / 13,
              color: VioraColors.neutral600,
            ),
          ),
        ],
      ],
    );
  }
}
