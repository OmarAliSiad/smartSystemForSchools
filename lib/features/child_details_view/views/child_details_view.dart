import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/core/utils/custom_app_bar.dart';
import 'package:smartsystemforschools/core/widgets/custom_bottom_container.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import '../../../core/methods/showDialog.dart';
import '../../../core/models/child_details_model.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/utils/assets.dart';
import '../widgets/CardDetailsChildWidget.dart';
import '../widgets/CustomCardForSpendingAndRecharge.dart';
import '../widgets/custom_allgeries_widget.dart';

class ChildDetailsView extends StatefulWidget {
  static const String id = 'ChildDetailsView';
  const ChildDetailsView({super.key});

  @override
  State<ChildDetailsView> createState() => _ChildDetailsViewState();
}

class _ChildDetailsViewState extends State<ChildDetailsView> {
  @override
  Widget build(BuildContext context) {
    final receviedData = ModalRoute.of(context)!.settings.arguments
        as Map<String, ChildDetailsModel>;
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
                receviedData: receviedData['childDetailsModel']!),
          ),
          const SizedBox(
            height: 28,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 18, end: 22),
            child: Column(
              children: [
                CustomCardForSpendingAndRecharge(
                  title: 'Daily Spending Limit',
                  price: '40 EGP',
                  imagePath: Assets.imagesShooping,
                  titleButton: 'Daily limit',
                  onPressed: () {
                    ShowDialogForDailyLimit(
                      borderSideColor:
                          context.read<ThemeModeCubit>().currentTheme ==
                                  ThemeMode.dark
                              ? Colors.white
                              : Colors.black.withOpacity(.20),
                      context: context,
                      hintText: 'Price',
                      hintTextStyle: AppStyles.styleRegular12(),
                      buttonCancelTitle: 'Cancel',
                      buttonOkTitle: 'Edit',
                      title: 'Daily Limit',
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
                      title: 'Recharge',
                      price: '100 EGP',
                      imagePath: Assets.imagesTrasnfer,
                      titleButton: 'Recharge',
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
                              buttonText: 'Close',
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              buttonTextStyle: AppStyles.styleRegular16(),
                              imagePath: Assets.imagesSuccess,
                              title: 'Added Successfully',
                              titleTextStyle: AppStyles.styleMedium16(),
                              height: 46,
                              width: 46,
                            );
                          },
                          hintText: 'Price',
                          hintTextStyle: AppStyles.styleRegular12(),
                          buttonCancelTitle: 'Cancel',
                          buttonOkTitle: 'Recharge',
                          title: 'Recharge',
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
                const CustomAllergiesWidget(),
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
