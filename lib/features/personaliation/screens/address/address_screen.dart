import 'package:ecom/common/widgets/appbar/appbar.dart';
import 'package:ecom/features/personaliation/screens/address/add_new_address_screen.dart';
import 'package:ecom/features/personaliation/screens/address/widgets/single_address.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddNewAddressScreen()),
        backgroundColor: AppColors.primary,
        child: Icon(Iconsax.add, color: AppColors.white),
      ),
      appBar: CustomAppBar(
        showBackArrow: true,
        title: Text(
          'Addresses',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.defaultSpace),
          child: Column(children: [
            SingleAddress(selectedAddress: false),
            SingleAddress(selectedAddress: true),
            SingleAddress(selectedAddress: false),
            SingleAddress(selectedAddress: false),
            SingleAddress(selectedAddress: false)
          ]),
        ),
      ),
    );
  }
}
