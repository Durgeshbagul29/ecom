import 'package:ecom/common/widgets/images_design/vertical_image_text.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:flutter/material.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: 6,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index){
            return AppVerticalImageText(image: AppImages.shoes, title: 'Shoes',onTap: (){},);
          }),
    );
  }
}