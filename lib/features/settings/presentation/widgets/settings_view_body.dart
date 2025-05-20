import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsystemforschools/features/settings/data/manager/getUserDataCubit/get_user_data_cubit.dart';
import '../../../../core/methods/show_scaffold_messanger.dart';
import '../../../../core/models/get_all_schools/result.dart';
import '../../../../core/services/auth_service/auth_service.dart';
import '../../../../core/services/fcm_token_service/fcm_token_service.dart';
import '../../../../core/services/notification_service/notification_service.dart';
import '../../../../core/services/school_service/school_service.dart';
import '../../../login/presenation/views/log_in.dart';
import '../../../schools/presentation/views/schools_screen.dart';
import '../../../settings_view/presentation/views/edit_profile.dart';
import '../../../../core/methods/policy_dialog.dart';
import '../../../../core/models/get_school_details_by_id/get_school_details_by_id.dart';
import '../../../login/data/models/user_info_model.dart';
import '../../../schools/presentation/views/school_view_details.dart';
import '../../../settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import 'change_password_page.dart';
import 'custom_settings_widget.dart';
import 'info_user_widget.dart';
import '../../../../../../generated/locale_keys.g.dart';
import '../../../../../../core/utils/app_styles.dart';
import '../../../settings_view/presentation/views/language_selection_page.dart';

class SettingsViewBody extends StatefulWidget {
  const SettingsViewBody({super.key});

  @override
  State<SettingsViewBody> createState() => _SettingsViewBodyState();
}

class _SettingsViewBodyState extends State<SettingsViewBody> {
  // Keys for SharedPreferences
  static const String _confirmationKey = 'confirmation_enabled';
  static const String _themeKey = 'dark_theme_enabled';
  static const String _languageKey = 'arabic_language_enabled';
  bool _switchValue = false;
  bool isActiveTheme = false;
  bool isActiveLanguage = false;
  UserInfoModel? userInfo;
  SchoolDetails? school;

  @override
  void initState() {
    super.initState();
    getUserInfoAndSchoolDetails();
    _loadSavedSettings();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Sync our isActiveTheme state variable with the actual ThemeModeCubit state
    // This ensures the switch reflects the current theme when navigating back to this screen
    isActiveTheme =
        context.read<ThemeModeCubit>().currentTheme == ThemeMode.dark;
  }

  Future<void> _loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Load saved settings with fallback to default values
      _switchValue = prefs.getBool(_confirmationKey) ?? false;
      // Get theme directly from ThemeModeCubit to ensure UI consistency
      isActiveTheme =
          context.read<ThemeModeCubit>().currentTheme == ThemeMode.dark;
      // For language, check the current app locale first
      final currentLocale = context.locale.languageCode;
      isActiveLanguage = prefs.getBool(_languageKey) ?? (currentLocale == 'ar');
    });
    // Make sure the app state matches the loaded preferences
    // This ensures the app's actual state matches what we're showing in the UI
    if (isActiveTheme) {
      // Only call if the current theme doesn't match the saved preference
      if (context.read<ThemeModeCubit>().currentTheme != ThemeMode.dark) {
        context.read<ThemeModeCubit>().changeThemeMode();
      }
    }
    // Language might have been set from elsewhere in the app
    // So we only update it if it doesn't match the current locale
    if ((isActiveLanguage && context.locale.languageCode != 'ar') ||
        (!isActiveLanguage && context.locale.languageCode != 'en')) {
      context.setLocale(
          isActiveLanguage ? const Locale('ar') : const Locale('en'));
    }

    // Update notification confirmation setting
    NotificationService().enableConfirmationFromParent(enable: _switchValue);
  }

  Future<void> _saveSettings(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> getUserInfoAndSchoolDetails() async {
    // Assuming you have a method to fetch user info
    userInfo = await AuthService().getUserInfo();
    SchoolDetails info = await SchoolService().getSchoolById(
      userInfo!.schoolTenantId.toString(),
    );
    setState(() {
      school = info;
    });
    log(school?.result?.schoolTenantId.toString() ??
        'School details not available');
  }

  @override
  Widget build(BuildContext context) {
    // Listen to ThemeModeCubit changes and update our local state accordingly
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
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  log(school!.result!.schoolTenantId.toString());
                  return SchoolViewDetails(
                    showButton: false,
                    school: ResultForAllSchools(
                      schoolTenantId: userInfo!.schoolTenantId.toString(),
                      name: school!.result!.name,
                      description: school!.result!.description,
                      address: school!.result!.address,
                      country: school!.result!.country,
                      phoneNumber: school!.result!.phoneNumber,
                      email: school!.result!.email,
                      createdOn: school!.result!.createdOn,
                      schoolLogo: school!.result!.schoolLogo,
                    ),
                  );
                },
              ),
            );
          },
          settingsName: 'school details',
          style: AppStyles.styleRegular18(),
          suffixWidget: const Icon(
            Icons.arrow_forward_ios,
            size: 20,
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        CustomSettingsWidget(
          onTap: () async {
            // Navigate to EditProfile and refresh data when returning
            final result =
                await Navigator.of(context).pushNamed(EditProfile.id);
            // If we got a result back or just returned from EditProfile, reload data
            if (result == true || result == null) {
              // Reload the GetUserDataCubit data to refresh the user info
              context.read<GetUserDataCubit>().getData();
              // Also reload our local data
              getUserInfoAndSchoolDetails();
              // This forces a rebuild of the current widget
              setState(() {});
            }
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
          onTap: () {
            Navigator.of(context).pushNamed(LanguageSelectionPage.id);
          },
          settingsName: LocaleKeys.Settings_language.tr(),
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
            context.read<ThemeModeCubit>().changeThemeMode();
            setState(() {
              isActiveTheme = !isActiveTheme;
            });
            _saveSettings(_themeKey, !isActiveTheme);
          },
          settingsName: LocaleKeys.Settings_darkMode.tr(),
          style: AppStyles.styleRegular18(),
          suffixWidget: Transform.scale(
            scale: .9,
            child: Switch(
              inactiveTrackColor: Colors.white,
              activeColor: const Color(0xff1A0F91),
              activeTrackColor: const Color(0xff1A0F91).withOpacity(.3),
              value: isActiveTheme,
              onChanged: (val) {
                context.read<ThemeModeCubit>().changeThemeMode();
                setState(() {
                  isActiveTheme = val;
                });
                _saveSettings(_themeKey, !isActiveTheme);
              },
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        CustomSettingsWidget(
          settingsName: 'confirmation',
          style: AppStyles.styleRegular18(),
          suffixWidget: Transform.scale(
            scale: .9,
            child: Switch(
                inactiveTrackColor: Colors.white,
                activeColor: const Color(0xff1A0F91),
                value: _switchValue,
                onChanged: (value) {
                  setState(() {
                    _switchValue = value;
                  });

                  if (_switchValue) {
                    dispalySnackBar(context,
                        title: 'Confirmation from parent', color: Colors.green);
                  } else {
                    dispalySnackBar(context,
                        title: 'No Confirmation from parent',
                        color: Colors.red);
                  }

                  // Update notification service
                  NotificationService().enableConfirmationFromParent(
                    enable: _switchValue,
                  );

                  // Save setting
                  _saveSettings(_confirmationKey, _switchValue);
                }),
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
            AuthService().logout();
            FCMTokenService().deleteTokenOnLogout();
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
