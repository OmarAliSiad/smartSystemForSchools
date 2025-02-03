import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final EdgeInsetsDirectional padding;
  final double borderRadius;
  final void Function()? onPressed;
  final bool? isLoading;
  const CustomButton({
    super.key,
    required this.padding,
    required this.text,
    required this.textStyle,
    required this.borderRadius,
    this.onPressed,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        minWidth: double.infinity,
        elevation: 0,
        padding: padding,
        color: const Color(0xff191BA9),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        child: isLoading ?? false == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  backgroundColor: Colors.blue,
                ),
              )
            : FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  text,
                  style: textStyle.copyWith(color: Colors.white),
                ),
              ),
      ),
    );
  }
}
