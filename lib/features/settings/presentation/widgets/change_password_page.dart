import 'dart:developer';
import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsystemforschools/core/utils/Constants.dart';
import 'package:smartsystemforschools/core/utils/auth_service.dart';
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
  bool _obscureText = true;
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
                  obsure: _obscureText,
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      icon: const Icon(
                        Icons.visibility,
                        color: Colors.grey,
                      )),
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
                  onPressed: () async {
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    String email =
                        sharedPreferences.getString(Constants.email).toString();
                    log(email);
                    if (_formKey.currentState!.validate()) {
                      await AuthService()
                          .forgotPassword(context: context, email: email);
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
