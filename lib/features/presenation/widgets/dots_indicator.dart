import 'package:flutter/material.dart';
import 'package:smartsystemforschools/features/presenation/widgets/dot_indicator.dart';

class DotsIndicator extends StatelessWidget {
  final Color color;
  final int activeIndex;
  const DotsIndicator(
      {super.key, required this.color, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DotIndicator(
          active: activeIndex == 0 ? true : false,
        ),
        const SizedBox(
          width: 8,
        ),
        DotIndicator(
          active: activeIndex == 1 ? true : false,
        ),
        const SizedBox(
          width: 8,
        ),
        DotIndicator(
          active: activeIndex == 2 ? true : false,
        )
      ],
    );
  }
}
