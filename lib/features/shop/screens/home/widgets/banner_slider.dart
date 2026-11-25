import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecom/common/custom_shapes/containers/circular_container.dart';
import 'package:ecom/common/widgets/images_design/app_rounded_image.dart';
import 'package:ecom/features/shop/controllers/home_controller.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// My Code
class BannerSlider extends StatelessWidget {
  const BannerSlider({
    super.key,
    required this.banners,
    required this.cHeight,
    this.cWidth,
    this.autoPlay = true,
    this.autoPlaySec,
  });

  // Variable for banners list
  final List<String> banners;
  final double cHeight;
  final double? cWidth;
  final bool autoPlay;
  final int? autoPlaySec;

  @override
  Widget build(BuildContext context) {
    // Get already created instance of a home controller
    final controller = Get.put(HomeController());

    return Column(
      children: [
        // Banner Carousel Slider
        SizedBox(
          width: cWidth ?? double.infinity,
          child: CarouselSlider(
              options: CarouselOptions(
                  viewportFraction: 1,
                  height: cHeight,
                  // Auto Scrolling
                  autoPlay: autoPlay, // enable auto-scrolling
                  autoPlayInterval: Duration(seconds: autoPlaySec ?? 3), // scroll every 3 sec
                  autoPlayAnimationDuration: const Duration(milliseconds: 800), // smooth animation
                  autoPlayCurve: Curves.easeInOut, // smooth curve
                  onPageChanged: (index, _) => controller.updatePageIndicator(index)
              ),
              items: banners.map((url) => AppRoundedImage(imageUrl: url)).toList()
          ),
        ),
        SizedBox(height: AppSizes.spaceBtwItems),

        // Banners Slider Dots Indicator
        Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              for(int i = 0; i < banners.length; i++)
                 CircularContainer(
                    width: 8, height: 8,
                    margin: EdgeInsets.only(right: 6),
                    backgroundColor: controller.carouselCurrentIndex.value == i ? AppColors.primary : Colors.transparent,
                     shadowBorder: true
                 )
            ],
          ),
        )
      ],
    );
  }
}

/// New Added for Circular Dots shows on banner
// class BannerSlider extends StatelessWidget {
//   const BannerSlider({
//     super.key,
//     required this.banners,
//     required this.cHeight,
//     this.cWidth,
//   });
//
//   final List<String> banners;
//   final double cHeight;
//   final double? cWidth;
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(HomeController());
//
//     return SizedBox(
//       width: cWidth ?? double.infinity,
//       height: cHeight,
//       child: Stack(
//         alignment: Alignment.bottomCenter, // indicator at bottom
//         children: [
//           /// Banner Carousel
//           CarouselSlider(
//             options: CarouselOptions(
//               viewportFraction: 1,
//               height: cHeight,
//               onPageChanged: (index, _) =>
//                   controller.updatePageIndicator(index),
//             ),
//             items: banners
//                 .map((url) => AppRoundedImage(
//               imageUrl: url,
//               width: double.infinity,
//               height: cHeight,
//               fit: BoxFit.cover,
//             ))
//                 .toList(),
//           ),
//
//           /// Indicators overlay
//           Positioned(
//             bottom: 12, // adjust padding from bottom
//             child: Obx(
//                   () => Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   for (int i = 0; i < banners.length; i++)
//                     CircularContainer(
//                       width: 10,
//                       height: 10,
//                       radius: 5,
//                       margin: const EdgeInsets.only(right: 6),
//                       backgroundColor:
//                       controller.carouselCurrentIndex.value == i
//                           ? AppColors.primary
//                           : Colors.transparent,
//                       border: Border.all(
//                         color: AppColors.primary,
//                         width: 1.5,
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
