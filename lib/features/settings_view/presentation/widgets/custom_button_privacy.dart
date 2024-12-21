import 'package:flutter/material.dart';

class CustomButtonPrivacy extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final void Function() onPressed;
  const CustomButtonPrivacy({
    super.key,
    required this.padding,
    required this.text,
    required this.textStyle,
    required this.borderRadius,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        minWidth: double.infinity,
        elevation: 0,
        padding: padding,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1.00, color: Color(0xff1A0F91)),
            borderRadius: BorderRadius.circular(borderRadius)),
        child: Text(
          text,
          style: textStyle.copyWith(color: const Color(0xff1A0F91)),
        ),
      ),
    );
  }
}
