import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smartsystemforschools/core/methods/show_scaffold_messanger.dart';
import 'package:smartsystemforschools/core/methods/vaildate_password.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/widgets/custom_bottom_container.dart';
import '../../../main_screen/presentation/views/main_screen.dart';
import '../widgets/custom_logo.dart';
import '../widgets/user_info.dart';

class ForgotPassword extends StatefulWidget {
  static String id = 'ForgotPassword';
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isObsure1 = true;
  bool isObsure2 = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formState,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(
              height: 62,
            ),
            const CustomLogo(),
            const SizedBox(
              height: 92,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 30, end: 44),
                  child: Text(
                    LocaleKeys.ForgotPassword_title.tr(),
                    style: AppStyles.styleSemiBold20(),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 29, end: 35),
                  child: Text(
                    LocaleKeys.ForgotPassword_subtitle.tr(),
                    style: AppStyles.styleMedium12().copyWith(
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 22,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 29,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserInfo(
                    title: LocaleKeys.ForgotPassword_newPassword.tr(),
                    hintText: LocaleKeys.ForgotPassword_newPasswordHint.tr(),
                    obsure: isObsure1,
                    controller: passwordController,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isObsure1 = !isObsure1;
                        });
                      },
                      icon: isObsure1
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                    ),
                    validator: (value) {
                      return vaildatePassword(value, passwordController);
                    },
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  UserInfo(
                    title: LocaleKeys.ForgotPassword_confirmPassword.tr(),
                    hintText:
                        LocaleKeys.ForgotPassword_confirmPasswordHint.tr(),
                    obsure: isObsure2,
                    controller: confirmPasswordController,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isObsure2 = !isObsure2;
                        });
                      },
                      icon: isObsure2
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                    ),
                    validator: (value) {
                      return vaildatePassword(value, confirmPasswordController);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 43,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 14,
              ),
              child: CustomButton(
                padding: const EdgeInsetsDirectional.symmetric(vertical: 14.5),
                text: LocaleKeys.ForgotPassword_button.tr(),
                textStyle: AppStyles.styleSemiBold14(),
                borderRadius: 20,
                onPressed: () {
                  if (formState.currentState!.validate()) {
                    if (passwordController.text ==
                        confirmPasswordController.text) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        MainScreen.id,
                        (context) => false,
                      );
                    } else {
                      dispalySnackBar(context,
                          title: 'Passwords do not match',
                          titleActionButton: 'Ok',
                          color: Colors.red);
                    }
                  }
                },
              ),
            ),
            const SizedBox(
              height: 150,
            ),
            Transform.translate(
              offset: const Offset(0, -10),
              child: const CustomBottomContainer(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
