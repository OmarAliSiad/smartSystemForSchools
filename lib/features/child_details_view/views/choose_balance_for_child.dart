import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/core/methods/show_scaffold_messanger.dart';
import 'package:smartsystemforschools/core/models/money_recharge_model/money_recharge_model.dart';
import 'package:smartsystemforschools/core/utils/Constants.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import 'package:smartsystemforschools/core/widgets/total_fees.dart';
import 'package:smartsystemforschools/features/payment/presentation/manager/cubit/payment_cubit.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';

class ChooseBalanceForChild extends StatefulWidget {
  final double balance;
  final String studentId;
  const ChooseBalanceForChild({
    super.key,
    required this.balance,
    required this.studentId,
  });

  @override
  State<ChooseBalanceForChild> createState() => _ChooseBalanceForChildState();
}

class _ChooseBalanceForChildState extends State<ChooseBalanceForChild> {
  // final amountOptions = [200, 400, 600, 1000, 2000];
  final amountOptions = [10, 20, 50, 100, 1000];
  int? selectedAmount = 20;
  final TextEditingController customAmountController = TextEditingController();
  bool isCustomAmount = false;
  late MoneyRechargeModel checkoutPaymentModel;
  double get processingFee {
    final amount = selectedAmount ?? 0;
    return amount + 0.000;
    // 3 + (amount * 0.035);
  }

