import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';

import '../../../core/utils/app_styles.dart';

class CustomBalanceWidget extends StatelessWidget {
  final String price;
  const CustomBalanceWidget({
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
          LocaleKeys.balanceCardDetails_balance.tr(),
          style: AppStyles.styleRegular12().copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
