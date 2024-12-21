import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/widgets/alertDialog.dart';
import '../manager/themeMode/theme_mode_cubit.dart';

Future<dynamic> showDialogProfile({
  required BuildContext context,
  required String title,
  required String subTitle,
  required String buttonOkTitle,
  required String buttonCancelTitle,
}) {
  return showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor:
            context.read<ThemeModeCubit>().currentTheme == ThemeMode.dark
                ? Colors.black
                : Colors.white,
        title: Center(
          child: Image.asset(
            Assets.imagesAlert,
            fit: BoxFit.scaleDown,
            width: 49,
            height: 49,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<ThemeModeCubit, ThemeModeState>(
              builder: (context, state) {
                return Text(
                  title,
                  style: AppStyles.styleMedium16(),
                );
              },
            ),
            const SizedBox(
              height: 3,
            ),
            BlocBuilder<ThemeModeCubit, ThemeModeState>(
              builder: (context, state) {
                return Text(
                  subTitle,
                  style: AppStyles.styleRegular14(),
                );
              },
            ),
          ],
        ),
        actions: <Widget>[
          CustomButtonAlertDailog(
            onPressed: () => Navigator.pop(context),
            colorFont: Colors.white,
            containerColor: const Color(0xffff0000),
            title: buttonCancelTitle,
          ),
          const SizedBox(
            width: 16,
          ),
          CustomButtonAlertDailog(
            onPressed: () => Navigator.pop(context),
            colorFont: Colors.black,
            containerColor: const Color(0xFFEEEEEE),
            title: buttonOkTitle,
          ),
        ],
      );
    },
  );
}
