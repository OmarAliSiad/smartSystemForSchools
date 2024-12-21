import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smartsystemforschools/core/themes/light_theme.dart';
import 'package:smartsystemforschools/core/widgets/alertDialog.dart';
import 'package:smartsystemforschools/features/home/presentation/views/home_screen.dart';
import 'package:smartsystemforschools/features/login/presenation/views/forgot_password.dart';
import 'package:smartsystemforschools/features/login/presenation/views/log_in.dart';
import 'package:smartsystemforschools/features/login/presenation/views/verfiy_code.dart';
import 'package:smartsystemforschools/features/main_screen/presentation/views/main_screen.dart';
import 'package:smartsystemforschools/features/presenation/views/pageview.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/views/edit_profile.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/views/privacy_view.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/views/settings.view.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/views/terms_and_condition_view.dart';
import 'package:smartsystemforschools/features/splash_feature/presenation/views/splash_view.dart';
import 'package:smartsystemforschools/generated/l10n.dart';
import 'core/themes/dark_theme.dart';
import 'features/Allergies/presentation/views/AllergiesView.dart';
import 'features/family/presentation/views/add_child_view.dart';
import 'features/family/presentation/views/family_view.dart';
import 'features/login/presenation/views/send_code.dart';
import 'features/settings_view/presentation/manager/chage_data_profile/change_data_profile_cubit.dart';
import 'features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeModeCubit()),
        BlocProvider(create: (context) => ChangeDataProfileCubit()),
      ],
      child: BlocBuilder<ThemeModeCubit, ThemeModeState>(
        builder: (context, state) {
          return MaterialApp(
            locale: const Locale('en'),
            debugShowCheckedModeBanner: false,
            themeMode: context.read<ThemeModeCubit>().currentTheme,
            theme: lightTheme(),
            darkTheme: darkTheme(),
            routes: {
              SplashView.id: (context) => const SplashView(),
              LogIn.id: (context) => const LogIn(),
              SendCode.id: (context) => const SendCode(),
              ForgotPassword.id: (context) => const ForgotPassword(),
              VerifyCode.id: (context) => const VerifyCode(),
              PagesScreen.id: (context) => const PagesScreen(),
              SettingsView.id: (context) => const SettingsView(),
              MainScreen.id: (context) => const MainScreen(),
              HomeView.id: (context) => const HomeView(),
              PrivacyView.id: (context) => const PrivacyView(),
              EditProfile.id: (context) => const EditProfile(),
              TermsAndConditionView.id: (context) =>
                  const TermsAndConditionView(),
              FamilyView.id: (context) => const FamilyView(),
              AddChildView.id: (context) => const AddChildView(),
              AllergiesView.id: (context) => const AllergiesView(),
            },
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            initialRoute: MainScreen.id,
          );
        },
      ),
    );
  }
}
