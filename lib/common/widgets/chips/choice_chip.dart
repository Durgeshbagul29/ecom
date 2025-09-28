import 'package:ecom/common/custom_shapes/containers/circular_container.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class AppChoiceChip extends StatelessWidget {
  const AppChoiceChip({
    super.key,
    required this.text,
    required this.selected,
    this.onSelected,
  });

  final String text;
  final bool selected;
  final void Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    /// Helper Function Color Variable
    final isColor = AppHelperFunctions.getColor(text) != null;

    return ChoiceChip(
      label: isColor ? const SizedBox() : Text(text),
      selected: selected,
      onSelected: onSelected,
      labelStyle: TextStyle(color: selected ? AppColors.white : null),
      avatar: isColor
          ? CircularContainer(
              width: 50,
              height: 50,
              backgroundColor: AppHelperFunctions.getColor(text)!,
            )
          : null,
      shape: isColor ? const CircleBorder() : null,
      labelPadding: isColor ? const EdgeInsets.all(0) : null,
      // Make icon in the center
      padding: isColor ? const EdgeInsets.all(0) : null,
      // selectedColor: Colors.green,
      backgroundColor: isColor ? AppHelperFunctions.getColor(text)! : null,
    );
  }
}
