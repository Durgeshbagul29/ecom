import 'package:ecom/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class MyCartCounterIcon extends StatelessWidget {
  const MyCartCounterIcon({
    super.key, required this.iconColor, required this.onPressed,
  });

  final Color iconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(onPressed: onPressed, icon: Icon(Icons.shopping_cart, color: iconColor)),
        Positioned(
          right: 1,
          top: 1,
          child: Container(width: 18, height: 18, decoration: BoxDecoration(
              color: AppColors.yellow.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(100)
          ),child: Center(
              child : Text('2', style: Theme.of(context).textTheme.labelLarge!.apply(color: AppColors.black, fontSizeFactor: 1))
          ),
          ),
        )
      ],
    );
  }
}



