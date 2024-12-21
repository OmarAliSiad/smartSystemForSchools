import 'package:flutter/material.dart';

import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/assets.dart';

class CustomBalanceCardDetails extends StatelessWidget {
  const CustomBalanceCardDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A0F91),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, top: 18, bottom: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Balance',
                  style:
                      AppStyles.styleMedium20().copyWith(color: Colors.white),
                ),
                const SizedBox(
                  width: 10,
                ),
                Image.asset(
                  Assets.imagesWallet,
                  fit: BoxFit.cover,
                  width: 24,
                  height: 24,
                )
              ],
            ),
            Text(
              '1,299.33 EGP',
              style: AppStyles.styleBold24().copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
