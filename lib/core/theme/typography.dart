import 'package:flutter/material.dart';
import 'package:shartflix/core/theme/colors.dart';

class AppTypography {
  static const String fontFamily = 'EuclidCircularA';

  static const TextStyle headline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600, // semibold
    color: AppColors.whiteText,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400, // regular
    color: AppColors.whiteText,
  );

  static const TextStyle smallText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400, // regular
    color: AppColors.greyText,
  );

  static const TextStyle underlinedText = TextStyle(
    fontFamily: 'EuclidCircularA',
    fontWeight: FontWeight.w400, //regular
    fontSize: 13,
    decoration: TextDecoration.underline,
    color: AppColors.whiteText,
  );

  static const TextStyle tabLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w500, // medium
    color: AppColors.whiteText,
  );
}
