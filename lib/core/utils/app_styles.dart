import 'package:flutter/material.dart';

abstract class AppStyles {
  static TextStyle styleLight14() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle styleMedium18() {
    return const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle styleMedium16() {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle styleMedium12() {
    return const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle styleMedium13() {
    return const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle styleMedium15() {
    return const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle styleMedium20() {
    return const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle styleRegular14() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle styleRegular18() {
    return const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle styleRegular10() {
    return const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle styleRegular12() {
    return const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle styleRegular16() {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle styleRegular20() {
    return const TextStyle(
      color: Color(0xFF1A0F91),
      fontSize: 20,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle styleSemiBold20() {
    return const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle styleBold20() {
    return const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle styleSemiBold14() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle styleBold14() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle styleBold16() {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle styleBold24() {
    return const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
    );
  }
}

// // sacleFactor
// // responsive font size
// // (min , max) fontsize
// double responsiveFontSize(BuildContext context, {required double fontSize}) {
//   double scaleFactor = getScaleFactor(context);
//   double responsiveFontSize = fontSize * scaleFactor;

//   double lowerLimit = fontSize * .8;
//   double upperLimit = fontSize * 1.2;

//   return responsiveFontSize.clamp(lowerLimit, upperLimit);
// }

// double getScaleFactor(context) {
//   // var dispatcher = PlatformDispatcher.instance;
//   // var physicalWidth = dispatcher.views.first.physicalSize.width;
//   // var devicePixelRatio = dispatcher.views.first.devicePixelRatio;
//   // double width = physicalWidth / devicePixelRatio;
//   double width = MediaQuery.sizeOf(context).width;
//   if (width < SizeConfig.tablet) {
//     return width / 411.42857142857144; //550
//   } else if (width < SizeConfig.desktop) {
//     return width / 1000;
//   } else {
//     return width / 1920;
//   }
// }
