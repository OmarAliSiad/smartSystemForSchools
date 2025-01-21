import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/features/login/presenation/views/log_in.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/views/edit_profile.dart';
import '../../../../core/methods/policy_dialog.dart';
import '../../../settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import 'change_password_page.dart';
import 'custom_settings_widget.dart';
import 'info_user_widget.dart';
import '../../../../../../generated/locale_keys.g.dart';
import '../../../../../../core/utils/app_styles.dart';

class SettingsViewBody extends StatefulWidget {
  const SettingsViewBody({super.key});

  @override
  State<SettingsViewBody> createState() => _SettingsViewBodyState();
}

class _SettingsViewBodyState extends State<SettingsViewBody> {
  bool isActiveTheme = false;
  bool isActiveLanguage = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const InfoUserRowWidget(),
        const SizedBox(
          height: 20,
        ),
        const Divider(
          thickness: .5,
          height: 24,
          color: Color(0xffCACACA),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          LocaleKeys.Settings_accountSettings.tr(),
          style: AppStyles.styleRegular18().copyWith(
            color: const Color(0xFFADADAD),
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        CustomSettingsWidget(
          onTap: () {
            Navigator.of(context).pushNamed(EditProfile.id);
          },
          settingsName: LocaleKeys.Settings_editProfile.tr(),
          style: AppStyles.styleRegular18(),
          suffixWidget: const Icon(
            Icons.arrow_forward_ios,
            size: 20,
          ),
        ),
        const SizedBox(
          height: 34,
        ),
        CustomSettingsWidget(
          onTap: () {
            Navigator.of(context).pushNamed(ChangePasswordPage.id);
          },
          settingsName: LocaleKeys.Settings_changePassword.tr(),
          style: AppStyles.styleRegular18(),
          suffixWidget: const Icon(
            Icons.arrow_forward_ios,
            size: 20,
          ),
        ),
        const SizedBox(
          height: 34,
        ),
        CustomSettingsWidget(
          settingsName: LocaleKeys.Settings_darkMode.tr(),
          style: AppStyles.styleRegular18(),
          suffixWidget: Switch(
            inactiveTrackColor: Colors.white,
            activeColor: const Color(0xff1A0F91),
            value: isActiveTheme,
            onChanged: (value) {
              setState(() {});
              isActiveTheme = value;
              isActiveTheme == true
                  ? context.read<ThemeModeCubit>().changeThemeMode()
                  : context.read<ThemeModeCubit>().changeThemeMode();
              setState(() {});
            },
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        CustomSettingsWidget(
          settingsName: LocaleKeys.Settings_language.tr(),
          style: AppStyles.styleRegular18(),
          suffixWidget: Switch(
            inactiveTrackColor: Colors.white,
            activeColor: const Color(0xff1A0F91),
            value: isActiveLanguage,
            onChanged: (value) {
              setState(() {});
              isActiveLanguage = value;
              isActiveLanguage == true
                  ? context.setLocale(const Locale('ar'))
                  : context.setLocale(const Locale('en'));
              setState(() {});
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          thickness: .5,
          height: 32,
          color: Color(0xffCACACA),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          LocaleKeys.Settings_more.tr(),
          style: AppStyles.styleRegular18()
              .copyWith(color: const Color(0xFFADADAD)),
        ),
        const SizedBox(
          height: 34,
        ),
        CustomSettingsWidget(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return PolicyDialog(
                  raduis: 8,
                  mdFileName: isActiveLanguage
                      ? 'terms_and_conditions_ar.md'
                      : 'terms_and_conditions_en.md',
                );
              },
            );
          },
          settingsName: LocaleKeys.Settings_termsAndConditions.tr(),
          style: AppStyles.styleRegular18(),
          suffixWidget: const Icon(
            Icons.arrow_forward_ios,
            size: 20,
          ),
        ),
        const SizedBox(
          height: 34,
        ),
        CustomSettingsWidget(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return PolicyDialog(
                  raduis: 8,
                  mdFileName:
                      isActiveLanguage ? 'privacy_ar.md' : 'privacy_en.md',
                );
              },
            );
          },
          settingsName: LocaleKeys.Settings_privacyPolicy.tr(),
          style: AppStyles.styleRegular18(),
          suffixWidget: const Icon(
            Icons.arrow_forward_ios,
            size: 20,
          ),
        ),
        const SizedBox(
          height: 34,
        ),
        CustomSettingsWidget(
          onTap: () {
            // GoogleSignIn googleSignIn = GoogleSignIn();
            // googleSignIn.disconnect();
            // FirebaseAuth.instance.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil(
              LogIn.id,
              (route) => false,
            );
          },
          settingsName: LocaleKeys.Settings_logout.tr(),
          style: AppStyles.styleRegular18(),
          suffixWidget: Transform.flip(
            flipX: context.locale == const Locale('en') ? false : true,
            child: const Icon(
              Icons.logout_outlined,
              size: 20,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
