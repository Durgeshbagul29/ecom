import 'package:ecom/utils/device/device_utility.dart';
import 'package:flutter/material.dart';


class AppElevatedButton extends StatelessWidget {
  const AppElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.width
  });

  final VoidCallback onPressed;
  final Widget child;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? AppDeviceHelpers.getScreenWidth(context),
      child: ElevatedButton(onPressed: onPressed, child: child),
    );
  }
}
