import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';

import '../../../../core/utils/Constants.dart';

class PinCodeWidget extends StatelessWidget {
  final TextEditingController otpController;
  const PinCodeWidget({super.key, required this.otpController});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      controller: otpController,
      autoFocus: true,
      cursorColor: Colors.black,
      keyboardType: TextInputType.number,
      appContext: context,
      length: 4,
      obscureText: false,
      animationType: AnimationType.scale,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 98,
        borderWidth: 1,
        activeColor: Constants.blue,
        inactiveColor: Constants.grey,
        inactiveFillColor: Colors.white,
        activeFillColor: Constants.lightBlue,
        selectedColor: Constants.grey,
        selectedFillColor: Colors.white,
        fieldWidth: 77,
      ),
      animationDuration: const Duration(milliseconds: 300),
      textStyle: AppStyles.styleBold24(),
      backgroundColor:
          context.read<ThemeModeCubit>().currentTheme == ThemeMode.dark
              ? Colors.transparent
              : Colors.white,
      enableActiveFill: true,
      onCompleted: (value) {
        otpController.text = value;
        print("Completed");
      },
      onChanged: (value) {
        print(value);
      },
    );
  }
}
