import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/models/get_all_schools/result.dart';
import '../../../schools/presentation/views/choose_country.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../core/methods/vaildate_email.dart';
import '../../../../core/methods/vaildate_password.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/widgets/custom_bottom_container.dart';
import '../widgets/custom_button_signup.dart';
import '../widgets/custom_logo.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/opcaity_text.dart';

class SignUpScreen extends StatefulWidget {
  static String id = '/SignUpScreen';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController schoolTentantIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  bool isSecure1 = true;
  bool isSecure2 = true;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: ValueKey(context.locale.toString()),
      child: Scaffold(
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
                          LocaleKeys.Auth_register.tr(),
                          style: AppStyles.styleSemiBold20(),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        OpcaityText(
                          text: LocaleKeys.Auth_labelUserName.tr(),
                          textStyle: AppStyles.styleRegular14(),
                          opacity: .7,
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        CustomTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return LocaleKeys.Auth_userNameHintText.tr();
                            }
                            return null;
                          },
                          borderRaduis: 10,
                          controller: userNameController,
                          obsure: false,
                          hintText: LocaleKeys.Auth_userNameHintText.tr(),
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
                          height: 12,
                        ),
                        OpcaityText(
                          text: LocaleKeys.Auth_email.tr(),
                          textStyle: AppStyles.styleRegular14(),
                          opacity: .7,
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        CustomTextField(
                          validator: (value) {
                            return vaildateEmail(
                              value,
                              emailController,
                              LocaleKeys.Auth_userEmailHintText.tr(),
                            );
                          },
                          borderRaduis: 10,
                          controller: emailController,
                          obsure: false,
                          hintText: LocaleKeys.Auth_userEmailHintText.tr(),
                          prefixIcon: Padding(
                            padding: const EdgeInsetsDirectional.all(10),
                            child: Icon(
                              size: 20,
                              Icons.email_outlined,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        OpcaityText(
                          text: LocaleKeys.Auth_school.tr(),
                          textStyle: AppStyles.styleRegular14(),
                          opacity: .7,
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                isReadOnly: true,
                                hintText: LocaleKeys.Auth_school.tr(),
                                borderRaduis: 10,
                                prefixIcon: Padding(
                                  padding: const EdgeInsetsDirectional.all(10),
                                  child: Icon(
                                    size: 20,
                                    Icons.email_outlined,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                controller: schoolTentantIdController,
                                obsure: false,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade900,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.school,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  final selectedSchool =
                                      await Navigator.push<ResultForAllSchools>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const PickCountry(),
                                    ),
                                  );

                                  if (selectedSchool != null) {
                                    setState(() {
                                      schoolTentantIdController.text =
                                          selectedSchool.name ?? '';
                                    });
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        OpcaityText(
                          text: LocaleKeys.Auth_labelPassword.tr(),
                          textStyle: AppStyles.styleRegular14(),
                          opacity: .7,
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        CustomTextField(
                          validator: (value) {
                            return vaildatePassword(
                              value,
                              passwordController,
                              LocaleKeys.Auth_passwordHintText.tr(),
                            );
                          },
                          borderRaduis: 10,
                          controller: passwordController,
                          obsure: isSecure1,
                          suffixIcon: IconButton(
                            onPressed: () {
                              isSecure1 = !isSecure1;
                              setState(() {});
                            },
                            icon: isSecure1
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                          ),
                          hintText: LocaleKeys.Auth_passwordHintText.tr(),
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
                          height: 12,
                        ),
                        OpcaityText(
                          text: LocaleKeys.Auth_confirmPassword.tr(),
                          textStyle: AppStyles.styleRegular14(),
                          opacity: .7,
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        CustomTextField(
                          validator: (value) {
                            return vaildatePassword(
                                value,
                                confirmpasswordController,
                                LocaleKeys.Auth_confirmPasswordHintText.tr());
                          },
                          borderRaduis: 10,
                          controller: confirmpasswordController,
                          obsure: false,
                          suffixIcon: IconButton(
                            onPressed: () {
                              isSecure2 = !isSecure2;
                              setState(() {});
                            },
                            icon: isSecure2
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                          ),
                          hintText:
                              LocaleKeys.Auth_confirmPasswordHintText.tr(),
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
                      ],
                    ),
                  ),
                ),
                const Flexible(
                  child: SizedBox(
                    height: 150,
                  ),
                ),
                CustomButtonSignup(
                  formState: formKey,
                  text: LocaleKeys.Auth_singup.tr(),
                  userName: userNameController,
                  email: emailController,
                  password: passwordController,
                  schoolTenantId: schoolTentantIdController,
                  confirmPassword: confirmpasswordController,
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys.account_haveAccount.tr(),
                      style: AppStyles.styleRegular16(),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        LocaleKeys.account_login.tr(),
                        style: AppStyles.styleRegular20().copyWith(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
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
      ),
    );
  }
}
