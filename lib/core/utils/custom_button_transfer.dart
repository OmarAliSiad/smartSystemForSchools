
import 'package:flutter/material.dart';
import 'package:smartsystemforschools/core/utils/assets.dart';

class CustomButtonTransfer extends StatelessWidget {
  const CustomButtonTransfer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.only(top: 19, right: 15, bottom: 22),
        child: Container(
          padding: const EdgeInsets.symmetric(
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
