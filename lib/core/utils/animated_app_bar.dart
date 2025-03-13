import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';

class AnimatedCustomAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final String? title;
  final TextStyle? textStyle;
  final bool thereIsIcon;
  final Function()? onTapBack;
  final Function()? onTapClose;
  final Function()? onTapSuffix;
  final Color waveColor;
  final Color? backgroundColor;
  final IconButton? leading;

  const AnimatedCustomAppBar({
    super.key,
    this.title,
    this.textStyle,
    this.thereIsIcon = true,
    this.onTapBack,
    this.onTapClose,
    this.onTapSuffix,
    this.waveColor = Colors.blue,
    this.backgroundColor,
    this.leading,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 50);

  @override
  State<AnimatedCustomAppBar> createState() => _AnimatedCustomAppBarState();
}

class _AnimatedCustomAppBarState extends State<AnimatedCustomAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isWaveHeightIncreased = false;
  double _waveHeightMultiplier = 3.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapWave() {
    setState(() {
      _isWaveHeightIncreased = true;
      _waveHeightMultiplier = 3.6;
    });

    // Reset wave height after a short delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isWaveHeightIncreased = false;
          _waveHeightMultiplier = 3.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        final themeState = context.read<ThemeModeCubit>().currentTheme;
        const defaultTextColor = Colors.white;
        return Container(
          height: widget.preferredSize.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.blue.shade900,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                widget.backgroundColor ?? const Color(0xFF0D47A1),
                widget.backgroundColor?.withOpacity(0.9) ?? Colors.blue,
              ],
            ),
          ),
          child: Stack(
            children: [
              // Animated wave
              Positioned.fill(
                bottom: MediaQuery.of(context).padding.bottom,
                right: 0,
                left: 0,
                child: GestureDetector(
                  onTap: _onTapWave,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: WavePainter(
                          animation: _controller,
                          waveColor: widget.waveColor,
                          heightMultiplier: _waveHeightMultiplier,
                        ),
                        size: Size.infinite,
                      );
                    },
                  ),
                ),
              ),
              // App bar content
              Positioned(
                top: MediaQuery.of(context).padding.top,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: kToolbarHeight,
                  child: Row(
                    children: [
                      // Back button (from CustomAppBar)
                      widget.leading ??
                          IconButton(
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                            ),
                            icon: const Icon(Icons.arrow_back_ios,
                                color: Colors.white),
                            onPressed: widget.onTapBack ??
                                () => Navigator.of(context).pop(),
                          ),

                      // Title with flexible spacing (from CustomAppBar)
                      Expanded(
                        flex: widget.thereIsIcon ? 3 : 4,
                        child: const SizedBox(),
                      ),
                      widget.title == null
                          ? Container()
                          : Text(widget.title!,
                              style: widget.textStyle!
                                  .copyWith(color: Colors.white)),
                      Expanded(
                        flex: widget.thereIsIcon ? 4 : 6,
                        child: const SizedBox(),
                      ),

                      // Right side icon (close or notification)
                      widget.thereIsIcon
                          ? IconButton(
                              onPressed: widget.onTapClose ??
                                  () => Navigator.of(context).pop(),
                              icon: const Icon(
                                Icons.close,
                              ),
                              color: defaultTextColor,
                            )
                          : widget.onTapSuffix != null
                              ? IconButton(
                                  icon: const Icon(Icons.notifications),
                                  color: defaultTextColor,
                                  onPressed: widget.onTapSuffix,
                                )
                              : const SizedBox(width: 0, height: 0)
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class WavePainter extends CustomPainter {
  final Animation<double> animation;
  final Color waveColor;
  final double heightMultiplier;

  WavePainter({
    required this.animation,
    required this.waveColor,
    this.heightMultiplier = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Create three paths for the three waves
    final path1 = createWavePath(size, 0.0, 0.8);
    final path2 = createWavePath(size, 0.5, 0.5);
    final path3 = createWavePath(size, 1.0, 0.3);

    // Paint for each wave with different opacity
    final paint1 = Paint()
      ..color = waveColor.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = waveColor.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final paint3 = Paint()
      ..color = waveColor.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    // Draw all three waves
    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);
    canvas.drawPath(path3, paint3);
  }

  Path createWavePath(Size size, double phaseShift, double heightFactor) {
    final path = Path();
    final waveHeight = 15.0 * heightMultiplier * heightFactor;
    // Define the number of waves (exactly 3 complete waves)
    const waveCount = 3;
    final waveWidth = size.width / waveCount;
    // Start from top-left
    path.moveTo(0, 0);
    // Draw top line
    path.lineTo(0, size.height * 0.6);
    // Draw waves
    for (int i = 0; i <= waveCount * 2; i++) {
      final dx = i * waveWidth / 2;
      final dy = size.height * 0.6 +
          waveHeight *
              sin((animation.value * 2 * pi) +
                  (i * pi / waveCount) +
                  phaseShift * pi);
      path.lineTo(dx, dy);
    }
    // Complete the path
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
}
