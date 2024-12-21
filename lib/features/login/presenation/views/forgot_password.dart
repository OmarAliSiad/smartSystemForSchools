import 'package:flutter/material.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/widgets/custom_bottom_container.dart';
import '../../../main_screen/presentation/views/main_screen.dart';
import '../widgets/custom_logo.dart';
import '../widgets/user_info.dart';

class ForgotPassword extends StatelessWidget {
  static String id = 'ForgotPassword';
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
                padding: const EdgeInsets.only(left: 30, right: 44),
                child: Text(
                  'Please  enter a new password',
                  style: AppStyles.styleSemiBold20(),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 29, right: 35),
                child: Text(
                  'This password should be different from the previous password',
                  style: AppStyles.styleMedium12().copyWith(
                    fontSize: 13,
                    color: Colors.black.withOpacity(.63),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 22,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 29,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserInfo(
                  title: 'New password',
                  hintText: 'New password',
                  obsure: true,
                  controller: TextEditingController(),
                ),
                const SizedBox(
                  height: 22,
                ),
                UserInfo(
                  title: 'Confirm password',
                  hintText: 'Confirm password',
                  obsure: true,
                  controller: TextEditingController(),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 43,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
            ),
            child: CustomButton(
              padding: const EdgeInsets.symmetric(vertical: 14.5),
              text: 'Reset Password',
              textStyle: AppStyles.styleSemiBold14(),
              borderRadius: 20,
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  MainScreen.id,
                  (context) => false,
                );
              },
            ),
          ),
          const SizedBox(
            height: 140,
          ),
          Transform.translate(
            offset: const Offset(0, -10),
            child: const CustomBottomContainer(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
