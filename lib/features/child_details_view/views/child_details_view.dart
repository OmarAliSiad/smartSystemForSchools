import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/core/models/get_child_details/result.dart';
import 'package:smartsystemforschools/core/utils/custom_app_bar.dart';
import 'package:smartsystemforschools/core/widgets/custom_bottom_container.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        ThereIsicon: false,
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
      body: Column(
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
                      buttonCancelTitle: LocaleKeys.childDetails_cancel.tr(),
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
                      price: '100 EGP',
                      imagePath: Assets.imagesTrasnfer,
                      titleButton: LocaleKeys.childDetails_rechargeButton.tr(),
                      onPressed: () {
                        ShowDialogForRecharge(
                          borderSideColor:
                              context.read<ThemeModeCubit>().currentTheme ==
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
                              buttonText: LocaleKeys.childDetails_close.tr(),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              buttonTextStyle: AppStyles.styleRegular16(),
                              imagePath: Assets.imagesSuccess,
                              title: LocaleKeys.childDetails_addedSuccessfully
                                  .tr(),
                              titleTextStyle: AppStyles.styleMedium16(),
                              height: 46,
                              width: 46,
                            );
                          },
                          hintText: LocaleKeys.childDetails_price.tr(),
                          hintTextStyle: AppStyles.styleRegular12(),
                          buttonCancelTitle:
                              LocaleKeys.childDetails_cancel.tr(),
                          buttonOkTitle:
                              LocaleKeys.childDetails_rechargeButton.tr(),
                          title: LocaleKeys.childDetails_recharge.tr(),
                          buttonOkColor: const Color(0xff1A0F91),
                          buttonCancelColor: const Color(0xffFF0000),
                          titleTextStyle: AppStyles.styleMedium18(),
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
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          const CustomBottomContainer(
            color: Colors.black,
          )
        ],
      ),
    );
  }
}
