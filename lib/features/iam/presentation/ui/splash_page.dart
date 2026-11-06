import 'dart:async';
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/component/viora_morphing_shape_indicator.dart';
import 'package:viora/core/designsystem/component/viora_wavy_progress_indicator.dart';
import 'package:viora/core/designsystem/theme/app_theme.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/navigation/app_routes.dart';
import 'package:viora/features/iam/presentation/ui/welcome_page.dart';
import 'package:viora/features/iam/presentation/viewmodel/splash_view_model.dart';

/// First screen of every launch, played in this order on the brand green:
/// 1. a white ring holds a loading shape that keeps morphing;
/// 2. the shape settles into a circle and fills the ring;
/// 3. ring and circle give way to the white isotype;
/// 4. the isotype shrinks into the "o" of "Viora" while the other letters appear;
/// 5. a wavy progress ring shows under the logo until the saved session has been read,
///    and then the screen fades into the Home or the welcome.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const path = '/splash';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  // Material 3 emphasized easing curves.
  static const _emphasized = Cubic(0.2, 0, 0, 1);
  static const _emphasizedDecelerate = Cubic(0.05, 0.7, 0.1, 1);

  static const _morphPhase = Duration(milliseconds: 1000);
  static const _fillTime = Duration(milliseconds: 300);
  static const _isotypeTime = Duration(milliseconds: 380);
  static const _wordmarkTime = Duration(milliseconds: 650);
  static const _loaderFadeTime = Duration(milliseconds: 200);
  static const _minLoaderTime = Duration(milliseconds: 450);
  static const _leaveTime = Duration(milliseconds: 250);

  static const _ringSize = 112.0;
  static const _ringStroke = 3.0;
  static const _shapeSize = 64.0;

  /// The circle fills the ring up to a thin gap.
  static const _filledScale = 90 / 64;

  static const _isotypeSize = 103.0;
  static const _wordmarkWidth = 185.0;
  static const _wordmarkHeight = 111.0;

  /// The "o" inside the wordmark canvas (407.65 x 244.74) spans 179.3-252.0 x 97.7-171.6,
  /// so at 185 wide it measures 33.3 and its center sits off the canvas center.
  static const _markSize = 33.3;
  static const _markOffset = Offset(5.4, 5.6);

  /// The loading ring sits at 82 % of the screen height.
  static const _loaderAlignment = Alignment(0, 0.63);
  static const _loaderSize = 48.0;

  late final AnimationController _fill = AnimationController(vsync: this);
  late final AnimationController _isotype = AnimationController(vsync: this);
  late final AnimationController _wordmark = AnimationController(vsync: this);
  late final AnimationController _loader = AnimationController(vsync: this);
  late final AnimationController _leave = AnimationController(vsync: this);
  late final Listenable _timeline = Listenable.merge([_fill, _isotype, _wordmark, _loader, _leave]);

  final _settled = Completer<void>();
  Timer? _morphTimer;
  Timer? _loaderTimer;
  bool _settle = false;
  late final SplashViewModel _viewModel = getIt<SplashViewModel>();

  @override
  void initState() {
    super.initState();
    _morphTimer = Timer(_morphPhase, () => setState(() => _settle = true));
    unawaited(_play());
  }

  Future<void> _play() async {
    try {
      await _settled.future;
      if (!mounted) return;
      await _fill.animateTo(1, duration: _fillTime, curve: _emphasizedDecelerate).orCancel;
      await _isotype.animateTo(1, duration: _isotypeTime, curve: _emphasizedDecelerate).orCancel;
      await _wordmark.animateTo(1, duration: _wordmarkTime, curve: _emphasized).orCancel;
      await _loader.animateTo(1, duration: _loaderFadeTime).orCancel;

      final minLoader = Completer<void>();
      _loaderTimer = Timer(_minLoaderTime, minLoader.complete);
      await minLoader.future;

      final destination =
          _viewModel.state ?? await _viewModel.stream.firstWhere((value) => value != null);
      if (!mounted) return;

      await _leave.animateTo(1, duration: _leaveTime).orCancel;
      if (!mounted) return;
      // A saved session goes through the license check, which opens the Home or the activation.
      context.go(
        destination == SplashDestination.home ? AppRoutes.licenseGate : WelcomePage.path,
      );
    } on TickerCanceled {
      // The screen left the tree while it was playing.
    }
  }

  @override
  void dispose() {
    _morphTimer?.cancel();
    _loaderTimer?.cancel();
    _fill.dispose();
    _isotype.dispose();
    _wordmark.dispose();
    _loader.dispose();
    _leave.dispose();
    _viewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.systemBarsOnDark,
      child: Semantics(
        label: 'Viora',
        container: true,
        excludeSemantics: true,
        // The cream underneath is what the screen fades into.
        child: ColoredBox(
          color: VioraColors.neutral100,
          child: AnimatedBuilder(
            animation: _timeline,
            child: VioraMorphingShapeIndicator(
              color: VioraColors.shadow,
              settle: _settle,
              onSettled: () {
                if (!_settled.isCompleted) _settled.complete();
              },
            ),
            builder: (context, shape) => Opacity(
              opacity: 1 - _leave.value,
              child: ColoredBox(
                color: VioraColors.forest,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _ring(shape!),
                    _isotypeMark(),
                    _wordmarkLogo(),
                    _loadingRing(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Ring with the morphing shape, which gives way to the isotype.
  Widget _ring(Widget shape) {
    final out = _isotype.value;
    return Opacity(
      opacity: (1 - out).clamp(0.0, 1.0),
      child: Transform.scale(
        scale: lerpDouble(1, 0.7, out)!,
        child: SizedBox.square(
          dimension: _ringSize,
          child: CustomPaint(
            painter: const _RingPainter(stroke: _ringStroke, color: VioraColors.neutral0),
            child: Center(
              child: Transform.scale(
                scale: lerpDouble(1, _filledScale, _fill.value)!,
                child: SizedBox.square(dimension: _shapeSize, child: shape),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Isotype, which then travels into the "o" of the wordmark.
  Widget _isotypeMark() {
    final move = _wordmark.value;
    final grow = lerpDouble(0.7, 1, _isotype.value)!;
    return Opacity(
      opacity: (_isotype.value * (1 - _handover(move))).clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset.lerp(Offset.zero, _markOffset, move)!,
        child: Transform.scale(
          scale: grow * lerpDouble(1, _markSize / _isotypeSize, move)!,
          child: const VioraIcon(
            VioraIcons.isotype,
            size: _isotypeSize,
            color: VioraColors.neutral0,
          ),
        ),
      ),
    );
  }

  /// The wordmark: its "o" takes over from the isotype and the letters open up around it.
  Widget _wordmarkLogo() {
    final reveal = ((_wordmark.value - 0.35) / 0.65).clamp(0.0, 1.0);
    return SizedBox(
      width: _wordmarkWidth,
      height: _wordmarkHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(opacity: _handover(_wordmark.value), child: _logoPart(VioraIcons.logoWordmarkMark)),
          Opacity(
            opacity: reveal,
            child: Transform.scale(
              scaleX: lerpDouble(0.92, 1, reveal)!,
              child: _logoPart(VioraIcons.logoWordmarkLetters),
            ),
          ),
        ],
      ),
    );
  }

  Widget _logoPart(String asset) => SvgPicture.asset(
        asset,
        width: _wordmarkWidth,
        height: _wordmarkHeight,
        colorFilter: const ColorFilter.mode(VioraColors.neutral0, BlendMode.srcIn),
      );

  /// Loading ring under the logo. It only runs once it starts to show.
  Widget _loadingRing() {
    if (_loader.value == 0) return const SizedBox.shrink();
    return Align(
      alignment: _loaderAlignment,
      child: Opacity(
        opacity: _loader.value,
        child: SizedBox.square(
          dimension: _loaderSize,
          child: VioraWavyProgressIndicator(
            color: VioraColors.neutral0,
            trackColor: VioraColors.neutral0.withValues(alpha: 0.24),
          ),
        ),
      ),
    );
  }

  /// The last fifth of the move, when the "o" of the wordmark replaces the isotype.
  double _handover(double move) => ((move - 0.8) / 0.2).clamp(0.0, 1.0);
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.stroke, required this.color});

  final double stroke;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      size.center(Offset.zero),
      size.shortestSide / 2 - stroke / 2,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.stroke != stroke || oldDelegate.color != color;
}
