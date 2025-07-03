import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/features/payment_parent/presentation/widgets/custom_app_bar_spare_recharge_widget.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';
import '../../../core/methods/show_scaffold_messanger.dart';
import '../../../core/models/money_recharge_model/money_recharge_model.dart';
import '../../../core/utils/Constants.dart';
import '../../../core/widgets/build_loading_view.dart';
import '../../payment_parent/presentation/widgets/total_fees.dart';
import '../../payment/presentation/manager/cubit/payment_cubit.dart';
import '../../settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import 'package:easy_localization/easy_localization.dart';

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
  PaymentCubit? _paymentCubit;
  ThemeModeCubit? _themeModeCubit;
  bool _isDisposed = false;
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
  void initState() {
    super.initState();
    // Ensure we're not accessing context during animation setup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {}); // Safely trigger a rebuild when mounted
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _paymentCubit = context.read<PaymentCubit>();
    _themeModeCubit = context.read<ThemeModeCubit>();
  }

  @override
  void dispose() {
    _isDisposed = true;
    customAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (!mounted || _isDisposed) return;

        if (state is SetMoneySuccess) {
          dispalySnackBar(
            context,
            title: LocaleKeys.spare_MoneyRechargedSuccessfully.tr(),
            titleActionButton: LocaleKeys.spare_ok.tr(),
            color: Colors.green,
          );
          Navigator.pop(context);
        } else if (state is SetMoneyFailure) {
          dispalySnackBar(
            context,
            title: state.errorMessage,
            titleActionButton: LocaleKeys.spare_ok.tr(),
            color: Colors.red,
          );
        }
      },
      child: Scaffold(
          appBar: CustomAppBarSpareAndRechargeWidget(
              title: LocaleKeys.spare_Recharge.tr()),
          body: BlocBuilder<PaymentCubit, PaymentState>(
            builder: (context, state) {
              if (state is SetMoneyLoading) {
                return buildLoadingView(
                  LocaleKeys.spare_Recharge.tr(),
                  context,
                );
              }
              return isCustomAmount
                  ? _buildCustomAmountView(context)
                  : _buildPredefinedAmountView();
            },
          )),
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
                      (amount) {
                        if (!mounted) return Container(); // Safety check
                        return _buildAmountOption(amount)
                            .animate(
                              // Set onPlay and other animation properties safely
                              onPlay: (controller) {
                                if (!mounted || _isDisposed) controller.stop();
                              },
                            )
                            .fade(
                                duration: 600.ms,
                                delay: 200.ms * amountOptions.indexOf(amount))
                            .slideY(begin: 0.2, end: 0);
                      },
                    ),
                    _buildAmountOption(LocaleKeys.spare_Other.tr(),
                            isText: true)
                        .animate(
                          onPlay: (controller) {
                            if (!mounted || _isDisposed) controller.stop();
                          },
                        )
                        .fade(duration: 600.ms, delay: 1200.ms)
                        .slideY(begin: 0.2, end: 0),
                  ],
                ),
                TotalFees(
                  total: total,
                  selectedAmount: selectedAmount,
                  processingFee: processingFee,
                )
                    .animate(
                      onPlay: (controller) {
                        if (!mounted) controller.stop();
                      },
                    )
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
              Text(
                LocaleKeys.spare_creditRechargesAreNonRefundable.tr(),
                style: const TextStyle(fontSize: 14),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.spare_byTappingRecharge.tr(),
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    LocaleKeys.spare_creditCardLoadUpTermsAndConditions.tr(),
                    style: const TextStyle(
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
                    if (selectedAmount != null &&
                        mounted &&
                        _paymentCubit != null) {
                      _paymentCubit!
                          .setMoneyForChild(
                            amountOfMoney: selectedAmount!.toDouble(),
                            studentId: widget.studentId,
                          )
                          .then((value) {});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.blue, //Color(0xFF00BCD4),,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    LocaleKeys.spare_Recharge.tr(),
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        )
            .animate(
              onPlay: (controller) {
                if (!mounted) controller.stop();
              },
            )
            .fade(duration: 600.ms, delay: 1400.ms)
            .slideY(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildCustomAmountView(BuildContext context) {
    final isDark = _themeModeCubit?.currentTheme == ThemeMode.dark;
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
                    decoration: InputDecoration(
                      hintText: LocaleKeys.spare_enterAmount.tr(),
                      hintStyle: const TextStyle(color: Colors.grey),
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      if (!mounted || _isDisposed) return;

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
                    .animate(
                      onPlay: (controller) {
                        if (!mounted) controller.stop();
                      },
                    )
                    .fade(duration: 600.ms, delay: 200.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                if (customAmountController.text.isEmpty ||
                    (int.tryParse(customAmountController.text) ?? 0) < 1 ||
                    (int.tryParse(customAmountController.text) ?? 0) > 2000)
                  Container(
                    padding: const EdgeInsetsDirectional.symmetric(
                        vertical: 30, horizontal: 10),
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
                    child: Text(
                      LocaleKeys.spare_pleaseEnterAWholeNumberBetween1And10000
                          .tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                      .animate(
                        onPlay: (controller) {
                          if (!mounted) controller.stop();
                        },
                      )
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
                      .animate(
                        onPlay: (controller) {
                          if (!mounted) controller.stop();
                        },
                      )
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
              Text(
                LocaleKeys.spare_creditRechargesAreNonRefundable.tr(),
                style: const TextStyle(fontSize: 14),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.spare_byTappingRecharge.tr(),
                    style: const TextStyle(fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Open terms and conditions
                    },
                    child: Text(
                      LocaleKeys.spare_creditCardLoadUpTermsAndConditions.tr(),
                      style: const TextStyle(
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
                            2000 &&
                        mounted &&
                        _paymentCubit != null) {
                      _paymentCubit!.setMoneyForChild(
                        studentId: widget.studentId,
                        amountOfMoney: double.parse(
                          customAmountController.text.trim(),
                        ),
                      );
                    } else if (mounted) {
                      dispalySnackBar(
                        context,
                        title: LocaleKeys
                            .spare_pleaseEnterAWholeNumberBetween1And10000
                            .tr(),
                        titleActionButton: LocaleKeys.spare_ok.tr(),
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
                  child: Text(
                    LocaleKeys.spare_Recharge.tr(),
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              )
            ],
          )
              .animate(
                onPlay: (controller) {
                  if (!mounted) controller.stop();
                },
              )
              .fade(duration: 600.ms, delay: 400.ms)
              .slideY(begin: 0.2, end: 0),
        ),
      ],
    );
  }

  Widget _buildAmountOption(dynamic amount, {bool isText = false}) {
    final isSelected = !isText && selectedAmount == amount;
    final isDark = _themeModeCubit?.currentTheme == ThemeMode.dark;
    return GestureDetector(
        onTap: () {
          if (mounted && !_isDisposed) {
            setState(() {
              if (isText) {
                isCustomAmount = true;
              } else {
                selectedAmount = amount;
              }
            });
          }
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