  double get total {
    final amount = selectedAmount ?? 0;
    // return amount + processingFee;
    return amount + 0.000;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: Text(
          "Recharge",
          style: AppStyles.styleMedium18(),
        ),
      ),
      body: isCustomAmount
          ? _buildCustomAmountView(context)
          : _buildPredefinedAmountView(),
    );
  }

  Widget _buildPredefinedAmountView() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Amount options
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    ...amountOptions.map(
                      (amount) => _buildAmountOption(amount)
                          .animate()
                          .fade(
                              duration: 600.ms,
                              delay: 200.ms * amountOptions.indexOf(amount))
                          .slideY(begin: 0.2, end: 0),
                    ),
                    _buildAmountOption("other", isText: true)
                        .animate()
                        .fade(duration: 600.ms, delay: 1200.ms)
                        .slideY(begin: 0.2, end: 0),
                  ],
                ),
                TotalFees(
                  total: total,
                  selectedAmount: selectedAmount,
                  processingFee: processingFee,
                )
                    .animate()
                    .fade(duration: 600.ms, delay: 1400.ms)
                    .slideY(begin: 0.2, end: 0),
              ],
            ),
          ),
        ),
        // Terms and conditions
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Credit recharges are non-refundable.",
                style: TextStyle(fontSize: 14),
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "By tapping recharge you agree to the",
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    "credit card load-up terms and conditions.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Constants.blue, //Color(0xFF00BCD4),,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Recharge button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedAmount != null) {
                      context.read<PaymentCubit>().setMoneyForChild(
                            amountOfMoney: selectedAmount!.toDouble(),
                            studentId: widget.studentId,
                          );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.blue, //Color(0xFF00BCD4),,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Recharge at Repton",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        )
            .animate()
            .fade(duration: 600.ms, delay: 1400.ms)
            .slideY(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildCustomAmountView(BuildContext context) {
    final isDark =
        context.read<ThemeModeCubit>().currentTheme == ThemeMode.dark;
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsetsDirectional.symmetric(horizontal: 40),
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withOpacity(0.2)
                              : Colors.grey.shade200,
                          offset: const Offset(0.0, 1.0),
                          blurRadius: 6.0,
                        ),
                      ]),
                  child: TextFormField(
                    cursorColor: isDark ? Colors.white : Colors.black,
                    controller: customAmountController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: "Enter Amount",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        final amount = int.tryParse(value);
                        if (amount != null) {
                          setState(() {
                            selectedAmount = amount;
                          });
                        }
                      } else {
                        setState(() {
                          selectedAmount = null;
                        });
                      }
                    },
                  ),
                )
                    .animate()
                    .fade(duration: 600.ms, delay: 200.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                if (customAmountController.text.isEmpty ||
                    (int.tryParse(customAmountController.text) ?? 0) < 1 ||
                    (int.tryParse(customAmountController.text) ?? 0) > 2000)
                  Container(
                    padding: const EdgeInsetsDirectional.symmetric(
                      vertical: 30,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withOpacity(0.2)
                              : Colors.grey.shade200,
                          offset: const Offset(0.0, 1.0),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: const Text(
                      "Please enter a whole number between 1 and 2000",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                      .animate()
                      .fade(duration: 600.ms, delay: 200.ms)
                      .slideY(begin: 0.2, end: 0),
                if (customAmountController.text.isNotEmpty &&
                    (int.tryParse(customAmountController.text) ?? 0) >= 1 &&
                    (int.tryParse(customAmountController.text) ?? 0) <= 2000)
                  TotalFees(
                    total: total,
                    selectedAmount: selectedAmount,
                    processingFee: processingFee,
                  )
                      .animate()
                      .fade(duration: 600.ms, delay: 200.ms)
                      .slideY(begin: 0.2, end: 0),
              ],
            ),
          ),
        ),
        // Terms and conditions
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "Credit recharges are non-refundable.",
                style: TextStyle(fontSize: 14),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "By tapping recharge you agree to the ",
                    style: TextStyle(fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Open terms and conditions
                    },
                    child: const Text(
                      "credit card load-up terms and conditions.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Constants.blue, //Color(0xFF00BCD4),,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Recharge button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (customAmountController.text.isNotEmpty &&
                        (int.tryParse(customAmountController.text) ?? 0) >= 1 &&
                        (int.tryParse(customAmountController.text) ?? 0) <=
                            2000) {
                      context.read<PaymentCubit>().setMoneyForChild(
                            studentId: widget.studentId,
                            amountOfMoney: double.parse(
                              customAmountController.text.trim(),
                            ),
                          );
                    } else {
                      dispalySnackBar(
                        context,
                        title: "Please enter a whole number between 1 and 2000",
                        titleActionButton: "OK",
                        color: Colors.red,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.blue, //Color(0xFF00BCD4),,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Recharge at Repton",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              )
            ],
          )
              .animate()
              .fade(duration: 600.ms, delay: 400.ms)
              .slideY(begin: 0.2, end: 0),
        ),
      ],
    );
  }

  Widget _buildAmountOption(dynamic amount, {bool isText = false}) {
    final isSelected = !isText && selectedAmount == amount;
    final isDark =
        context.read<ThemeModeCubit>().currentTheme == ThemeMode.dark;
    return GestureDetector(
        onTap: () {
          setState(() {
            if (isText) {
              isCustomAmount = true;
            } else {
              selectedAmount = amount;
            }
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeIn,
          decoration: BoxDecoration(
            color: isSelected
                ? Constants.blue //Color(0xFF00BCD4),
                : isDark
                    ? const Color(0xFF2A2A2A)
                    : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            isText ? amount.toString() : "\$${amount.toString()}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : isDark
                      ? Colors.white
                      : Colors.black,
            ),
          ),
        ));
  }
}

Widget buildPaymentOption(String label, bool isSelected) {
  return Row(
    children: [
      Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: isSelected
              ? Constants.blue /*Color(0xFF00BCD4),*/
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                isSelected ? Constants.blue /*Color(0xFF00BCD4)*/ : Colors.grey,
            width: 2,
          ),
        ),
        child: isSelected
            ? const Icon(
                Icons.check,
                size: 12,
                color: Colors.white,
              )
            : null,
      ),
      const SizedBox(width: 10),
      Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color:
              isSelected ? Constants.blue /*Color(0xFF00BCD4),*/ : Colors.grey,
        ),
      ),
    ],
  );
}

class FilterButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isPrimary;
  final VoidCallback onPressed;

  const FilterButton({
    super.key,
    required this.text,
    required this.isSelected,
    this.isPrimary = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary
            ? Constants.blue //Color(0xFF00BCD4),
            : (isSelected ? Colors.white : Colors.grey.shade200),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isPrimary
              ? BorderSide.none
              : (isSelected
                  ? const BorderSide(color: Colors.grey, width: 1)
                  : BorderSide.none),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isPrimary ? Colors.white : Colors.black,
          fontSize: 14,
        ),
      ),
    );
  }
}
