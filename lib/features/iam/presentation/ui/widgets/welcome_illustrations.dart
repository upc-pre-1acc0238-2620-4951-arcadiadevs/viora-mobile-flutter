import 'dart:math' as math;
import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:viora/core/designsystem/theme/colors.dart';

// The two welcome drawings. They are painted on a canvas instead of shown as static images so
// each stroke can be traced on entry and then keep a slow, barely-there sway.

/// An olive branch whose stem, leaves and olives are drawn in sequence.
class OliveBranchIllustration extends StatelessWidget {
  const OliveBranchIllustration({super.key});

  @override
  Widget build(BuildContext context) => const _Illustration(paint: _paintBranch);
}

/// Four plots of the valley drawn one by one, then the route of a visit that ends on a pin.
class ValleyPlotsIllustration extends StatelessWidget {
  const ValleyPlotsIllustration({super.key});

  @override
  Widget build(BuildContext context) => const _Illustration(paint: _paintPlots);
}

typedef _Painting = void Function(Canvas canvas, _Motion motion);

/// Runs the clock of a drawing. With animations turned off on the phone it stays on the
/// finished drawing.
class _Illustration extends StatefulWidget {
  const _Illustration({required this.paint});

  final _Painting paint;

  @override
  State<_Illustration> createState() => _IllustrationState();
}

class _IllustrationState extends State<_Illustration> with SingleTickerProviderStateMixin {
  final _motion = ValueNotifier(_Motion.finished);
  late final Ticker _ticker = createTicker((elapsed) => _motion.value = _Motion.at(elapsed));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _ticker.stop();
      _motion.value = _Motion.finished;
    } else if (!_ticker.isActive) {
      _motion.value = _Motion.start;
      _ticker.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(painter: _IllustrationPainter(widget.paint, _motion)),
    );
  }
}

class _IllustrationPainter extends CustomPainter {
  _IllustrationPainter(this.painting, this.motion) : super(repaint: motion);

  final _Painting painting;
  final ValueNotifier<_Motion> motion;

  @override
  void paint(Canvas canvas, Size size) {
    // The paths use a 300 × 300 viewport.
    final scale = size.shortestSide / _viewport;
    canvas.scale(scale);
    painting(canvas, motion.value);
  }

  @override
  bool shouldRepaint(_IllustrationPainter oldDelegate) => oldDelegate.painting != painting;
}

/// Everything that moves in a drawing at one moment, all of it derived from the elapsed time.
class _Motion {
  const _Motion({
    required this.intro,
    required this.breath,
    required this.sway,
    required this.flutter,
    required this.glow,
  });

  factory _Motion.at(Duration elapsed) {
    final millis = elapsed.inMilliseconds;
    return _Motion(
      intro: (millis / _introMillis).clamp(0.0, 1.0),
      breath: _wave(millis, _breathMillis),
      sway: _wave(millis, _swayMillis),
      flutter: (millis % _flutterMillis) / _flutterMillis,
      glow: _wave(millis, _glowMillis),
    );
  }

  static const start = _Motion(intro: 0, breath: 0, sway: 0, flutter: 0, glow: 0);
  static const finished = _Motion(intro: 1, breath: 0, sway: 0.5, flutter: 0, glow: 0);

  /// Progress of the drawing on entry, linear from 0 to 1.
  final double intro;

  /// Slow waves that go 0 → 1 → 0, eased, forever.
  final double breath;
  final double sway;
  final double glow;

  /// Phase from 0 to 1 for sine motions, forever.
  final double flutter;

  double get swayAngle => (sway - 0.5) * 2.4;

  double swing(double offset, double degrees) =>
      math.sin((flutter + offset) * 2 * math.pi) * degrees;

  static double _wave(int millis, int period) {
    final phase = (millis % period) / period;
    return Curves.fastOutSlowIn.transform(phase < 0.5 ? phase * 2 : 2 - phase * 2);
  }
}

// ---- Olive branch ------------------------------------------------------------------------

