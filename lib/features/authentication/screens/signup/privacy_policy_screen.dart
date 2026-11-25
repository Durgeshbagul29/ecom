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

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: const MyAppBar(
        title: AppText.privacyPolicy,
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
                      child: const Icon(Iconsax.shield_tick, color: AppColors.primary, size: AppSizes.iconMd),
                    ),
                    const SizedBox(width: AppSizes.spaceBtwItems),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Privacy Matters',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSizes.xs),
                          Text(
                            'Last updated: November 2026',
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

              /// Section 1: Introduction
              _buildSection(
                context,
                isDark,
                icon: Iconsax.info_circle,
                title: '1. Introduction',
                content:
                    'Welcome to ECom. We respect your privacy and are committed to protecting your personal data. This privacy policy informs you about how we look after your personal data when you visit our application and tells you about your privacy rights.',
              ),

              /// Section 2: Information We Collect
              _buildSection(
                context,
                isDark,
                icon: Iconsax.personalcard,
                title: '2. Information We Collect',
                content:
                    '• Personal Identification: Name, email address, phone number, and delivery address.\n'
                    '• Authentication Data: Securely hashed passwords and authentication tokens managed via Firebase Authentication.\n'
                    '• Transaction Details: Records of products purchased, order history, and payment status (we do not store sensitive payment card details directly).\n'
                    '• Device & Usage Data: IP address, device model, operating system, and in-app interaction analytics.',
              ),

              /// Section 3: How We Use Your Data
              _buildSection(
                context,
                isDark,
                icon: Iconsax.setting_2,
                title: '3. How We Use Your Data',
                content:
                    '• To register your account and verify your identity.\n'
                    '• To process, fulfill, and deliver your orders.\n'
                    '• To manage customer support inquiries and provide assistance.\n'
                    '• To send service notifications, security alerts, and order updates.\n'
                    '• To detect and prevent fraud or unauthorized activities.',
              ),

              /// Section 4: Data Sharing & Third Parties
              _buildSection(
                context,
                isDark,
                icon: Iconsax.share,
                title: '4. Data Sharing & Third Parties',
                content:
                    'We never sell your personal data. We only share necessary data with trusted third-party providers including:\n'
                    '• Firebase & Google Cloud: Secure cloud database and authentication services.\n'
                    '• Shipping & Courier Partners: Delivery addresses and contact phone numbers solely for order delivery.\n'
                    '• Payment Gateways: Authorized and PCI-compliant payment processors.',
              ),

              /// Section 5: Data Security
              _buildSection(
                context,
                isDark,
                icon: Iconsax.lock,
                title: '5. Data Security',
                content:
                    'We implement industry-standard encryption, SSL/TLS protocols, and secure cloud infrastructure to protect your personal data from unauthorized access, alteration, disclosure, or destruction.',
              ),

              /// Section 6: Your Rights
              _buildSection(
                context,
                isDark,
                icon: Iconsax.user_tick,
                title: '6. Your Rights',
                content:
                    'You have the right to:\n'
                    '• Access and request a copy of your personal data.\n'
                    '• Request correction of inaccurate or incomplete information.\n'
                    '• Request deletion of your account and personal records.\n'
                    '• Withdraw your consent for promotional communications at any time.',
              ),

              /// Section 7: Contact Us
              _buildSection(
                context,
                isDark,
                icon: Iconsax.call,
                title: '7. Contact Us',
                content:
                    'If you have questions or concerns regarding this Privacy Policy or your data, please contact our Data Protection Team at support@ecom.com.',
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
                child: const Text('I Understand & Accept'),
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
