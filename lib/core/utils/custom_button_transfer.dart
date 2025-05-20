import 'package:flutter/material.dart';
import 'assets.dart';

class CustomButtonTransfer extends StatelessWidget {
  final void Function()? onTap;
  const CustomButtonTransfer({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsetsDirectional.only(end: 15, top: 19, bottom: 22),
        child: Container(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF1A0F91),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset(
            Assets.imagesTrasnfer,
            fit: BoxFit.cover,
            width: 24,
            height: 24,
          ),
        ),
      ),
    );
  }
}
