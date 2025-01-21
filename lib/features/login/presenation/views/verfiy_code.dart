import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smartsystemforschools/features/login/presenation/views/forgot_password.dart';
import 'package:smartsystemforschools/features/login/presenation/views/otp_code.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/widgets/custom_bottom_container.dart';
import '../widgets/custom_logo.dart';

class VerifyCode extends StatefulWidget {
  static String id = 'VerfiyCode';
  const VerifyCode({super.key});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  TextEditingController otpController = TextEditingController();
  String code = '';
  final bool _onEditing = false;
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
                padding: const EdgeInsetsDirectional.only(start: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      LocaleKeys.VerifyCode_checkEmail.tr(),
                      style: AppStyles.styleSemiBold20(),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      LocaleKeys.VerifyCode_description.tr(),
                      style: AppStyles.styleMedium12().copyWith(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
                child: PinCodeWidget(
                  otpController: otpController,
                ),
              ),
              const SizedBox(
                height: 29,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 14),
                child: CustomButton(
                  padding:
                      const EdgeInsetsDirectional.symmetric(vertical: 14.5),
                  text: LocaleKeys.VerifyCode_button.tr(),
                  textStyle: AppStyles.styleSemiBold14(),
                  borderRadius: 20,
                  onPressed: () {
                    Navigator.of(context).pushNamed(ForgotPassword.id);
                  },
                ),
              ),
              const SizedBox(
                height: 26,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.VerifyCode_resend.tr(),
                    style: AppStyles.styleMedium12().copyWith(
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    LocaleKeys.VerifyCode_time.tr(),
                    style: AppStyles.styleMedium12().copyWith(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 206),
              Transform.translate(
                offset: const Offset(0, 30),
                child: const CustomBottomContainer(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
