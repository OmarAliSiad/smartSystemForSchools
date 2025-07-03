import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';
import '../../../../core/utils/Constants.dart';

class TotalFees extends StatelessWidget {
  final int? selectedAmount;
  final double processingFee;
  final double total;
  const TotalFees(
      {super.key,
      this.selectedAmount,
      required this.total,
      required this.processingFee});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        // Subtotal
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.spare_Subtotal.tr(),
              style: const TextStyle(
                fontSize: 16,
                color: Constants.blue, //Color(0xFF00BCD4),,
              ),
            ),
            Text(
              "${selectedAmount?.toStringAsFixed(2) ?? 0.0} EGP",
              style: const TextStyle(
                fontSize: 16,
                color: Constants.blue, //Color(0xFF00BCD4),,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Processing Fees
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  LocaleKeys.spare_processingFees.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Constants.blue, //Color(0xFF00BCD4),,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
            Text(
              "${processingFee.toStringAsFixed(2)} ${LocaleKeys.spare_EGP.tr()}",
              style: const TextStyle(
                fontSize: 16,
                color: Constants.blue, //Color(0xFF00BCD4),,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "0EGP + 0.0%",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
        // Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Text(
              LocaleKeys.spare_total.tr(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Constants.blue, //Color(0xFF00BCD4),,
              ),
            ),
            Text(
              "${total.toStringAsFixed(2)} ${LocaleKeys.spare_EGP.tr()}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Constants.blue, //Color(0xFF00BCD4),,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