void _paintBranch(Canvas canvas, _Motion motion) {
  final t = motion.intro;
  final paths = _branch;
  _drawBlob(
    canvas,
    paths.blob,
    color: VioraColors.green200.withValues(alpha: 0.75),
    appear: _phase(t, 0, 0.35),
    breath: motion.breath,
  );
  // The whole branch sways from where it enters the frame.
  _rotated(canvas, motion.swayAngle, _branchPivot, () {
    _drawTraced(canvas, paths.stem, _phase(t, 0.08, 0.55), 1.6);
    for (final (i, leaf) in paths.leaves.indexed) {
      final grow = _phase(t, 0.2 + i * 0.055, 0.45 + i * 0.055);
      if (grow <= 0) continue;
      _rotated(canvas, motion.swing(i * 0.13, 2.5), leaf.base, () {
        _scaled(canvas, 0.6 + 0.4 * grow, leaf.base, () {
          _drawTraced(canvas, leaf.outline, grow, 1.6);
          _drawTraced(canvas, leaf.midrib, _phase(grow, 0.4, 1), 1);
        });
      });
    }
    for (final (i, olive) in paths.olives.indexed) {
      final pop = _phase(t, 0.68 + i * 0.08, 0.9 + i * 0.04);
      if (pop <= 0) continue;
      _rotated(canvas, motion.swing(0.3 + i * 0.21, 4), olive.stalkTop, () {
        _drawTraced(canvas, olive.stalk, _phase(pop, 0, 0.5), 1.2);
        _scaled(canvas, _overshoot.transform(_phase(pop, 0.3, 1)), olive.stalkEnd, () {
          final fill = olive.fill;
          canvas.drawPath(
            olive.body,
            fill != null ? (Paint()..color = fill) : _line(1.6),
          );
        });
      });
    }
  });
}

const _branchPivot = Offset(40, 270);

final _branch = _BranchPaths();

class _BranchPaths {
  final blob = parseSvgPathData(
    'M140 48C205 30 262 78 258 148C254 222 200 266 136 258C74 250 38 206 42 146C46 90 82 62 140 48Z',
  );
  final stem = _TracedPath('M40 270C100 214 172 138 250 66');
  final leaves = [
    _Leaf(
      'M91.12 220.2C82.1426 209.598 79.2253 193.053 84.1741 180.808C93.0126 190.622 95.9299 207.167 91.12 220.2Z',
      'M90.7727 218.23L85.5633 188.686',
      const Offset(91.12, 220.2),
    ),
    _Leaf(
      'M106.8 205C119.242 200.086 134.96 202.857 144.223 211.599C132.529 216.645 116.811 213.873 106.8 205Z',
      'M108.77 205.347L136.738 210.279',
      const Offset(106.8, 205),
    ),
    _Leaf(
      'M130.32 182.2C119.364 171.327 114.894 153.396 119.675 139.507C130.418 149.526 134.889 167.457 130.32 182.2Z',
      'M129.836 180.259L121.804 148.046',
      const Offset(130.32, 182.2),
    ),
    _Leaf(
      'M146 167C159.367 160.361 176.911 162.205 187.77 171.39C175.238 178.117 157.695 176.273 146 167Z',
      'M147.989 167.209L179.416 170.512',
      const Offset(146, 167),
    ),
    _Leaf(
      'M169.52 144.2C160.918 133.291 158.58 116.654 163.953 104.589C172.444 114.706 174.782 131.343 169.52 144.2Z',
      'M169.242 142.219L165.066 112.511',
      const Offset(169.52, 144.2),
    ),
    _Leaf(
      'M185.2 129C198.537 125.111 214.838 129.175 224.012 138.677C211.451 142.759 195.15 138.695 185.2 129Z',
      'M187.141 129.484L216.249 136.741',
      const Offset(185.2, 129),
    ),
    _Leaf(
      'M208.72 106.2C202.72 96 202.72 81.72 208.72 72.2C214.72 81.72 214.72 96 208.72 106.2Z',
      'M208.72 104.2V79',
      const Offset(208.72, 106.2),
    ),
    _Leaf(
      'M224.4 91C235.473 88.6452 248.103 93.242 254.47 101.945C243.998 104.518 231.369 99.9216 224.4 91Z',
      'M226.279 91.684L248.456 99.7557',
      const Offset(224.4, 91),
    ),
  ];
  final olives = [
    _HangingOlive(
      'M83.28 227.8L79.98 238.8',
      'M73.6888 257.667C77.8406 259.178 82.8142 255.985 84.7975 250.536C86.7809 245.087 85.023 239.444 80.8712 237.933C76.7194 236.422 71.7458 239.615 69.7625 245.064C67.7791 250.513 69.537 256.156 73.6888 257.667Z',
      stalkTop: const Offset(83.28, 227.8),
      stalkEnd: const Offset(79.98, 238.8),
      fill: VioraColors.forest,
    ),
    _HangingOlive(
      'M157.76 155.6L164.36 165.5',
      'M173.351 183.467C177.503 181.956 179.261 176.313 177.278 170.864C175.294 165.415 170.321 162.222 166.169 163.733C162.017 165.244 160.259 170.887 162.242 176.336C164.226 181.785 169.199 184.978 173.351 183.467Z',
      stalkTop: const Offset(157.76, 155.6),
      stalkEnd: const Offset(164.36, 165.5),
      fill: VioraColors.terracotta500,
    ),
    _HangingOlive(
      'M216.56 98.6L224.26 107.4',
      'M237.81 111.219C240.261 116.475 239.002 122.249 234.997 124.116C230.993 125.983 225.76 123.237 223.31 117.981C220.859 112.725 222.118 106.951 226.123 105.084C230.127 103.217 235.36 105.963 237.81 111.219Z',
      stalkTop: const Offset(216.56, 98.6),
      stalkEnd: const Offset(224.26, 107.4),
    ),
  ];
}

