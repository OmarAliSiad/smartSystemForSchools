import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsystemforschools/core/models/get_child_details/result.dart';
import 'package:smartsystemforschools/core/models/payment_checkout_model/payment_checkout_model.dart';
import 'package:smartsystemforschools/core/utils/Constants.dart';
import 'package:smartsystemforschools/core/utils/custom_app_bar.dart';
import 'package:smartsystemforschools/core/utils/custom_button.dart';
import 'package:smartsystemforschools/core/widgets/custom_bottom_container.dart';
import 'package:smartsystemforschools/core/widgets/spare.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';
import '../../../core/methods/showDialog.dart';
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
  TextEditingController amountController = TextEditingController();
  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
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
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 18, end: 19),
                  child: CardDetailsChildWidget(
                      receviedData: widget.resultForChildDetails),
                ),
                const SizedBox(
                  height: 28,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 18, end: 22),
                  child: Column(
                    children: [
                      CustomCardForSpendingAndRecharge(
                        title: LocaleKeys.childDetails_dailySpendingLimit.tr(),
                        price: '40 EGP',
                        imagePath: Assets.imagesShooping,
                        titleButton: LocaleKeys.childDetails_dailyLimit.tr(),
                        onPressed: () {
                          ShowDialogForDailyLimit(
                            borderSideColor:
                                context.read<ThemeModeCubit>().currentTheme ==
                                        ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black.withOpacity(.20),
                            context: context,
                            hintText: LocaleKeys.childDetails_price.tr(),
                            hintTextStyle: AppStyles.styleRegular12(),
                            buttonCancelTitle:
                                LocaleKeys.childDetails_cancel.tr(),
                            buttonOkTitle: LocaleKeys.childDetails_edit.tr(),
                            title: LocaleKeys.childDetails_dailyLimit.tr(),
                            buttonOkColor: const Color(0xff1A0F91),
                            buttonCancelColor: const Color(0xffFF0000),
                            titleTextStyle: AppStyles.styleMedium18(),
                          );
                        },
                      ),
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
                          );
                        },
                      ),
                      const SizedBox(
                        height: 26,
                      ),
                      CustomAllergiesWidget(
                        childDetails: widget.resultForChildDetails,
                      ),
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
                                  padding: const EdgeInsetsDirectional.only(
                                      start: 16, end: 16, top: 8, bottom: 8),
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
                                              style: AppStyles.styleMedium16(),
                                            ),
                                            // const SizedBox(
                                            //   height: 5,
                                            // ),
                                            // SizedBox(
                                            //   height: 55,
                                            //   width: 140,
                                            //   child:
                                            //       CustomTextField(
                                            //     keyboardType:
                                            //         const TextInputType
                                            //             .numberWithOptions(),
                                            //     hintText:
                                            //         'enter amount',
                                            //     obsure: false,
                                            //     controller:
                                            //         amountController,
                                            //     borderRaduis: 5,
                                            //   ),
                                            // ),
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
                                                widget.resultForChildDetails.id
                                                    .toString());
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                return AccountScreen(
                                                  resultForChildDetails: widget
                                                      .resultForChildDetails,
                                                );
                                              }),
                                            );
                                          },
                                          padding: EdgeInsetsDirectional.zero,
                                          text: 'recharge',
                                          textStyle: AppStyles.styleMedium12(),
                                          borderRadius: 5,
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                          );
                        },
                      )
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
    );
  }
}
