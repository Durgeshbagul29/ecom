import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';


class AppFormDivider extends StatelessWidget {
  const AppFormDivider({
    super.key,required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    // Dark Mode Variable
    final isDark = AppHelperFunctions.isDarkMode(context);

    return Row(
      children: [
        Expanded(child: Divider(indent: 40, endIndent: 5, color: isDark ? AppColors.darkGrey : AppColors.grey)),
        Text(
          title,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: isDark ? AppColors.grey : AppColors.darkGrey),
        ),
        Expanded(child: Divider(indent: 5, endIndent: 40,color: isDark ? AppColors.darkGrey : AppColors.grey)),
      ],
    );
  }
}