class _Leaf {
  _Leaf(String outline, String midrib, this.base)
      : outline = _TracedPath(outline),
        midrib = _TracedPath(midrib);

  final _TracedPath outline;
  final _TracedPath midrib;
  final Offset base;
}

class _HangingOlive {
  _HangingOlive(String stalk, String body, {required this.stalkTop, required this.stalkEnd, this.fill})
      : stalk = _TracedPath(stalk),
        body = parseSvgPathData(body);

  final _TracedPath stalk;
  final Path body;
  final Offset stalkTop;
  final Offset stalkEnd;
  final Color? fill;
}

// ---- Valley plots ------------------------------------------------------------------------

void _paintPlots(Canvas canvas, _Motion motion) {
  final t = motion.intro;
  final paths = _plots;
  _drawBlob(
    canvas,
    paths.blob,
    color: VioraColors.terracotta100,
    appear: _phase(t, 0, 0.3),
    breath: motion.breath,
  );
  // The map sways as one piece, so the route stays joined to its plot and to the pin.
  _rotated(canvas, motion.swayAngle, _plotsPivot, () {
    for (final (i, plot) in paths.plots.indexed) {
      final draw = _phase(t, 0.08 + i * 0.09, 0.36 + i * 0.09);
      if (draw <= 0) continue;
      // The plot to visit first breathes, the others barely move.
      final emphasis = plot.fill == VioraColors.terracotta500 ? 1 + motion.glow * 0.03 : 1.0;
      _rotated(canvas, motion.swing(i * 0.23, 0.8), plot.center, () {
        _scaled(canvas, (0.92 + 0.08 * draw) * emphasis, plot.center, () {
          final fill = _phase(draw, 0.45, 1);
          if (fill > 0) {
            canvas.drawPath(plot.outline.path, Paint()..color = plot.fill.withValues(alpha: fill));
          }
          _drawTraced(canvas, plot.outline, draw, 1.6);
        });
      });
    }

    final origin = _overshoot.transform(_phase(t, 0.56, 0.68));
    if (origin > 0) {
      _scaled(canvas, origin, _routeOrigin, () {
        canvas.drawPath(paths.routeStart, Paint()..color = VioraColors.neutral900);
      });
    }
    _drawTraced(canvas, paths.route, _phase(t, 0.62, 0.88), 1.4);

    // The pin drops onto the end of the route and then swings from its tip.
    final drop = _phase(t, 0.84, 1);
    if (drop > 0) {
      final tip = _pinTip;
      canvas.save();
      canvas.translate(0, (1 - drop) * -18);
      _rotated(canvas, motion.swing(0.4, 3), tip, () {
        _scaled(canvas, _overshoot.transform(drop), tip, () {
          canvas.drawPath(paths.pin, Paint()..color = VioraColors.neutral50);
          canvas.drawPath(paths.pin, _line(1.6));
          canvas.drawPath(paths.pinEye, Paint()..color = VioraColors.neutral900);
        });
      });
      canvas.restore();
    }
  });
}

