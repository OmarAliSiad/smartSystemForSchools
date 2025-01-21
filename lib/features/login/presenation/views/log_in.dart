import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';
import '../../../../core/methods/vaildate_email.dart';
import '../../../../core/methods/vaildate_password.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/widgets/custom_bottom_container.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_logo.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/opcaity_text.dart';
import 'send_code.dart';

class LogIn extends StatefulWidget {
  static String id = 'LogIn';
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isSecure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 76,
              ),
              const CustomLogo(),
              const SizedBox(
                height: 92,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 30, end: 28),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.Login_title.tr(),
                        style: AppStyles.styleSemiBold20(),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      OpcaityText(
                        text: LocaleKeys.Login_labelUserName.tr(),
                        textStyle: AppStyles.styleRegular14(),
                        opacity: .7,
                      ),
                      const SizedBox(
                        height: 9,
                      ),
                      CustomTextField(
                        validator: (value) {
                          return vaildateEmail(value, emailController);
                        },
                        borderRaduis: 10,
                        controller: emailController,
                        obsure: false,
                        hintText: LocaleKeys.Login_userEmailHintText.tr(),
                        prefixIcon: Padding(
                          padding: const EdgeInsetsDirectional.all(10),
                          child: Image.asset(
                            width: 20,
                            height: 20,
                            Assets.imagesPerson,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      OpcaityText(
                        text: LocaleKeys.Login_labelPassword.tr(),
                        textStyle: AppStyles.styleRegular14(),
                        opacity: .7,
                      ),
                      const SizedBox(
                        height: 9,
                      ),
                      CustomTextField(
                        validator: (value) {
                          return vaildatePassword(value, passwordController);
                        },
                        borderRaduis: 10,
                        controller: passwordController,
                        obsure: isSecure,
                        suffixIcon: IconButton(
                          onPressed: () {
                            isSecure = !isSecure;
                            setState(() {});
                          },
                          icon: isSecure
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),
                        hintText: LocaleKeys.Login_passwordHintText.tr(),
                        prefixIcon: Padding(
                          padding: const EdgeInsetsDirectional.only(
                            top: 13,
                            bottom: 18,
                            start: 0,
                          ),
                          child: Image.asset(
                            width: 16,
                            height: 21,
                            Assets.imagesPassword,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(SendCode.id);
                            },
                            child: Text(
                              LocaleKeys.Login_forgotPassword.tr(),
                              style: AppStyles.styleRegular14().copyWith(
                                fontSize: 16,
                                color: const Color(0xff1A0F91),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const Flexible(
                child: SizedBox(
                  height: 150,
                ),
              ),
              CustomButtonLogIn(
                formState: formKey,
                text: LocaleKeys.Login_button.tr(),
                email: emailController,
                password: passwordController,
              ),
              const SizedBox(
                height: 22,
              ),
              const CustomBottomContainer(
                color: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
