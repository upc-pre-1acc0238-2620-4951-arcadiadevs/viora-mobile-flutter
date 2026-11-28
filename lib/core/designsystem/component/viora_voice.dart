import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/component/viora_voice_animation.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/typography.dart';

/// The voice of Viora: the guide mark plus one italic line. Use it at most once per
/// screen, with two lines at most, and never in critical alerts.
class VioraVoice extends StatefulWidget {
  const VioraVoice({super.key, required this.text, this.markSize = 22});

  final String text;
  final double markSize;

  @override
  State<VioraVoice> createState() => _VioraVoiceState();
}

enum _Phase { writing, achieved, settling, done }

class _VioraVoiceState extends State<VioraVoice> with TickerProviderStateMixin {
  late final AnimationController _turn = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
  );
  late final AnimationController _settle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 240),
  );
  Timer? _timer;
  int _shown = 0;
  _Phase _phase = _Phase.writing;
  bool? _animated;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final animated =
        !MediaQuery.disableAnimationsOf(context) &&
        VioraVoiceAnimation.enabledOf(context);
    if (_animated != animated) {
      _animated = animated;
      if (!animated) {
        _complete();
      } else if (_phase != _Phase.done) {
        _start();
      }
    }
  }

  @override
  void didUpdateWidget(VioraVoice oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _timer?.cancel();
      _shown = 0;
      _phase = _Phase.writing;
      if (_animated == true) {
        _start();
      } else {
        _complete();
      }
    }
  }

  void _start() {
    _timer?.cancel();
    _turn.repeat();
    if (widget.text.isEmpty) {
      _achieve();
      return;
    }
    _timer = Timer.periodic(const Duration(milliseconds: 22), (timer) {
      setState(() => _shown++);
      if (_shown >= widget.text.length) {
        timer.cancel();
        _achieve();
      }
    });
  }

  void _achieve() {
    _turn.stop();
    setState(() => _phase = _Phase.achieved);
    _pulse.forward(from: 0).then((_) {
      if (!mounted || _phase != _Phase.achieved) return;
      setState(() => _phase = _Phase.settling);
      _settle.forward(from: 0).then((_) {
        if (mounted && _phase == _Phase.settling) {
          setState(() => _phase = _Phase.done);
        }
      });
    });
  }

  void _complete() {
    _timer?.cancel();
    _turn.stop();
    _pulse.stop();
    _settle.stop();
    _shown = widget.text.length;
    _phase = _Phase.done;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _turn.dispose();
    _pulse.dispose();
    _settle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = vioraNewsreaderItalic.copyWith(
      fontSize: 18,
      height: 24 / 18,
      color: VioraColors.neutral700,
    );
    final span = TextSpan(
      style: style,
      children: [
        TextSpan(text: widget.text.substring(0, _shown)),
        TextSpan(
          text: widget.text.substring(_shown),
          style: const TextStyle(color: Colors.transparent),
        ),
      ],
    );
    return Semantics(
      label: widget.text,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _phase == _Phase.done ? null : () => setState(_complete),
        child: ExcludeSemantics(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _mark(),
              const SizedBox(width: 10),
              Expanded(
                child: CustomPaint(
                  foregroundPainter: _phase == _Phase.writing
                      ? _CursorPainter(
                          span,
                          _shown,
                          Directionality.of(context),
                          MediaQuery.textScalerOf(context),
                        )
                      : null,
                  child: Text.rich(
                    span,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mark() => AnimatedBuilder(
    animation: Listenable.merge([_turn, _pulse, _settle]),
    builder: (context, child) {
      final writing = _phase == _Phase.writing;
      final settling = _phase == _Phase.settling;
      final done = _phase == _Phase.done;
      final progress = done ? 1.0 : (settling ? _settle.value : 0.0);
      final pulse = _phase == _Phase.achieved
          ? 1 + 0.12 * (1 - (2 * _pulse.value - 1).abs())
          : 1.0;
      final asset = writing
          ? (_turn.value * 1600 ~/ 220).isOdd
                ? VioraIcons.brotePensando
                : VioraIcons.broteReposo
          : VioraIcons.broteLogro;
      return SizedBox(
        width: widget.markSize,
        height: widget.markSize,
        child: Stack(
          children: [
            if (!done)
              Opacity(
                opacity: 1 - progress,
                child: Transform.rotate(
                  angle: writing ? _turn.value * math.pi / 2 : 0,
                  child: Transform.scale(
                    scale: pulse,
                    child: SvgPicture.asset(
                      asset,
                      width: widget.markSize,
                      height: widget.markSize,
                    ),
                  ),
                ),
              ),
            if (settling || done)
              Opacity(
                opacity: progress,
                child: Transform.scale(
                  scale: 0.8 + 0.2 * progress,
                  child: SvgPicture.asset(
                    VioraIcons.isotype,
                    width: widget.markSize,
                    height: widget.markSize,
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}

class _CursorPainter extends CustomPainter {
  _CursorPainter(this.text, this.offset, this.direction, this.scaler);
  final TextSpan text;
  final int offset;
  final TextDirection direction;
  final TextScaler scaler;

  @override
  void paint(Canvas canvas, Size size) {
    final painter = TextPainter(
      text: text,
      textDirection: direction,
      textScaler: scaler,
      maxLines: 2,
      ellipsis: '…',
    )..layout(maxWidth: size.width);
    final position = painter.getOffsetForCaret(
      TextPosition(offset: offset),
      Rect.zero,
    );
    final height =
        painter.getFullHeightForCaret(
          TextPosition(offset: offset),
          Rect.zero,
        );
    if (position.dy < size.height) {
      canvas.drawRect(
        Rect.fromLTWH(position.dx + 1, position.dy + 3, 2, height - 6),
        Paint()..color = VioraColors.terracotta500,
      );
    }
    painter.dispose();
  }

  @override
  bool shouldRepaint(_CursorPainter oldDelegate) =>
      oldDelegate.offset != offset ||
      oldDelegate.text != text ||
      oldDelegate.direction != direction ||
      oldDelegate.scaler != scaler;
}
