import 'dart:async';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AppLoaders {
  static OverlayEntry? _currentEntry;

  /// Hide current toast or snackbar
  static void hideSnackBar() {
    if (_currentEntry != null) {
      _currentEntry?.remove();
      _currentEntry = null;
    }

    final context = Get.context;
    if (context != null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  /// Internal helper to show an animated toast (comes from bottom & goes to bottom)
  static void _showToast({
    required Widget icon,
    required String title,
    String message = '',
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    hideSnackBar();

    final overlay = Get.key.currentState?.overlay ??
        (Get.context != null ? Navigator.maybeOf(Get.context!)?.overlay : null);

    if (overlay == null) {
      // Fallback to ScaffoldMessenger if overlay is not yet attached
      final context = Get.context;
      if (context == null) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: AppSizes.cardElevation * 3,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(AppSizes.spaceBtwItems),
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
          ),
          duration: duration,
          content: Row(
            children: [
              icon,
              const SizedBox(width: AppSizes.buttonRadius),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: AppSizes.fontSizeSm,
                      ),
                    ),
                    if (message.isNotEmpty) ...[
                      const SizedBox(height: AppSizes.xs),
                      Text(
                        message,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: AppSizes.fontSizeXs,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _SlideToastWidget(
        icon: icon,
        title: title,
        message: message,
        backgroundColor: backgroundColor,
        duration: duration,
        onDismissed: () {
          if (_currentEntry == entry) {
            _currentEntry?.remove();
            _currentEntry = null;
          }
        },
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);
  }

  /// Custom SnackBar / Toast
  static void customSnackBar({required message}) {
    final context = Get.context;
    final isDark =
        context != null ? AppHelperFunctions.isDarkMode(context) : false;

    _showToast(
      icon: const SizedBox.shrink(),
      title: message.toString(),
      message: '',
      backgroundColor: isDark
          ? AppColors.darkerGrey.withValues(alpha: 0.95)
          : AppColors.grey.withValues(alpha: 0.95),
      duration: const Duration(seconds: 3),
    );
  }

  /// Success SnackBar / Toast
  static void successSnackBar({
    required String title,
    String message = '',
    int duration = 3,
  }) {
    _showToast(
      icon: const Icon(Iconsax.check, color: AppColors.white),
      title: title,
      message: message,
      backgroundColor: AppColors.primary,
      duration: Duration(seconds: duration),
    );
  }

  /// Warning SnackBar / Toast
  static void warningSnackBar({required String title, String message = ''}) {
    _showToast(
      icon: const Icon(Iconsax.warning_2, color: AppColors.white),
      title: title,
      message: message,
      backgroundColor: AppColors.warning,
      duration: const Duration(seconds: 3),
    );
  }

  /// Error SnackBar / Toast
  static void errorSnackBar({required String title, String message = ''}) {
    _showToast(
      icon: const Icon(Iconsax.close_circle, color: AppColors.white),
      title: title,
      message: message,
      backgroundColor: AppColors.error,
      duration: const Duration(seconds: 3),
    );
  }
}

/// ---------------------------------------------------------------------------
/// SlideToastWidget
/// Animates floating toast: comes from bottom and goes to bottom
/// ---------------------------------------------------------------------------
class _SlideToastWidget extends StatefulWidget {
  final Widget icon;
  final String title;
  final String message;
  final Color backgroundColor;
  final Duration duration;
  final VoidCallback onDismissed;

  const _SlideToastWidget({
    required this.icon,
    required this.title,
    required this.message,
    required this.backgroundColor,
    required this.duration,
    required this.onDismissed,
  });

  @override
  State<_SlideToastWidget> createState() => _SlideToastWidgetState();
}

class _SlideToastWidgetState extends State<_SlideToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      reverseDuration: const Duration(milliseconds: 350),
    );

    // Fluid deceleration curve for natural, buttery-smooth movement
    const smoothCurve = Cubic(0.16, 1.0, 0.3, 1.0);
    const reverseCurve = Cubic(0.4, 0.0, 1.0, 1.0);

    // Slide up from bottom (starts slightly off-screen)
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: smoothCurve,
        reverseCurve: reverseCurve,
      ),
    );

    // Subtle scale for natural lift effect
    _scaleAnimation = Tween<double>(
      begin: 0.92,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: smoothCurve,
        reverseCurve: reverseCurve,
      ),
    );

    // Soft opacity transition
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
        reverseCurve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    // Slide up from bottom
    _controller.forward();

    // Auto-dismiss after duration
    _timer = Timer(widget.duration, () {
      _dismiss();
    });
  }

  void _dismiss() {
    if (!mounted) return;
    _timer?.cancel();
    _controller.reverse().then((_) {
      if (mounted) {
        widget.onDismissed();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      bottom: bottomInset > 0
          ? bottomInset + AppSizes.md
          : bottomPadding + AppSizes.defaultSpace,
      left: AppSizes.md,
      right: AppSizes.md,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity != null &&
                    details.primaryVelocity! > 100) {
                  // Swipe down to dismiss
                  _dismiss();
                }
              },
              onTap: _dismiss,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md,
                    vertical: AppSizes.buttonRadius,
                  ),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius:
                        BorderRadius.circular(AppSizes.borderRadiusXl),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.22),
                        blurRadius: AppSizes.md,
                        spreadRadius: 1,
                        offset: const Offset(0, AppSizes.cardElevation * 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      if (widget.icon is! SizedBox ||
                          (widget.icon is SizedBox &&
                              (widget.icon as SizedBox).width != 0)) ...[
                        widget.icon,
                        const SizedBox(width: AppSizes.buttonRadius),
                      ],
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: AppSizes.fontSizeSm,
                              ),
                            ),
                            if (widget.message.isNotEmpty) ...[
                              const SizedBox(height: AppSizes.xs),
                              Text(
                                widget.message,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: AppSizes.fontSizeXs,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
