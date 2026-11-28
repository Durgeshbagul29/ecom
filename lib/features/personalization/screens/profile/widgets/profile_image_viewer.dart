import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ProfileImageViewer extends StatelessWidget {
  const ProfileImageViewer({
    super.key,
    required this.imageUrl,
    required this.userName,
    this.isNetwork = false,
  });

  final String imageUrl;
  final String userName;
  final bool isNetwork;

  static void show(BuildContext context, {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              child: isNetwork
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      progressIndicatorBuilder: (_, __, ___) => const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.white,
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
                      imageUrl,
                      fit: BoxFit.contain,
                      width: double.infinity,
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
                  colors: [AppColors.black, AppColors.black.withValues(alpha: 0)],
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
                          userName,
                          style: Theme.of(context).textTheme.titleLarge!.apply(color: AppColors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.white,
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
    );
  }
}
