import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileImageViewer extends StatefulWidget {
  const ProfileImageViewer({
    super.key,
    required this.imageUrl,
    required this.userName,
    this.isNetwork = false,
  });

  final String imageUrl;
  final String userName;
  final bool isNetwork;

  static void show(
    BuildContext context, {
    required String imageUrl,
    required String userName,
    bool isNetwork = false,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => ProfileImageViewer(
          imageUrl: imageUrl,
          userName: userName,
          isNetwork: isNetwork,
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  @override
  State<ProfileImageViewer> createState() => _ProfileImageViewerState();
}

class _ProfileImageViewerState extends State<ProfileImageViewer> {
  final TransformationController _transformationController =
      TransformationController();
  Offset? _doubleTapLocalPosition;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    if (currentScale > 1.05) {
      _transformationController.value = Matrix4.identity();
      return;
    }

    const targetScale = 2.5;
    final tapPos = _doubleTapLocalPosition ?? Offset.zero;
    final zoomed = Matrix4.identity()
      ..translateByDouble(
        -tapPos.dx * (targetScale - 1),
        -tapPos.dy * (targetScale - 1),
        0,
        1,
      )
      ..scaleByDouble(targetScale, targetScale, 1, 1);
    _transformationController.value = zoomed;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);
    final bgColor = isDark ? AppColors.charcoalBlack : AppColors.white;
    final fgColor = isDark ? AppColors.white : AppColors.textPrimary;

    final imageWidget = widget.isNetwork
        ? CachedNetworkImage(
            imageUrl: widget.imageUrl,
            fit: BoxFit.contain,
            width: double.infinity,
            progressIndicatorBuilder: (_, __, ___) => const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: AppSizes.cardElevation,
              ),
            ),
            errorWidget: (_, __, ___) => const Icon(
              Icons.broken_image,
              color: AppColors.darkGrey,
              size: AppSizes.imgXl,
            ),
          )
        : Image.asset(
            widget.imageUrl,
            fit: BoxFit.contain,
            width: double.infinity,
          );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            // InteractiveViewer spans the full screen so pinch/double-tap zoom
            // expands across the entire viewport rather than clipping to a square.
            Positioned.fill(
              child: GestureDetector(
                onDoubleTapDown: (details) =>
                    _doubleTapLocalPosition = details.localPosition,
                onDoubleTap: _handleDoubleTap,
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: SizedBox.expand(
                    child: Center(child: imageWidget),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      bgColor.withValues(alpha: 0.9),
                      bgColor.withValues(alpha: 0),
                    ],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.sm,
                      vertical: AppSizes.sm,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.userName,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .apply(color: fgColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.close,
                            color: fgColor,
                            size: AppSizes.iconMd,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
