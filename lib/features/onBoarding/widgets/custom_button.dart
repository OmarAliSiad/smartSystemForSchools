import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../login/presenation/views/log_in.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../core/utils/app_styles.dart';

class CustomButtonPageView extends StatefulWidget {
  final int activeIndex;
  final PageController pageController;
  const CustomButtonPageView({
    super.key,
    required this.activeIndex,
    required this.pageController,
  });

  @override
  State<CustomButtonPageView> createState() => _CustomButtonPageViewState();
}

class _CustomButtonPageViewState extends State<CustomButtonPageView> {
  @override
  Widget build(BuildContext context) {
    log(widget.activeIndex.toString());
    return MaterialButton(
      elevation: 0,
      color: const Color(0xff191BA9),
      onPressed: () {
        if (widget.activeIndex != 2) {
          widget.pageController.nextPage(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
          );
        } else {
          Navigator.pushNamed(context, LogIn.id);
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      minWidth: 347,
      height: 48,
      child: Text(
        widget.activeIndex == 2
            ? LocaleKeys.PageView1_button.tr()
            : LocaleKeys.PageView3_button.tr(),
        style: AppStyles.styleMedium18().copyWith(color: Colors.white),
      ),
    );
  }
}
