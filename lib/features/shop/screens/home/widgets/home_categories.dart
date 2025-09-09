import 'package:ecom/common/widgets/image_text_widget/vertical_image_text.dart';
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
            return AppVerticalImageText(image: '', title: 'Sport',onTap: (){},);
          }),
    );
  }
}