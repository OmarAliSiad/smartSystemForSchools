import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:smartsystemforschools/core/themes/dark_theme.dart';
import 'package:smartsystemforschools/core/themes/light_theme.dart';
import 'package:smartsystemforschools/core/utils/api_keys.dart';
import 'package:smartsystemforschools/features/Allergies/presentation/views/AllergiesView.dart';
import 'package:smartsystemforschools/features/Attendance/data/manager/cubit/attendance_cubit.dart';
import 'package:smartsystemforschools/features/Attendance/presentation/views/attendance_view.dart';
import 'package:smartsystemforschools/features/child_details_view/views/child_details_view.dart';
import 'package:smartsystemforschools/features/family/data/manager/add_child_cubit/add_child_cubit.dart';
import 'package:smartsystemforschools/features/family/presentation/views/add_child_view.dart';
import 'package:smartsystemforschools/features/family/presentation/views/family_view.dart';
import 'package:smartsystemforschools/features/home/presentation/views/home_screen.dart';
import 'package:smartsystemforschools/features/login/data/models/user_info_model.dart';
import 'package:smartsystemforschools/features/login/presenation/views/forgot_password.dart';
import 'package:smartsystemforschools/features/login/presenation/views/log_in.dart';
import 'package:smartsystemforschools/features/login/presenation/views/send_code.dart';
import 'package:smartsystemforschools/features/login/presenation/views/sign_up_screen.dart';
import 'package:smartsystemforschools/features/login/presenation/views/verfiy_code.dart';
import 'package:smartsystemforschools/features/main_screen/presentation/views/main_screen.dart';
import 'package:smartsystemforschools/features/notification_view/presenation/views/notification_view.dart';
import 'package:smartsystemforschools/features/onBoarding/views/pageview.dart';
import 'package:smartsystemforschools/features/schools/presentation/views/choose_country.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/chage_data_profile/change_data_profile_cubit.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/views/edit_profile.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/views/privacy_view.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/views/terms_and_condition_view.dart';
import 'package:smartsystemforschools/generated/codegen_loader.g.dart';
import 'package:smartsystemforschools/features/settings/presentation/widgets/change_password_page.dart';
import 'core/utils/auth_service.dart';
import 'features/splash_feature/presenation/views/splash_view.dart';
import 'features/settings/presentation/views/settings_view.dart';

bool isLoggedIn = false;
void main() async {
  // ? code for device preview
  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => const MyApp(), // Wrap your app
  //   ),
  // );
  Stripe.publishableKey = ApiKeys.stripePublishableKey;
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  isLoggedIn = await AuthService().isLoggedIn();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path:
          'assets/translations', // <-- change the path of the translation files
      fallbackLocale: const Locale(
        'ar',
      ),
      assetLoader: const CodegenLoader(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeModeCubit()),
        BlocProvider(create: (context) => ChangeDataProfileCubit()),
        BlocProvider(create: (context) => AddChildCubit()),
        BlocProvider(create: (context) => AttendanceCubit()),
      ],
      child: BlocBuilder<ThemeModeCubit, ThemeModeState>(
        builder: (context, state) {
          ThemeMode themeMode = ThemeMode.light; // Default theme
          if (state is ThemeModeChanged) {
            themeMode = state.themeMode;
          }
          return MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              scrollBehavior: const ScrollBehavior().copyWith(dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.stylus,
                PointerDeviceKind.unknown,
              }),
              // locale: DevicePreview.locale(context),
              // builder: DevicePreview.appBuilder,
              debugShowCheckedModeBanner: false,
              themeMode: themeMode,
              theme: lightTheme(context),
              darkTheme: darkTheme(context),
              routes: {
                SplashView.id: (context) => const SplashView(),
                LogIn.id: (context) => const LogIn(),
                SignUpScreen.id: (context) => const SignUpScreen(),
                SendCode.id: (context) => const SendCode(),
                ForgotPassword.id: (context) => const ForgotPassword(),
                VerifyCode.id: (context) => const VerifyCode(),
                PagesScreen.id: (context) => const PagesScreen(),
                SettingsHomeView.id: (context) => const SettingsHomeView(),
                MainScreen.id: (context) => const MainScreen(),
                HomeView.id: (context) => const HomeView(),
                PrivacyView.id: (context) => const PrivacyView(),
                EditProfile.id: (context) => const EditProfile(),
                TermsAndConditionView.id: (context) =>
                    const TermsAndConditionView(),
                FamilyView.id: (context) => const FamilyView(),
                AddChildView.id: (context) => const AddChildView(),
                AllergiesView.id: (context) => const AllergiesView(),
                ChildDetailsView.id: (context) => const ChildDetailsView(),
                AttendanceView.id: (context) => const AttendanceView(),
                NotificationView.id: (context) => const NotificationView(),
                ChangePasswordPage.id: (context) => const ChangePasswordPage(),
              },
              initialRoute: isLoggedIn ? MainScreen.id : SplashView.id);
        },
      ),
    );
  }
}
