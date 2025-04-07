import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import '../../../../core/utils/app_styles.dart';

class CustomTextFieldEditProfile extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? length;
  final bool enable;
  final String? vaildatorMessage;
  const CustomTextFieldEditProfile(
      {super.key,
      required this.title,
      required this.hintText,
      this.controller,
      this.keyboardType,
      this.length,
      required this.enable,
      this.vaildatorMessage});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyles.styleMedium16().copyWith(
            color: context.read<ThemeModeCubit>().currentTheme == ThemeMode.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          enabled: enable,
          maxLength: length,
          style: TextStyle(
              color: !enable
                  ? Colors.grey
                  : context.read<ThemeModeCubit>().currentTheme ==
                          ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
          keyboardType: keyboardType,
          controller: controller,
          maxLines: 1,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return vaildatorMessage;
            }
            return null;
          },
          cursorColor: Colors.black,
          decoration: InputDecoration(
            hintFadeDuration: const Duration(milliseconds: 400),
            hintText: hintText,
            hintStyle: AppStyles.styleRegular14(),
            border: buildOutlineBorder(),
            enabledBorder: buildOutlineBorder(),
            focusedBorder: buildOutlineBorder(),
          ),
        ),
      ],
    );
  }
}

OutlineInputBorder buildOutlineBorder({
  double borderRadius = 20,
}) {
  return OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(borderRadius),
      ),
      borderSide: const BorderSide(
        color: Colors.grey,
      ));
}
// height: 57,
// decoration: BoxDecoration(
//   color: Colors.white,
//   border: Border.all(color: Colors.grey),
//   borderRadius: BorderRadius.circular(20),
//   boxShadow: [
//     BoxShadow(
//       blurRadius: .3,
//       spreadRadius: 1,
//       offset: const Offset(0, 0),
//       color: Colors.black.withOpacity(0.02),
//     )
//   ],
// ),