const _plotsPivot = Offset(150, 152);
const _routeOrigin = Offset(92, 118);
const _pinTip = Offset(206, 200);

final _plots = _PlotsPaths();

class _PlotsPaths {
  final blob = parseSvgPathData(
    'M150 40C214 36 262 88 258 152C254 216 206 260 142 256C80 252 40 206 44 146C48 88 92 44 150 40Z',
  );
  final plots = [
    _Plot(
      'M132.661 88.2968L59.0668 96.0319L65.3385 155.703L138.933 147.968L132.661 88.2968Z',
      center: const Offset(99, 122),
      fill: VioraColors.neutral50,
    ),
    _Plot(
      'M237.918 83.0702L152.128 77.0711L148.082 134.93L233.872 140.929L237.918 83.0702Z',
      center: const Offset(193, 109),
      fill: VioraColors.neutral50,
    ),
    _Plot(
      'M145.782 171.932L73.8811 168.164L70.2176 238.068L142.119 241.836L145.782 171.932Z',
      center: const Offset(108, 205),
      fill: VioraColors.terracotta500,
    ),
    _Plot(
      'M233.466 157.435L157.651 162.736L162.534 232.565L238.349 227.264L233.466 157.435Z',
      center: const Offset(198, 195),
      fill: VioraColors.neutral50,
    ),
  ];
  final routeStart = parseSvgPathData(
    'M92 122.5C94.4853 122.5 96.5 120.485 96.5 118C96.5 115.515 94.4853 113.5 92 113.5C89.5147 113.5 87.5 115.515 87.5 118C87.5 120.485 89.5147 122.5 92 122.5Z',
  );
  // A dashed line, ordered from the first plot to the pin so it can be traced dash by dash.
  final route = _TracedPath(
    'M96 120C96.4692 120.166 96.9357 120.324 97.3997 120.475M101.136 121.56C102.096 121.804 103.045 122.018 103.984 122.205M107.819 122.825C108.799 122.947 109.768 123.04 110.725 123.107M114.62 123.234C115.604 123.23 116.577 123.2 117.539 123.147M121.414 122.803C122.388 122.685 123.35 122.546 124.304 122.389M128.131 121.655C129.087 121.448 130.035 121.226 130.975 120.993M134.738 119.994C135.68 119.729 136.615 119.458 137.545 119.184M141.272 118.064C142.21 117.781 143.142 117.499 144.071 117.223M147.814 116.148C148.757 115.889 149.698 115.641 150.638 115.41M154.442 114.571C155.401 114.387 156.361 114.226 157.322 114.092M161.196 113.715C162.166 113.663 163.139 113.645 164.117 113.666M167.994 113.956C168.948 114.081 169.907 114.247 170.873 114.458M174.615 115.499C175.075 115.655 175.537 115.822 176 116C176.482 116.193 176.958 116.388 177.429 116.586M181.149 118.259C182.085 118.708 182.995 119.169 183.881 119.64M187.438 121.671C188.325 122.214 189.182 122.769 190.01 123.335M193.299 125.759C194.112 126.407 194.892 127.067 195.638 127.739M198.555 130.6C199.261 131.358 199.93 132.129 200.562 132.912M202.964 136.217C203.527 137.083 204.049 137.961 204.531 138.85M206.272 142.545C206.656 143.497 206.998 144.46 207.298 145.432M208.276 149.398C208.464 150.401 208.61 151.412 208.714 152.43M208.912 156.51C208.908 157.526 208.864 158.547 208.783 159.573M208.264 163.626C208.089 164.622 207.879 165.622 207.635 166.623M206.504 170.549C206.344 171.033 206.176 171.516 206 172',
  );
  final pin = parseSvgPathData(
    'M206 200C206 200 194.5 186 194.5 178.5C194.5 172 199.7 167.5 206 167.5C212.3 167.5 217.5 172 217.5 178.5C217.5 186 206 200 206 200Z',
  );
  final pinEye = parseSvgPathData(
    'M206 182C207.933 182 209.5 180.433 209.5 178.5C209.5 176.567 207.933 175 206 175C204.067 175 202.5 176.567 202.5 178.5C202.5 180.433 204.067 182 206 182Z',
  );
}

