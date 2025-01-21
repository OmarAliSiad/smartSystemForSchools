import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/utils/app_styles.dart';

class CustomTextField extends StatelessWidget {
  final Widget? prefixIcon;
  final String hintText;
  final bool obsure;
  final int? maxLines;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int? maxLength;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final double borderRaduis;
  const CustomTextField({
    super.key,
    this.prefixIcon,
    required this.hintText,
    required this.obsure,
    this.maxLines,
    required this.controller,
    this.keyboardType,
    this.maxLength,
    this.suffixIcon,
    required this.borderRaduis,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRaduis),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 1),
            spreadRadius: 0,
          )
        ],
      ),
      child: TextFormField(
        style: const TextStyle(color: Colors.black),
        maxLength: maxLength,
        keyboardType: keyboardType,
        controller: controller,
        maxLines: obsure ? 1 : maxLines,
        validator: validator,
        obscureText: obsure,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          hintFadeDuration: const Duration(milliseconds: 400),
          hintText: hintText,
          hintStyle: AppStyles.styleRegular14().copyWith(
            color: const Color(0xFF000000).withOpacity(0.5),
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: BuildOutlineBorder(),
          enabledBorder: BuildOutlineBorder(),
          focusedBorder: BuildOutlineBorder(),
        ),
      ),
    );
  }

  OutlineInputBorder BuildOutlineBorder() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
      borderSide: BorderSide.none,
    );
  }
}
