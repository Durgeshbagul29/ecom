import 'package:ecom/common/styles/padding.dart';
import 'package:ecom/common/widgets/appbar/my_appbar.dart';
import 'package:ecom/common/widgets/buttons/app_elevated_button.dart';
import 'package:ecom/features/authentication/controllers/signup_controller.dart';
import 'package:ecom/utils/constants/app_text.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: const MyAppBar(
        title: AppText.termsOfUse,
        showLogo: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppPadding.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkContainer : AppColors.primaryBackground,
                  borderRadius: BorderRadius.circular(AppSizes.cardRadiusLg),
                  border: Border.all(
                    color: isDark ? Colors.transparent : AppColors.accent.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSizes.sm),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Iconsax.document_text, color: AppColors.primary, size: AppSizes.iconMd),
                    ),
                    const SizedBox(width: AppSizes.spaceBtwItems),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Terms & Conditions',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSizes.xs),
                          Text(
                            'Effective Date: November 2026',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: isDark ? Colors.white60 : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.spaceBtwSections),

              /// Section 1: Acceptance of Terms
              _buildSection(
                context,
                isDark,
                icon: Iconsax.tick_circle,
                title: '1. Acceptance of Terms',
                content:
                    'By downloading, accessing, or using the ECom application, you agree to be bound by these Terms of Use and all applicable laws and regulations. If you do not agree with any of these terms, you are prohibited from using or accessing this app.',
              ),

              /// Section 2: User Account & Security
              _buildSection(
                context,
                isDark,
                icon: Iconsax.user_edit,
                title: '2. User Account & Security',
                content:
                    '• You must provide accurate, current, and complete information during registration.\n'
                    '• You are responsible for maintaining the confidentiality of your account credentials and password.\n'
                    '• You agree to immediately notify us of any unauthorized use of your account or security breach.\n'
                    '• You must be at least 18 years old or use the application under parental/guardian supervision.',
              ),

              /// Section 3: Product Listings & Pricing
              _buildSection(
                context,
                isDark,
                icon: Iconsax.shop,
                title: '3. Product Information & Pricing',
                content:
                    '• We strive to display accurate product descriptions, images, and prices. However, slight variations may occur.\n'
                    '• We reserve the right to correct any typographical errors, inaccuracies, or omissions, and to change or update information at any time without prior notice.\n'
                    '• Prices and product availability are subject to change without notice.',
              ),

              /// Section 4: Orders & Payments
              _buildSection(
                context,
                isDark,
                icon: Iconsax.card,
                title: '4. Orders & Payments',
                content:
                    '• An order confirmation does not signify our acceptance of your order. We reserve the right to accept or decline your order for any reason.\n'
                    '• All payments must be made through our authorized payment gateways.\n'
                    '• In the event of an order cancellation by us, any payments made will be refunded promptly.',
              ),

              /// Section 5: Shipping & Delivery
              _buildSection(
                context,
                isDark,
                icon: Iconsax.truck_fast,
                title: '5. Shipping & Delivery',
                content:
                    '• Delivery estimates are provided for reference only and are not guaranteed delivery dates.\n'
                    '• Risk of loss and title for items purchased pass to you upon delivery to the carrier.',
              ),

              /// Section 6: Prohibited Uses
              _buildSection(
                context,
                isDark,
                icon: Iconsax.forbidden_2,
                title: '6. Prohibited Uses',
                content:
                    'You agree not to:\n'
                    '• Use the app for any illegal or unauthorized purpose.\n'
                    '• Attempt to interfere with, disrupt, or compromise the system integrity or security.\n'
                    '• Scrape, crawl, or harvest data from the app using automated tools.\n'
                    '• Transmit any viruses, worms, or malicious code.',
              ),

              /// Section 7: Intellectual Property
              _buildSection(
                context,
                isDark,
                icon: Iconsax.award,
                title: '7. Intellectual Property',
                content:
                    'All content included on the app, including text, graphics, logos, button icons, images, and software, is the property of ECom or its content suppliers and protected by copyright, trademark, and other laws.',
              ),

              /// Section 8: Limitation of Liability
              _buildSection(
                context,
                isDark,
                icon: Iconsax.warning_2,
                title: '8. Limitation of Liability',
                content:
                    'In no event shall ECom, its directors, employees, or partners be liable for any indirect, incidental, special, consequential, or punitive damages arising out of your access to or use of the application.',
              ),

              /// Section 9: Changes to Terms
              _buildSection(
                context,
                isDark,
                icon: Iconsax.refresh,
                title: '9. Changes to Terms',
                content:
                    'We reserve the right to modify these Terms of Use at any time. Changes will be effective immediately upon posting. Your continued use of the application following any changes constitutes acceptance of the new terms.',
              ),
              const SizedBox(height: AppSizes.spaceBtwSections),

              /// Accept & Continue Button
              AppElevatedButton(
                onPressed: () {
                  if (Get.isRegistered<SignupController>()) {
                    SignupController.instance.privacyPolicy.value = true;
                  }
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('I Agree to Terms of Use'),
              ),
              const SizedBox(height: AppSizes.spaceBtwItems),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    bool isDark, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceBtwSections),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: AppSizes.iconSm, color: AppColors.primary),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkContainer : AppColors.light,
              borderRadius: BorderRadius.circular(AppSizes.cardRadiusMd),
              border: Border.all(
                color: isDark ? Colors.white10 : AppColors.borderPrimary,
              ),
            ),
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
