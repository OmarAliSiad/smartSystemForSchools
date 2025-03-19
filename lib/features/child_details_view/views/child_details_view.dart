import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/core/methods/show_scaffold_messanger.dart';
import 'package:smartsystemforschools/core/models/get_child_details/result.dart';
import 'package:smartsystemforschools/core/models/payment_checkout_model/payment_checkout_model.dart';
import 'package:smartsystemforschools/core/utils/custom_app_bar.dart';
import 'package:smartsystemforschools/core/utils/custom_button.dart';
import 'package:smartsystemforschools/core/utils/size_config.dart';
import 'package:smartsystemforschools/core/widgets/build_loading_view.dart';
import 'package:smartsystemforschools/core/widgets/custom_bottom_container.dart';
import 'package:smartsystemforschools/features/child_details_view/manager/cubit/checkout_payment_cubit.dart';
import 'package:smartsystemforschools/features/login/presenation/widgets/custom_text_field.dart';
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
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckoutPaymentCubit(),
      child: Scaffold(
        appBar: CustomAppBar(
          ThereIsicon: false,
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        body: BlocConsumer<CheckoutPaymentCubit, CheckoutPaymentState>(
          listener: (context, state) {
            if (state is CheckoutPaymentFailure) {
              dispalySnackBar(context,
                  color: Colors.red,
                  title: state.errMessage.toString(),
                  titleActionButton: 'ok');
            } else if (state is CheckoutPaymentLoaded) {
              checkoutPaymentModel = state.CheckoutPaymentModel!;
              dispalySnackBar(context,
                  color: Colors.green,
                  title: state.CheckoutPaymentModel!.message.toString(),
                  titleActionButton: 'ok');
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Stack(
                children: [
                  state is CheckoutPaymentLoading
                      ? SizedBox(
                          height: MediaQuery.sizeOf(context).height,
                          child: buildLoadingView('recharge', context))
                      : Column(
                          children: [
                            const SizedBox(
                              height: 24,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  start: 18, end: 19),
                              child: CardDetailsChildWidget(
                                  receviedData: widget.resultForChildDetails),
                            ),
                            const SizedBox(
                              height: 28,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  start: 18, end: 22),
                              child: Column(
                                children: [
                                  CustomCardForSpendingAndRecharge(
                                    title: LocaleKeys
                                        .childDetails_dailySpendingLimit
                                        .tr(),
                                    price: '40 EGP',
                                    imagePath: Assets.imagesShooping,
                                    titleButton:
                                        LocaleKeys.childDetails_dailyLimit.tr(),
                                    onPressed: () {
                                      ShowDialogForDailyLimit(
                                        borderSideColor: context
                                                    .read<ThemeModeCubit>()
                                                    .currentTheme ==
                                                ThemeMode.dark
                                            ? Colors.white
                                            : Colors.black.withOpacity(.20),
                                        context: context,
                                        hintText:
                                            LocaleKeys.childDetails_price.tr(),
                                        hintTextStyle:
                                            AppStyles.styleRegular12(),
                                        buttonCancelTitle:
                                            LocaleKeys.childDetails_cancel.tr(),
                                        buttonOkTitle:
                                            LocaleKeys.childDetails_edit.tr(),
                                        title: LocaleKeys
                                            .childDetails_dailyLimit
                                            .tr(),
                                        buttonOkColor: const Color(0xff1A0F91),
                                        buttonCancelColor:
                                            const Color(0xffFF0000),
                                        titleTextStyle:
                                            AppStyles.styleMedium18(),
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  BlocBuilder<ThemeModeCubit, ThemeModeState>(
                                    builder: (context, state) {
                                      return CustomCardForSpendingAndRecharge(
                                        title: LocaleKeys.childDetails_recharge
                                            .tr(),
                                        price: '100 EGP',
                                        imagePath: Assets.imagesTrasnfer,
                                        titleButton: LocaleKeys
                                            .childDetails_rechargeButton
                                            .tr(),
                                        onPressed: () {
                                          ShowDialogForRecharge(
                                            borderSideColor: context
                                                        .read<ThemeModeCubit>()
                                                        .currentTheme ==
                                                    ThemeMode.dark
                                                ? Colors.white
                                                : Colors.black.withOpacity(.20),
                                            context: context,
                                            onPressedOk: () {
                                              Navigator.of(context).pop();
                                              ShowDialogForAddedAndTransfer(
                                                context: context,
                                                borderRadius: 20,
                                                borderRadiusButton: 5,
                                                buttonText: LocaleKeys
                                                    .childDetails_close
                                                    .tr(),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                buttonTextStyle:
                                                    AppStyles.styleRegular16(),
                                                imagePath: Assets.imagesSuccess,
                                                title: LocaleKeys
                                                    .childDetails_addedSuccessfully
                                                    .tr(),
                                                titleTextStyle:
                                                    AppStyles.styleMedium16(),
                                                height: 46,
                                                width: 46,
                                              );
                                            },
                                            hintText: LocaleKeys
                                                .childDetails_price
                                                .tr(),
                                            hintTextStyle:
                                                AppStyles.styleRegular12(),
                                            buttonCancelTitle: LocaleKeys
                                                .childDetails_cancel
                                                .tr(),
                                            buttonOkTitle: LocaleKeys
                                                .childDetails_rechargeButton
                                                .tr(),
                                            title: LocaleKeys
                                                .childDetails_recharge
                                                .tr(),
                                            buttonOkColor:
                                                const Color(0xff1A0F91),
                                            buttonCancelColor:
                                                const Color(0xffFF0000),
                                            titleTextStyle:
                                                AppStyles.styleMedium18(),
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
                                      final themeMode = context
                                          .read<ThemeModeCubit>()
                                          .currentTheme;
                                      return Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        color: themeMode == ThemeMode.dark
                                            ? Colors.black
                                            : Colors.white,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: themeMode == ThemeMode.dark
                                                ? Colors.black
                                                : Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: themeMode ==
                                                        ThemeMode.dark
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
                                                  const EdgeInsetsDirectional
                                                      .only(
                                                      start: 16,
                                                      end: 16,
                                                      top: 8,
                                                      bottom: 8),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Recent Transactions',
                                                          style: AppStyles
                                                              .styleMedium16(),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        SizedBox(
                                                          height: 55,
                                                          width: 140,
                                                          child:
                                                              CustomTextField(
                                                            keyboardType:
                                                                const TextInputType
                                                                    .numberWithOptions(),
                                                            hintText:
                                                                'enter amount',
                                                            obsure: false,
                                                            controller:
                                                                amountController,
                                                            borderRaduis: 5,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: CustomButton(
                                                      onPressed: () {
                                                        if (amountController
                                                            .text.isEmpty) {
                                                          dispalySnackBar(
                                                              context,
                                                              title:
                                                                  'enter amount',
                                                              titleActionButton:
                                                                  LocaleKeys
                                                                      .policy_ok
                                                                      .tr(),
                                                              color:
                                                                  Colors.red);
                                                        } else {
                                                          log(amountController
                                                              .text);
                                                          context
                                                              .read<
                                                                  CheckoutPaymentCubit>()
                                                              .checkoutPayment(
                                                                amount: amountController
                                                                    .text
                                                                    .toString(),
                                                                studentId: widget
                                                                    .resultForChildDetails
                                                                    .id
                                                                    .toString(),
                                                              );
                                                          log('checkoutPaymentModel ${checkoutPaymentModel.toJson().toString()}');
                                                        }
                                                      },
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .zero,
                                                      text: 'recharge',
                                                      textStyle: AppStyles
                                                          .styleMedium12(),
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
            );
          },
        ),
      ),
    );
  }
}
