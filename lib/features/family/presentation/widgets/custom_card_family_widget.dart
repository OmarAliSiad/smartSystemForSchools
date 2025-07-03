import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/assets.dart';
import '../../../child_details_view/views/child_details_view.dart';
import '../../../settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../core/models/get_child_details/result.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/custom_button_transfer.dart';

class CustomCardFaimlyWidget extends StatelessWidget {
  final ResultForChildDetails childDetailsModel;
  const CustomCardFaimlyWidget({
    super.key,
    required this.childDetailsModel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        // Check if ThemeModeCubit is available
        final themeModeCubit = context.read<ThemeModeCubit>();

        final themeMode = themeModeCubit.currentTheme;
        return _buildCardContent(context, themeMode);
      },
    );
  }

  Widget _buildCardContent(BuildContext context, ThemeMode themeMode) {
    return Container(
      decoration: ShapeDecoration(
        color: themeMode == ThemeMode.dark ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadows: <BoxShadow>[
          BoxShadow(
            color: themeMode == ThemeMode.dark
                ? const Color(0xFFFFFFFF).withOpacity(.4)
                : const Color(0x3F000000),
            blurRadius: 6,
            offset: const Offset(0, 0),
            spreadRadius: 0,
          )
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(
                  start: 15, top: 20, bottom: 25, end: 10),
              child: Column(
                children: [
                  Image.asset(
                    Assets.imagesPerson,
                    color: themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fit: BoxFit.cover,
                    width: 52,
                    height: 52,
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(
                      childDetailsModel.fullName ?? 'Unknown Child',
                      style: AppStyles.styleMedium16(),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                    top: 21, bottom: 15, end: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.family_Balance.tr(),
                      style: AppStyles.styleRegular16(),
                    ),
                    Text(
                      childDetailsModel.amountOfMoney.toString(),
                      style: AppStyles.styleMedium16().copyWith(
                        color: const Color(0xFF5CC2F2),
                      ),
                    ),
                    Text(
                      LocaleKeys.family_dailySpendingLimit.tr(),
                      style: AppStyles.styleMedium16(),
                    ),
                    Text(
                      '100 EGP',
                      style: AppStyles.styleMedium16().copyWith(
                        color: const Color(0xFF5CC2F2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 10),
              child: CustomButtonTransfer(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (contex) {
                    return ChildDetailsView(
                      resultForChildDetails: childDetailsModel,
                    );
                  }));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
