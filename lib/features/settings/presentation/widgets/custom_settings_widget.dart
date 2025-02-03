import 'package:flutter/material.dart';

class CustomSettingsWidget extends StatelessWidget {
  final String settingsName;
  final Widget suffixWidget;
  final TextStyle style;
  final void Function()? onTap;
  const CustomSettingsWidget(
      {super.key,
      required this.settingsName,
      required this.suffixWidget,
      required this.style,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(settingsName),
        const Spacer(),
        InkWell(onTap: onTap, child: suffixWidget),
      ],
    );
  }
}
