import 'package:flutter/material.dart';
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
                padding: const EdgeInsets.only(left: 30, right: 28),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Login to your Account',
                        style: AppStyles.styleSemiBold20(),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      OpcaityText(
                        text: 'User Name',
                        textStyle: AppStyles.styleRegular14(),
                        opacity: .7,
                      ),
                      const SizedBox(
                        height: 9,
                      ),
                      CustomTextField(
                        borderRaduis: 10,
                        shadows: [
                          BoxShadow(
                            color: const Color(0x00000000).withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                            spreadRadius: 0,
                          )
                        ],
                        controller: emailController,
                        obsure: false,
                        hintText: 'Enter your userName',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10),
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
                        text: 'Password',
                        textStyle: AppStyles.styleRegular14(),
                        opacity: .7,
                      ),
                      const SizedBox(
                        height: 9,
                      ),
                      CustomTextField(
                        borderRaduis: 10,
                        shadows: [
                          BoxShadow(
                            color: const Color(0x00000000).withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                            spreadRadius: 0,
                          )
                        ],
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
                        hintText: 'Enter your password',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(
                            top: 13,
                            bottom: 18,
                            left: 0,
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
                              'Forgot Password?',
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
                text: 'Login',
                email: emailController,
                password: passwordController,
              ),
              const SizedBox(
                height: 22,
              ),
              const CustomBottomContainer(color: Colors.black),
            ],
          ),
        ],
      ),
    );
  }
}
