import 'package:flutter/material.dart';
import 'package:smartsystemforschools/features/login/presenation/views/verfiy_code.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/widgets/custom_bottom_container.dart';
import '../widgets/custom_logo.dart';
import '../widgets/user_info.dart';

class SendCode extends StatelessWidget {
  static String id = 'SendCode';
  const SendCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Column(
            children: [
              const SizedBox(
                height: 76,
              ),
              const CustomLogo(),
              const SizedBox(
                height: 92,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Forgot password',
                      style: AppStyles.styleSemiBold20(),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '''Don’t worry it happens . PLease enter the\nemail associated with your account''',
                      style: AppStyles.styleMedium12().copyWith(
                        color: Colors.black.withOpacity(.80),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 23,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 28),
                child: UserInfo(
                  title: 'Email',
                  hintText: 'Email',
                  obsure: false,
                  controller: TextEditingController(),
                ),
              ),
              const SizedBox(
                height: 34,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: CustomButton(
                  padding: const EdgeInsets.symmetric(vertical: 14.5),
                  text: 'Send Code',
                  textStyle: AppStyles.styleBold14(),
                  borderRadius: 20,
                  onPressed: () {
                    Navigator.of(context).pushNamed(VerifyCode.id);
                  },
                ),
              ),
              const SizedBox(
                height: 252,
              ),
              Transform.translate(
                offset: const Offset(0, -10),
                child: const CustomBottomContainer(color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
