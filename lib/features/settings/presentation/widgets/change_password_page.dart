import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smartsystemforschools/features/login/presenation/widgets/custom_text_field.dart';
import '../../../../../../core/utils/app_styles.dart';
import '../../../../../../core/utils/custom_button.dart';
import 'custom_app_bar_settings.dart';
import '../../../../../../generated/locale_keys.g.dart';

class ChangePasswordPage extends StatefulWidget {
  static const String id = 'changePasswordPage';
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarSettings(
        title: LocaleKeys.Settings_changePassword.tr(),
        style: AppStyles.styleBold20(),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              SlideInRight(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 5),
                  child: Text(
                    LocaleKeys.Settings_changePassword.tr(),
                    style: AppStyles.styleBold20(),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SlideInRight(
                child: CustomTextField(
                  borderRaduis: 10,
                  obsure: true,
                  controller: passwordController,
                  validator: (password) {
                    if (password == null || password.isEmpty) {
                      return LocaleKeys.Auth_confirmPasswordHintText.tr();
                    }
                    return null;
                  },
                  hintText: LocaleKeys.ForgotPassword_confirmPassword.tr(),
                  keyboardType: TextInputType.name,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              BounceInDown(
                child: CustomButton(
                  borderRadius: 30,
                  padding: const EdgeInsetsDirectional.symmetric(
                      vertical: 10, horizontal: 70),
                  text: LocaleKeys.Settings_changePassword.tr(),
                  textStyle: AppStyles.styleMedium20(),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // AuthService().changePassword(
                      //   context: context,
                      //   password: passwordController.text,
                      // );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
