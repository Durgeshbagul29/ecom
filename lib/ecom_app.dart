import 'package:ecom/bindings/general_bindings.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

class EComApp extends StatelessWidget {
  const EComApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ECom',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      /// theme changing depends on system
      themeMode: ThemeMode.system,
      // set light theme
      theme: AppTheme.lightTheme,
      // set dark theme
      darkTheme: AppTheme.darkTheme,
      // when app running then load
      initialBinding: GeneralBindings(),
      // Show loader or circular progress indicator meanwhile authentication repository is deciding to show relevant screen.
      home: Builder(
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return Scaffold(
            backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          );
        },
      ),
    );
  }
}
