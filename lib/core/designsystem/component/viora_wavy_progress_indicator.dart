import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Indeterminate circular progress with a wavy active arc: the arc turns, grows and
/// shrinks while its wave flows along it, and the rest of the circle is a flat
/// [trackColor] track separated by a small gap.
class VioraWavyProgressIndicator extends StatefulWidget {
  const VioraWavyProgressIndicator({
    super.key,
    required this.color,
    required this.trackColor,
    this.strokeWidth = 4,
    this.amplitude = 1.6,
    this.wavelength = 12,
  });

  final Color color;
  final Color trackColor;
  final double strokeWidth;
  final double amplitude;
  final double wavelength;

  @override
  State<VioraWavyProgressIndicator> createState() => _VioraWavyProgressIndicatorState();
}

class _VioraWavyProgressIndicatorState extends State<VioraWavyProgressIndicator>
    with SingleTickerProviderStateMixin {
  // The shortest loop that holds a whole number of every cycle in the painter.
  static const _loopMillis = 6000;

  late final AnimationController _loop;

  @override
  void initState() {
    super.initState();
    _loop = AnimationController(vsync: this, duration: const Duration(milliseconds: _loopMillis))
      ..repeat();
  }

  @override
  void dispose() {
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size.infinite,
        painter: _WavyPainter(
          loop: _loop,
          loopMillis: _loopMillis,
          color: widget.color,
          trackColor: widget.trackColor,
          strokeWidth: widget.strokeWidth,
          amplitude: widget.amplitude,
          wavelength: widget.wavelength,
        ),
      ),
    );
  }
}

class _WavyPainter extends CustomPainter {
  _WavyPainter({
    required this.loop,
    required this.loopMillis,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
    required this.amplitude,
    required this.wavelength,
  }) : super(repaint: loop);

  static const _turnMillis = 1500;
  static const _sweepMillis = 1000;
  static const _waveMillis = 1000;
  static const _minSweep = 0.1;
  static const _maxSweep = 0.72;

  final Animation<double> loop;
  final int loopMillis;
  final Color color;
  final Color trackColor;
  final double strokeWidth;
  final double amplitude;
  final double wavelength;

  @override
  void paint(Canvas canvas, Size size) {
    final millis = loop.value * loopMillis;
    final turn = (millis % _turnMillis) / _turnMillis * 360;
    final phase = (millis % _waveMillis) / _waveMillis * 2 * math.pi;
    // The sweep grows and then shrinks along the same curve.
    final sweepCycle = (millis % (_sweepMillis * 2)) / _sweepMillis;
    final sweepTime = sweepCycle <= 1 ? sweepCycle : 2 - sweepCycle;
    final sweepFraction =
        _minSweep + (_maxSweep - _minSweep) * Curves.fastOutSlowIn.transform(sweepTime);

    final radius = math.min(size.width, size.height) / 2 - strokeWidth / 2 - amplitude;
    final center = size.center(Offset.zero);
    final startDeg = turn - 90;
    final sweepDeg = sweepFraction * 360;
    // Gap between the arc and the track: one stroke width plus room for the round caps.
    final gapDeg = _degrees(strokeWidth * 2 / radius);

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final trackSweep = math.max(360 - sweepDeg - 2 * gapDeg, 0.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      _radians(startDeg + sweepDeg + gapDeg),
      _radians(trackSweep),
      false,
      stroke..color = trackColor,
    );

    // Whole waves around the circle, so the wave doesn't jump when the turn restarts,
    // as many as keep it close to the wavelength at any size.
    final wavesPerTurn = math.max((2 * math.pi * radius / wavelength).round(), 1);
    final steps = math.max((sweepDeg / 2).ceil(), 2);
    final wave = Path();
    for (var i = 0; i <= steps; i++) {
      final angle = _radians(startDeg + sweepDeg * i / steps);
      final r = radius + amplitude * math.sin(angle * wavesPerTurn + phase);
      final point = center + Offset(r * math.cos(angle), r * math.sin(angle));
      if (i == 0) {
        wave.moveTo(point.dx, point.dy);
      } else {
        wave.lineTo(point.dx, point.dy);
      }
    }
    canvas.drawPath(wave, stroke..color = color);
  }

  double _radians(double degrees) => degrees * math.pi / 180;
  double _degrees(double radians) => radians * 180 / math.pi;

  @override
  bool shouldRepaint(_WavyPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.amplitude != amplitude ||
      oldDelegate.wavelength != wavelength;
}
