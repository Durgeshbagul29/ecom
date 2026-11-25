import 'package:ecom/utils/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key, this.title, this.showLogo});

  final String? title;
  final bool? showLogo;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded),
        onPressed: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        },
      ),
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showLogo == true)
            Image.asset(
              AppImages.titleLogo,
              height: 28,
            ),
          if (showLogo == true && title != null) const SizedBox(width: 8),
          if (title != null)
            Text(
              title!,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
        ],
      ),
      elevation: 0,
    );
  }

  // very important: tell Scaffold how tall your AppBar is
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
