import 'package:ecom/common/widgets/buttons/app_elevated_button.dart';
import 'package:ecom/features/authentication/controllers/onboarding_controller.dart';
import 'package:flutter/material.dart';

class OnBoardingStartedButton extends StatelessWidget {
  const OnBoardingStartedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppElevatedButton(
      onPressed: () => OnBoardingController.instance.nextPage(),
      child: const Text("Get Started"),
    );
  }
}
