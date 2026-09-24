import 'package:flutter/material.dart';

class AppColors{
  static const Color gradient1 = Color(0xFF678DFF);
  static const Color gradient2 = Color(0xFF3A5FC8);

  static const Color primary = Color(0xFF3A5FC8);
  static const Color bgColor = Color(0xFFF9F9F9);
  static const Color white = Color(0xffFFFFFF);
  static const Color fontBlack = Color(0xFF111111);
  static const Color fontGray = Color(0xFF7C8091);
  static  Gradient primaryGradientColor = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      Color(0xFF678DFF), Color(0xFF3A5FC8).withValues(alpha: 0.075)
    ],);
}