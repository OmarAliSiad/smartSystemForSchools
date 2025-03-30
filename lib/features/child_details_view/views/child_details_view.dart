import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsystemforschools/core/models/get_child_details/result.dart';
import 'package:smartsystemforschools/core/models/payment_checkout_model/payment_checkout_model.dart';
import 'package:smartsystemforschools/core/utils/Constants.dart';
import 'package:smartsystemforschools/core/utils/custom_app_bar.dart';
import 'package:smartsystemforschools/core/utils/custom_button.dart';
import 'package:smartsystemforschools/core/widgets/custom_bottom_container.dart';
import 'package:smartsystemforschools/core/widgets/spare.dart';
import 'package:smartsystemforschools/features/Allergies/data/manager/assing_allegris/allegris.dart';
import 'package:smartsystemforschools/features/child_details_view/manager/spending_limit_cubit.dart/spending_limit_cubit.dart';
import 'package:smartsystemforschools/features/child_details_view/manager/models/get_sending_limit/get_sending_limit.dart';
import 'package:smartsystemforschools/features/child_details_view/widgets/custom_card_spending_limits.dart';
import 'package:smartsystemforschools/features/payment/presentation/manager/cubit/payment_cubit.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/utils/assets.dart';
import '../widgets/CardDetailsChildWidget.dart';
import '../widgets/CustomCardForSpendingAndRecharge.dart';
import '../widgets/custom_allgeries_widget.dart';

class ChildDetailsView extends StatefulWidget {
  static const String id = 'ChildDetailsView';
  final ResultForChildDetails resultForChildDetails;
  const ChildDetailsView({super.key, required this.resultForChildDetails});

  @override
  State<ChildDetailsView> createState() => _ChildDetailsViewState();
}

