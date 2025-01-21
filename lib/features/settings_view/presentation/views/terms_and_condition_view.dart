import 'package:flutter/material.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/views/privacy_view.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/custom_app_bar.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/widgets/custom_bottom_container.dart';
import '../../../main_screen/presentation/views/main_screen.dart';
import '../widgets/custom_button_privacy.dart';

class TermsAndConditionView extends StatelessWidget {
  static const String id = 'TermsAndConditionView';
  const TermsAndConditionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Privacy',
        textStyle: AppStyles.styleSemiBold20(),
        ThereIsicon: false,
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(
              height: 136,
            ),
            Text(
              'I have read and agree to Terms & Conditions',
              style: AppStyles.styleMedium16().copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Center(
              child: Text(
                'and Privacy Policy.',
                style: AppStyles.styleMedium16().copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                Navigator.pushReplacementNamed(context, PrivacyView.id);
                Navigator.of(context).pop();
              },
              child: Text(
                'Privacy Policy',
                style: AppStyles.styleMedium18().copyWith(
                  color: const Color(0xff1A0F91),
                ),
              ),
            ),
            const SizedBox(
              height: 95,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 100),
              child: CustomButton(
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 39, vertical: 14.5),
                text: 'I’ve accepted',
                textStyle: AppStyles.styleSemiBold14(),
                borderRadius: 20,
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    MainScreen.id,
                    (context) => false,
                  );
                },
              ),
            ),
            const SizedBox(
              height: 19,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 100),
              child: CustomButtonPrivacy(
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 39, vertical: 14.5),
                text: 'Cancel',
                textStyle: AppStyles.styleSemiBold14(),
                borderRadius: 20,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, PrivacyView.id);
                  Navigator.of(context).pop();
                },
              ),
            ),
            const Expanded(child: SizedBox()),
            const CustomBottomContainer(
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
