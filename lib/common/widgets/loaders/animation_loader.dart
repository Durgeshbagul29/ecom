import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// A widget for displaying an animated loading indicator
/// with optional text and action button.
class AnimationLoaderWidget extends StatelessWidget {
  const AnimationLoaderWidget({
    super.key,
    required this.text,
    required this.animation,
    this.showAction = false,
    this.actionText,
    this.onActionPressed,
  });

  /// The text displayed below the animation.
  final String text;

  /// The Lottie animation asset path.
  final String animation;

  /// Whether to show an action button below the text.
  final bool showAction;

  /// The text displayed on the action button (optional).
  final String? actionText;

  /// Callback when the action button is pressed.
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Animation
          Lottie.asset(
            animation,
            width: MediaQuery.of(context).size.width * 0.8,
          ),

          const SizedBox(height: AppSizes.defaultSpace),

          /// Text
          Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: AppSizes.defaultSpace),

          /// Optional action button
          showAction
              ? SizedBox(
                  width: 250,
                  child: OutlinedButton(
                    onPressed: onActionPressed,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.dark,
                    ),
                    child: Text(
                      actionText!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium!.apply(color: AppColors.light),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
