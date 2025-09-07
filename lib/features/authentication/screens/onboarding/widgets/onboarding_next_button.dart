import 'package:ecom/features/authentication/controllers/onboarding_controller.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 28,
      backgroundColor: Theme.of(context).primaryColor,
      child: IconButton(
        onPressed: () => OnBoardingController.instance.nextPage(),
        icon: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: AppColors.white,
        ),
      ),
    );
  }
}
