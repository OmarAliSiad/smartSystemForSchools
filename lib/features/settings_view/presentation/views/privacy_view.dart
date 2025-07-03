import 'package:flutter/material.dart';
import 'terms_and_condition_view.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/custom_app_bar.dart';
import '../../../../core/widgets/custom_bottom_container.dart';
import '../widgets/custom_button_privacy.dart';
import 'package:easy_localization/easy_localization.dart';

class PrivacyView extends StatelessWidget {
  static const String id = '/PrivacyView';
  const PrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: ValueKey(context.locale.toString()),
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Privacy',
          textStyle: AppStyles.styleSemiBold20(),
          ThereIsicon: false,
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        body: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 27,
            end: 23,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 31,
              ),
              Text(
                'Privacy Policy',
                style: AppStyles.styleMedium18()
                    .copyWith(color: const Color(0xff1A0F91)),
              ),
              const SizedBox(
                height: 26,
              ),
              Text(
                '''
Your privacy is important to us. It is \nBrainstorming's policy to respect your privacy \nregarding any information we may collect \nfrom you across our website, and other sites \nwe own and operate.
        
We only ask for personal information when we \ntruly need it to provide a service to you. We \ncollect it by fair and lawful means, with your \nknowledge and consent. We also let you know \nwhy we’re collecting it and how it will be used.
        
We only retain collected information for as \nlong as necessary to provide you with your \nrequested service. What data we store, we’ll \nprotect within commercially acceptable \nmeans to prevent loss and theft, as well as \nunauthorized access, disclosure, copying, use \nor modification.
        
We don’t share any personally identifying \ninformation publicly or with third-parties,\n except when required to by law.
        ''',
                style: AppStyles.styleRegular14().copyWith(fontSize: 13),
              ),
              const Spacer(),
              CustomButtonPrivacy(
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 98, vertical: 14.5),
                text: 'I’ve agree with this',
                textStyle: AppStyles.styleSemiBold14()
                    .copyWith(color: const Color(0xff1A0F91)),
                borderRadius: 20,
                onPressed: () {
                  Navigator.of(context).pushNamed(TermsAndConditionView.id);
                },
              ),
              const SizedBox(
                height: 12,
              ),
              const CustomBottomContainer(
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
