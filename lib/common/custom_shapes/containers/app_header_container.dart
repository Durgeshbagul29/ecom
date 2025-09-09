import 'package:ecom/common/custom_shapes/containers/circular_container.dart';
import 'package:ecom/common/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class AppHeaderContainer extends StatelessWidget {
  const AppHeaderContainer({
    super.key, required this.child
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppCurvedEdgesWidget(
      child: Container(
        color: AppColors.primary,
        padding: const EdgeInsets.all(0),
        child: SizedBox(
          height: 400,
          child: Stack(
            children: [
              // Circular Container
              Positioned(top: -150, right: -250, child: CircularContainer(backgroundColor: AppColors.white.withValues(alpha: 0.1))),
              // Circular Container
              Positioned(top: 100, right: -300, child: CircularContainer(backgroundColor: AppColors.white.withValues(alpha: 0.1))),
              // Child
              child
            ],
          ),
        ),
      ),
    );
  }
}