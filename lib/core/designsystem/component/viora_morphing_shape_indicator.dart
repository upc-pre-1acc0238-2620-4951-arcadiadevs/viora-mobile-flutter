import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:material_new_shapes/material_new_shapes.dart';

/// Shapes of the Material 3 expressive shape library, normalized into the unit square.
abstract final class VioraMorphingShapes {
  static final softBurst = RoundedPolygon.star(
    numVerticesPerRadius: 10,
    innerRadius: 0.72,
    rounding: const CornerRounding(radius: 0.24),
  ).normalized();
  static final cookie9 = RoundedPolygon.star(
    numVerticesPerRadius: 9,
    innerRadius: 0.8,
    rounding: const CornerRounding(radius: 0.5),
  ).normalized();
  static final pentagon = RoundedPolygon.fromVerticesNum(
    5,
    rounding: const CornerRounding(radius: 0.32),
  ).normalized();
  static final pill = RoundedPolygon.pill(width: 2, height: 1.3)
      .transformed((Matrix4.identity()..rotateZ(-math.pi / 4)).asPointTransformer())
      .normalized();
  static final sunny = RoundedPolygon.star(
    numVerticesPerRadius: 8,
    innerRadius: 0.8,
    rounding: const CornerRounding(radius: 0.15),
  ).normalized();
  static final cookie4 = RoundedPolygon.star(
    numVerticesPerRadius: 4,
    innerRadius: 0.7,
    rounding: const CornerRounding(radius: 0.42),
  ).normalized();
  static final oval = RoundedPolygon.circle()
      .transformed(
        (Matrix4.identity()
              ..rotateZ(-math.pi / 4)
              ..scaleByDouble(1, 0.64, 1, 1))
            .asPointTransformer(),
      )
      .normalized();
  static final circle = RoundedPolygon.circle().normalized();

  /// The order the loading indicator walks through.
  static final loading = [softBurst, cookie9, pentagon, pill, sunny, cookie4, oval];
}

/// Material 3 expressive loading indicator: a filled shape that keeps morphing into the
/// next one while it turns. Each morph rides a bouncy spring and adds a quarter turn, on
/// top of a slow constant spin.
///
/// When [settle] becomes true the current morph ends in a circle and the indicator stops
/// there; [onSettled] runs once the circle is complete, so a screen can continue from it.
class VioraMorphingShapeIndicator extends StatefulWidget {
  const VioraMorphingShapeIndicator({
    super.key,
    required this.color,
    this.settle = false,
    this.onSettled,
  });

  final Color color;
  final bool settle;
  final VoidCallback? onSettled;

  @override
  State<VioraMorphingShapeIndicator> createState() => _VioraMorphingShapeIndicatorState();
}

class _VioraMorphingShapeIndicatorState extends State<VioraMorphingShapeIndicator>
    with TickerProviderStateMixin {
  static const _morphMillis = 650;
  static const _settleMillis = 450;
  static const _spinMillis = 4666;
  static final _spring = SpringDescription.withDampingRatio(mass: 1, stiffness: 200, ratio: 0.6);
  static const _tolerance = Tolerance(distance: 0.01, velocity: 0.01);

  final List<RoundedPolygon> _shapes = VioraMorphingShapes.loading;
  late final List<Morph> _morphs = [
    for (var i = 0; i < _shapes.length; i++) Morph(_shapes[i], _shapes[(i + 1) % _shapes.length]),
  ];
  late final List<Morph> _toCircle = [
    for (final shape in _shapes) Morph(shape, VioraMorphingShapes.circle),
  ];

  late final AnimationController _spin;
  late final AnimationController _progress;
  late final AnimationController _stepTurn;
  final _morphState = _MorphState();
  double _turnTarget = 0;
  bool _settling = false;
  Timer? _stepTimer;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(vsync: this, duration: const Duration(milliseconds: _spinMillis))
      ..repeat();
    _progress = AnimationController.unbounded(vsync: this);
    _stepTurn = AnimationController.unbounded(vsync: this);
    _morphState.morph = _morphs.first;
    unawaited(_run());
  }

  Future<void> _run() async {
    var index = 0;
    try {
      while (mounted) {
        if (widget.settle) _settling = true;
        _morphState.morph = _settling ? _toCircle[index] : _morphs[index];
        _progress.value = 0;
        _turnTarget += 90;
        final delay = Completer<void>();
        _stepTimer = Timer(
          Duration(milliseconds: _settling ? _settleMillis : _morphMillis),
          delay.complete,
        );
        // A step ends when both springs have landed and its minimum time has passed.
        await Future.wait([
          _progress.animateWith(_springTo(_progress, 1)).orCancel,
          _stepTurn.animateWith(_springTo(_stepTurn, _turnTarget)).orCancel,
          delay.future,
        ]);
        if (!mounted) return;
        if (_settling) {
          widget.onSettled?.call();
          return;
        }
        index = (index + 1) % _shapes.length;
      }
    } on TickerCanceled {
      // The indicator left the tree while a step was running.
    }
  }

  SpringSimulation _springTo(AnimationController controller, double target) => SpringSimulation(
        _spring,
        controller.value,
        target,
        controller.velocity,
        tolerance: _tolerance,
      );

  @override
  void dispose() {
    _stepTimer?.cancel();
    _spin.dispose();
    _progress.dispose();
    _stepTurn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size.infinite,
        painter: _MorphPainter(
          color: widget.color,
          morphState: _morphState,
          spin: _spin,
          progress: _progress,
          stepTurn: _stepTurn,
        ),
      ),
    );
  }
}

/// The morph being drawn; it changes on every step, not on every frame.
class _MorphState {
  late Morph morph;
}

class _MorphPainter extends CustomPainter {
  _MorphPainter({
    required this.color,
    required this.morphState,
    required this.spin,
    required this.progress,
    required this.stepTurn,
  }) : super(repaint: Listenable.merge([spin, progress, stepTurn]));

  final Color color;
  final _MorphState morphState;
  final Animation<double> spin;
  final Animation<double> progress;
  final Animation<double> stepTurn;

  @override
  void paint(Canvas canvas, Size size) {
    final side = math.min(size.width, size.height);
    final degrees = spin.value * 360 + stepTurn.value;
    final path = morphState.morph.toPath(progress: progress.value);

    canvas
      ..save()
      ..translate(size.width / 2, size.height / 2)
      ..rotate(degrees * math.pi / 180)
      ..translate(-side / 2, -side / 2)
      ..scale(side);
    canvas.drawPath(path, Paint()..color = color);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_MorphPainter oldDelegate) => oldDelegate.color != color;
}