class _ChildDetailsViewState extends State<ChildDetailsView> {
  late PaymentCheckoutModel checkoutPaymentModel;
  GetSendingLimit? getSendingLimit;
  TextEditingController amountController = TextEditingController();
  TextEditingController dailyLimitController = TextEditingController();
  bool isLoading = true;

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    try {
      final GetSendingLimit? result;
      await Future.value([
        result = await context.read<SpendingLimitCubit>().getSpendingLimit(
            studentId: widget.resultForChildDetails.id.toString()),
        context
            .read<AllergiesCubit>()
            .getAllegrisForStudent(widget.resultForChildDetails.id.toString()),
      ]);
      if (result != null) {
        setState(() {
          getSendingLimit = result;
        });
      }
    } catch (e) {
      print("Error loading spending limit: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        ThereIsicon: false,
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        color: Colors.blue.shade900,
        onRefresh: () async {
          await loadData();
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.only(start: 18, end: 19),
                    child: CardDetailsChildWidget(
                        receviedData: widget.resultForChildDetails),
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 200.ms)
                      .slideY(begin: 0.05, end: 0),
                  const SizedBox(
                    height: 28,
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.only(start: 18, end: 22),
                    child: Column(
                      children: [
                        CustomCardSpendingLimits(
                          studentId: widget.resultForChildDetails.id.toString(),
                        )
                            .animate()
                            .fadeIn(duration: 300.ms, delay: 300.ms)
                            .slideY(begin: 0.05, end: 0),
                        const SizedBox(
                          height: 18,
                        ),
                        if (getSendingLimit != null) _buildLimitsSection(),
                        const SizedBox(
                          height: 18,
                        ),
                        BlocBuilder<ThemeModeCubit, ThemeModeState>(
                          builder: (context, state) {
                            return CustomCardForSpendingAndRecharge(
                              title: LocaleKeys.childDetails_recharge.tr(),
                              price: widget.resultForChildDetails.amountOfMoney
                                  .toString(),
                              imagePath: Assets.imagesTrasnfer,
                              titleButton:
                                  LocaleKeys.childDetails_rechargeButton.tr(),
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(Constants.studentId,
                                    widget.resultForChildDetails.id.toString());
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return AccountScreen(
                                      resultForChildDetails:
                                          widget.resultForChildDetails,
                                    );
                                  }),
                                );
                              },
                            )
                                .animate()
                                .fadeIn(duration: 300.ms, delay: 500.ms)
                                .slideY(begin: 0.2, end: 0);
                          },
                        ),
                        const SizedBox(
                          height: 26,
                        ),
                        CustomAllergiesWidget(
                          childDetails: widget.resultForChildDetails,
                        )
                            .animate()
                            .fadeIn(duration: 300.ms, delay: 600.ms)
                            .slideY(begin: 0.05, end: 0),
                        const SizedBox(
                          height: 26,
                        ),
                        BlocBuilder<ThemeModeCubit, ThemeModeState>(
                          builder: (context, state) {
                            final themeMode =
                                context.read<ThemeModeCubit>().currentTheme;
                            return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: themeMode == ThemeMode.dark
                                  ? Colors.black
                                  : Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: themeMode == ThemeMode.dark
                                      ? Colors.black
                                      : Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: themeMode == ThemeMode.dark
                                          ? const Color(0xFFFFFFFF)
                                              .withOpacity(.4)
                                          : const Color(0xFF000000)
                                              .withOpacity(.2),
                                      blurRadius: 6,
                                      offset: const Offset(0, 0),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 16,
                                                end: 16,
                                                top: 8,
                                                bottom: 8),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'view spending details',
                                                    style: AppStyles
                                                        .styleMedium16(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: CustomButton(
                                                onPressed: () async {
                                                  SharedPreferences prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  prefs.setString(
                                                      Constants.studentId,
                                                      widget
                                                          .resultForChildDetails
                                                          .id
                                                          .toString());
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                      return AccountScreen(
                                                        resultForChildDetails:
                                                            widget
                                                                .resultForChildDetails,
                                                      );
                                                    }),
                                                  );
                                                },
                                                padding:
                                                    EdgeInsetsDirectional.zero,
                                                text: 'recharge',
                                                textStyle:
                                                    AppStyles.styleMedium12(),
                                                borderRadius: 5,
                                              ),
                                            )
                                          ],
                                        ))
                                    .animate()
                                    .fadeIn(duration: 300.ms, delay: 600.ms)
                                    .slideY(begin: 0.05, end: 0),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const CustomBottomContainer(
                    color: Colors.black,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLimitsSection() {
    final themeMode = context.read<ThemeModeCubit>().currentTheme;
    final isDarkMode = themeMode == ThemeMode.dark;

    return Card(
      elevation: 1,
      color: isDarkMode ? Colors.black : Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isDarkMode ? Colors.black : Colors.white,
          boxShadow: [
            BoxShadow(
              color: themeMode == ThemeMode.dark
                  ? const Color(0xFFFFFFFF).withOpacity(.4)
                  : const Color(0xFF000000).withOpacity(.2),
              blurRadius: 6,
              offset: const Offset(0, 0),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Limits', style: AppStyles.styleMedium16()),
              const SizedBox(height: 24),
              _buildLimitProgressBar(
                'Day',
                getSendingLimit?.result?.dailySpendingLimit ?? 0,
                const Color(0xff1A0F91),
              ),
              const SizedBox(height: 16),
              _buildLimitProgressBar(
                'Week',
                getSendingLimit?.result?.weeklySpendingLimit ?? 0,
                Colors.orange,
              ),
              const SizedBox(height: 16),
              _buildLimitProgressBar(
                'Month',
                getSendingLimit?.result?.monthlySpendingLimit ?? 0,
                Colors.green,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: 400.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildLimitProgressBar(String label, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppStyles.styleRegular14()),
            Text('${amount.toStringAsFixed(2)} Remaining',
                style: AppStyles.styleRegular14()),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              height: 8,
              width: amount, // Adjust width based on progress
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
// CustomCardForSpendingAndRecharge(
//   title: LocaleKeys.childDetails_dailySpendingLimit.tr(),
//   price: getSendingLimit?.result?.dailySpendingLimit
//           .toString() ??
//       '0',
//   imagePath: Assets.imagesShooping,
//   titleButton: LocaleKeys.childDetails_dailyLimit.tr(),
//   onPressed: () {
//     ShowDialogForDailyLimit(
//       dailyLimitController: dailyLimitController,
//       onPressed: () {
//         if (dailyLimitController.text.isEmpty) {
//           dispalySnackBar(context,
//               title: 'enter daily limit',
//               titleActionButton: 'ok',
//               color: Colors.red);
//         } else {
//           context
//               .read<SpendingLimitCubit>()
//               .addSpendingLimit(
//                 studentId: widget
//                     .resultForChildDetails.id
//                     .toString(),
//                 dailySpendingLimit: double.tryParse(
//                   dailyLimitController.text,
//                 ),
//               )
//               .then((response) {
//             if (response.statusCode == 200) {
//               dispalySnackBar(context,
//                   title: response.data['message'],
//                   titleActionButton: 'ok',
//                   color: Colors.green);
//             } else {
//               dispalySnackBar(context,
//                   title: response.data['message'],
//                   titleActionButton: 'ok',
//                   color: Colors.red);
//             }
//           });
//         }
//       },
//       borderSideColor:
//           context.read<ThemeModeCubit>().currentTheme ==
//                   ThemeMode.dark
//               ? Colors.white
//               : Colors.black.withOpacity(.20),
//       context: context,
//       hintText: LocaleKeys.childDetails_price.tr(),
//       hintTextStyle: AppStyles.styleRegular12(),
//       buttonCancelTitle:
//           LocaleKeys.childDetails_cancel.tr(),
//       buttonOkTitle: LocaleKeys.childDetails_edit.tr(),
//       title: LocaleKeys.childDetails_dailyLimit.tr(),
//       buttonOkColor: const Color(0xff1A0F91),
//       buttonCancelColor: const Color(0xffFF0000),
//       titleTextStyle: AppStyles.styleMedium18(),
//     );
//   },
// ),
