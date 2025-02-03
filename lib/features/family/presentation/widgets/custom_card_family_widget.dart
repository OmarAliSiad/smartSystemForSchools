import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/features/child_details_view/views/child_details_view.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import '../../../../core/models/child_details_model.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/custom_button_transfer.dart';

class CustomCardFaimlyWidget extends StatelessWidget {
  final ChildDetailsModel childDetailsModel;
  const CustomCardFaimlyWidget({
    super.key,
    required this.childDetailsModel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        final themeMode = context.read<ThemeModeCubit>().currentTheme;
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(
                    start: 15, top: 20, bottom: 25, end: 19),
                child: Column(
                  children: [
                    Image.asset(
                      childDetailsModel.imagePath,
                      fit: BoxFit.cover,
                      width: 52,
                      height: 52,
                    ),
                    Text(
                      childDetailsModel.name,
                      style: AppStyles.styleMedium16(),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                    top: 21, bottom: 15, end: 37),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Balance',
                      style: AppStyles.styleRegular16(),
                    ),
                    Text(
                      '100 EGP',
                      style: AppStyles.styleMedium16().copyWith(
                        color: const Color(0xFF5CC2F2),
                      ),
                    ),
                    Text(
                      'Daily spending limit',
                      style: AppStyles.styleMedium16(),
                    ),
                    Text(
                      '40 EGP',
                      style: AppStyles.styleMedium16().copyWith(
                        color: const Color(0xFF5CC2F2),
                      ),
                    ),
                  ],
                ),
              ),
              CustomButtonTransfer(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(ChildDetailsView.id, arguments: {
                    'childDetailsModel': childDetailsModel,
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
