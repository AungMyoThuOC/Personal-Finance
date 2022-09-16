import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/app_theme.dart';
import 'app_colors.dart';

class AppThemes {
  static ThemeData main({
    Color primaryColor = AppColors.primary,
  }) {
    return ThemeData(
        fontFamily: 'TitilliumWeb',
        brightness: Brightness.light,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: AppColors.gray,
        cardColor: AppColors.white,
        dividerColor: AppColors.white.withOpacity(0.2),
        shadowColor: AppColors.grayDark,
        primarySwatch: AppColors.getMaterialColorFromColor(primaryColor),
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          backgroundColor: primaryColor,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ));
  }

  static List<AppTheme> appThemeOptions = [
    AppTheme(
      mode: ThemeMode.light,
      title: 'Light',
      icon: Icons.brightness_5_outlined,
    ),
  ];
}
