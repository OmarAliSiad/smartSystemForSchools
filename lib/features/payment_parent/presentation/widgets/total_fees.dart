import 'package:flutter/material.dart';
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
            const Text(
              "Subtotal",
              style: TextStyle(
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
                const Text(
                  "Processing Fees",
                  style: TextStyle(
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
              "${processingFee.toStringAsFixed(2)} EGP",
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
            "3EGP + 3.5%",
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
            const Text(
              "Total",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Constants.blue, //Color(0xFF00BCD4),,
              ),
            ),
            Text(
              "${total.toStringAsFixed(2)} EGP",
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
