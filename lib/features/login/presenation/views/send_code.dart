import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smartsystemforschools/features/login/presenation/views/verfiy_code.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';
import '../../../../core/methods/vaildate_email.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/widgets/custom_bottom_container.dart';
import '../widgets/custom_logo.dart';
import '../widgets/user_info.dart';

class SendCode extends StatefulWidget {
  static String id = 'SendCode';
  const SendCode({super.key});

  @override
  State<SendCode> createState() => _SendCodeState();
}

class _SendCodeState extends State<SendCode> {
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formState,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(
              height: 76,
            ),
            const CustomLogo(),
            const SizedBox(
              height: 92,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.SendCode_forgotPassword.tr(),
                    style: AppStyles.styleSemiBold20(),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    ''' ${LocaleKeys.SendCode_subtitle.tr()}''',
                    style: AppStyles.styleMedium12().copyWith(
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
              padding: const EdgeInsetsDirectional.only(start: 30, end: 28),
              child: UserInfo(
                title: LocaleKeys.SendCode_email.tr(),
                hintText: LocaleKeys.SendCode_emailHint.tr(),
                obsure: false,
                controller: emailController,
                validator: (value) {
                  return vaildateEmail(
                    value,
                    emailController,
                    LocaleKeys.Auth_userEmailHintText.tr(),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 34,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 14),
              child: CustomButton(
                padding: const EdgeInsetsDirectional.symmetric(vertical: 14.5),
                text: LocaleKeys.SendCode_button.tr(),
                textStyle: AppStyles.styleBold14(),
                borderRadius: 20,
                onPressed: () {
                  if (formState.currentState!.validate()) {
                    Navigator.of(context).pushNamed(VerifyCode.id);
                  }
                },
              ),
            ),
            const SizedBox(
              height: 252,
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
