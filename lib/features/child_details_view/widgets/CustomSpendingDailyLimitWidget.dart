import 'package:flutter/material.dart';

import '../../../core/utils/app_styles.dart';

class CustomSpendingDailyLimitWidget extends StatelessWidget {
  final String price;
  const CustomSpendingDailyLimitWidget({
    super.key,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          price,
          style: AppStyles.styleSemiBold14().copyWith(
            color: const Color(0xff5CC2F2),
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        Text(
          'Daily spending limit',
          style: AppStyles.styleRegular12().copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
