import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:smartsystemforschools/features/login/presenation/views/forgot_password.dart';
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
  String code = '';
  bool _onEditing = false;
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
                      'Please Check your email',
                      style: AppStyles.styleSemiBold20(),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Enter The verification code that has been \nentered into your email',
                      style: AppStyles.styleMedium12().copyWith(
                        color: Colors.black.withOpacity(.80),
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: VerificationCode(
                  fullBorder: true,
                  textStyle: AppStyles.styleMedium18(),
                  keyboardType: TextInputType.number,
                  underlineColor: Colors.blue,
                  length: 4,
                  margin: const EdgeInsets.only(right: 15),
                  itemSize: 65,
                  cursorColor: Colors.blue,
                  onCompleted: (String value) {
                    setState(() {
                      code = value;
                    });
                  },
                  onEditing: (bool value) {
                    setState(() {
                      _onEditing = value;
                    });
                    if (!_onEditing) FocusScope.of(context).unfocus();
                  },
                ),
              ),
              const SizedBox(
                height: 29,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: CustomButton(
                  padding: const EdgeInsets.symmetric(vertical: 14.5),
                  text: 'Verify',
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
                    'Send code again',
                    style: AppStyles.styleMedium12().copyWith(
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '00:20',
                    style: AppStyles.styleMedium12().copyWith(
                      fontSize: 13,
                      color: Colors.black.withOpacity(.63),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 206),
              Transform.translate(
                  offset: const Offset(0, 30),
                  child: const CustomBottomContainer(color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }
}
