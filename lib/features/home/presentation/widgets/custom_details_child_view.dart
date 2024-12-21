import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/custom_button_transfer.dart';
import '../../data/models/child_details_model.dart';

class CustomDetailsChildView extends StatelessWidget {
  final ChildDetailsModel childDetailsModel;
  const CustomDetailsChildView({
    super.key,
    required this.childDetailsModel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        final themeMode = context.read<ThemeModeCubit>().currentTheme;
        return Container(
          decoration: BoxDecoration(
            color: themeMode == ThemeMode.dark ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 6,
                offset: Offset(0, 0),
                spreadRadius: 0,
              )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 15, bottom: 10),
                child: Image.asset(
                  childDetailsModel.imagePath,
                  fit: BoxFit.cover,
                  width: 52,
                  height: 52,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      childDetailsModel.name,
                      style: AppStyles.styleRegular16(),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      childDetailsModel.price,
                      style: AppStyles.styleSemiBold14()
                          .copyWith(color: const Color(0xff1A0F91)),
                    )
                  ],
                ),
              ),
              const Spacer(),
              const CustomButtonTransfer()
            ],
          ),
        );
      },
    );
  }
}