class _Plot {
  _Plot(String outline, {required this.center, required this.fill})
      : outline = _TracedPath(outline);

  final _TracedPath outline;
  final Offset center;
  final Color fill;
}

// ---- Drawing helpers ---------------------------------------------------------------------

/// A stroke that can be drawn up to a part of its length, across all of its contours.
class _TracedPath {
  _TracedPath(String data) : path = parseSvgPathData(data) {
    metrics = path.computeMetrics().toList();
    length = metrics.fold<double>(0, (sum, metric) => sum + metric.length);
  }

  final Path path;
  late final List<PathMetric> metrics;
  late final double length;

  Path upTo(double progress) {
    var left = length * progress;
    final segment = Path();
    for (final metric in metrics) {
      if (left <= 0) break;
      segment.addPath(metric.extractPath(0, math.min(left, metric.length)), Offset.zero);
      left -= metric.length;
    }
    return segment;
  }
}

void _drawBlob(
  Canvas canvas,
  Path blob, {
  required Color color,
  required double appear,
  required double breath,
}) {
  if (appear <= 0) return;
  final scale = (0.86 + 0.14 * Curves.fastOutSlowIn.transform(appear)) * (1 + breath * 0.025);
  _scaled(canvas, scale, const Offset(150, 152), () {
    canvas.drawPath(blob, Paint()..color = color.withValues(alpha: color.a * appear));
  });
}

void _drawTraced(Canvas canvas, _TracedPath traced, double progress, double strokeWidth) {
  if (progress <= 0) return;
  canvas.drawPath(progress >= 1 ? traced.path : traced.upTo(progress), _line(strokeWidth));
}

Paint _line(double width) => Paint()
  ..color = VioraColors.neutral900
  ..style = PaintingStyle.stroke
  ..strokeWidth = width
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round;

void _rotated(Canvas canvas, double degrees, Offset pivot, VoidCallback draw) {
  canvas.save();
  canvas.translate(pivot.dx, pivot.dy);
  canvas.rotate(degrees * math.pi / 180);
  canvas.translate(-pivot.dx, -pivot.dy);
  draw();
  canvas.restore();
}

void _scaled(Canvas canvas, double scale, Offset pivot, VoidCallback draw) {
  canvas.save();
  canvas.translate(pivot.dx, pivot.dy);
  canvas.scale(scale);
  canvas.translate(-pivot.dx, -pivot.dy);
  draw();
  canvas.restore();
}

/// 0 before [start], 1 after [end], eased in between.
double _phase(double t, double start, double end) =>
    Curves.fastOutSlowIn.transform(((t - start) / (end - start)).clamp(0.0, 1.0));

/// Ease that passes the target and comes back, for the pieces that pop in.
const _overshoot = Cubic(0.34, 1.56, 0.64, 1);

const _viewport = 300.0;
const _introMillis = 2200;
const _breathMillis = 7000;
const _swayMillis = 6000;
const _flutterMillis = 4200;
const _glowMillis = 5000;
