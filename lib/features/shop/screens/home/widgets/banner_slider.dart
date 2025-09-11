import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecom/common/custom_shapes/containers/circular_container.dart';
import 'package:ecom/common/widgets/images_design/app_rounded_image.dart';
import 'package:ecom/features/shop/controllers/home_controller.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BannerSlider extends StatelessWidget {
  const BannerSlider({
    super.key, required this.banners,
  });

  // Variable for banners list
  final List<String> banners;

  @override
  Widget build(BuildContext context) {
    // Get already created instance of a home controller
    final controller = Get.put(HomeController());

    return Column(
      children: [
        // Banner Carousel Slider
        CarouselSlider(
            options: CarouselOptions(
                viewportFraction: 1,
                onPageChanged: (index, _) => controller.updatePageIndicator(index)
            ),
            items: banners.map((url) => AppRoundedImage(imageUrl: url, fit: BoxFit.cover)).toList()
        ),
        SizedBox(height: AppSizes.spaceBtwItems),
        
        // Banners Slider Dots Indicator
        Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              for(int i = 0; i < banners.length; i++)
                 CircularContainer(
                    width: 20, height: 4,
                    margin: EdgeInsets.only(right: 10),
                    backgroundColor: controller.carouselCurrentIndex == i ? AppColors.primary : AppColors.grey)
            ],
          ),
        )
      ],
    );
  }
}