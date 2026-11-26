import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

/// 3 Dots animated loading indicator
class CircularLoader extends StatefulWidget {
  const CircularLoader({
    super.key,
    this.color = AppColors.white,
    this.size = AppSizes.sm,
    this.spacing = AppSizes.xs,
    this.duration = const Duration(milliseconds: 1000),
  });

  /// Color of the dots
  final Color color;

  /// Diameter of each dot
  final double size;

  /// Spacing between dots
  final double spacing;

  /// Duration of one complete bounce cycle
  final Duration duration;

  @override
  State<CircularLoader> createState() => _CircularLoaderState();
}

class _CircularLoaderState extends State<CircularLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size * 2,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Stagger the animation across the 3 dots
              final delay = index * 0.2;
              final progress = (_controller.value - delay) % 1.0;
              final curvedValue = Curves.easeInOut.transform(
                progress < 0 ? progress + 1.0 : progress,
              );

              // Wave bounce and opacity curve
              final bounce = (curvedValue <= 0.5)
                  ? (curvedValue * 2)
                  : ((1.0 - curvedValue) * 2);

              final offsetY = -bounce * (widget.size * 0.75);
              final opacity = 0.4 + (0.6 * bounce);

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
                child: Transform.translate(
                  offset: Offset(0, offsetY),
                  child: Opacity(
                    opacity: opacity.clamp(0.0, 1.0),
                    child: Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: BoxDecoration(
                        color: widget.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
