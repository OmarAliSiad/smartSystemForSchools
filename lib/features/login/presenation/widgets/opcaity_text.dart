import 'package:flutter/material.dart';

class OpcaityText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final double opacity;
  const OpcaityText(
      {super.key,
      required this.text,
      required this.textStyle,
      required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Text(
        text,
        style: textStyle.copyWith(
          color: Colors.black,
        ),
      ),
    );
  }
}
