import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:smartsystemforschools/core/connectivity_cubit/connectivity_cubit.dart';
import 'package:smartsystemforschools/core/connectivity_cubit/connectivity_state.dart';
import 'package:smartsystemforschools/core/methods/show_scaffold_messanger.dart';
import 'package:smartsystemforschools/core/models/get_child_details/result.dart';
import 'package:smartsystemforschools/core/themes/dark_theme.dart';
import 'package:smartsystemforschools/core/themes/light_theme.dart';
import 'package:smartsystemforschools/core/utils/allegris_service.dart';
import 'package:smartsystemforschools/core/utils/api_keys.dart';
import 'package:smartsystemforschools/core/utils/disconnect_page_view.dart';
import 'package:smartsystemforschools/core/utils/notification_service/messaging_config.dart';
import 'package:smartsystemforschools/features/Allergies/data/manager/cubit/get_all_catogries_cubit.dart';
import 'package:smartsystemforschools/features/Allergies/presentation/views/AllergiesView.dart';
import 'package:smartsystemforschools/features/Attendance/data/manager/cubit/attendance_cubit.dart';
import 'package:smartsystemforschools/features/Attendance/presentation/views/attendance_view.dart';
import 'package:smartsystemforschools/features/child_details_view/manager/spending_limit_cubit.dart/spending_limit_cubit.dart';
import 'package:smartsystemforschools/features/child_details_view/views/child_details_view.dart';
import 'package:smartsystemforschools/features/family/data/manager/add_child_cubit/add_child_cubit.dart';
import 'package:smartsystemforschools/features/family/presentation/views/add_child_view.dart';
import 'package:smartsystemforschools/features/family/presentation/views/family_view.dart';
import 'package:smartsystemforschools/features/food_ai_view/data/cubit/cubit/meal_recommendation_cubit.dart';
import 'package:smartsystemforschools/features/home/presentation/views/home_screen.dart';
import 'package:smartsystemforschools/features/login/presenation/views/forgot_password.dart';
import 'package:smartsystemforschools/features/login/presenation/views/log_in.dart';
import 'package:smartsystemforschools/features/login/presenation/views/send_code.dart';
import 'package:smartsystemforschools/features/login/presenation/views/sign_up_screen.dart';
import 'package:smartsystemforschools/features/login/presenation/views/verfiy_code.dart';
import 'package:smartsystemforschools/features/main_screen/presentation/views/main_screen.dart';
import 'package:smartsystemforschools/features/notification_view/data/cubit/notification_cubit.dart';
import 'package:smartsystemforschools/features/notification_view/presenation/views/notification_view.dart';
import 'package:smartsystemforschools/features/onBoarding/views/pageview.dart';
import 'package:smartsystemforschools/features/payment/presentation/manager/cubit/payment_cubit.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/chage_data_profile/change_data_profile_cubit.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/views/edit_profile.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/views/privacy_view.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/views/terms_and_condition_view.dart';
import 'package:smartsystemforschools/firebase_options.dart';
import 'package:smartsystemforschools/generated/codegen_loader.g.dart';
import 'package:smartsystemforschools/features/settings/presentation/widgets/change_password_page.dart';
import 'core/utils/auth_service.dart';
import 'features/Allergies/data/manager/assing_allegris/allegris.dart';
import 'features/splash_feature/presenation/views/splash_view.dart';
import 'features/settings/presentation/views/settings_view.dart';

bool isLoggedIn = false;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MessagingConfig.initFirebaseMessaging();
  FirebaseMessaging.onBackgroundMessage(MessagingConfig.messageHandler);
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
        BlocProvider(create: (context) => GetAllCatogriesCubit()),
        BlocProvider(create: (context) => AllergiesCubit(AllergiesService())),
        BlocProvider(create: (context) => PaymentCubit()),
        BlocProvider(create: (context) => SpendingLimitCubit()),
        BlocProvider(
          create: (context) => InternetCubit(connectivity: Connectivity()),
        ),
        BlocProvider(
          create: (context) => NotificationCubit(),
        ),
        BlocProvider(create: (context) => MealRecommendationCubit()),
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
              navigatorKey: navigatorKey,
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
              builder: (context, child) {
                return BlocConsumer<InternetCubit, InternetState>(
                  listener: (context, state) {
                    if (state is InternetDisconnected) {
                      dispalySnackBar(
                        context,
                        durationD: const Duration(days: 1),
                        color: Colors.red[700]!,
                        title: '',
                        child: const Row(
                          children: [
                            Icon(
                              Icons.wifi_off_rounded,
                              color: Colors.white,
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'No Internet Connection',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Please check your network settings',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state is InternetConnected) {
                      dispalySnackBar(
                        context,
                        durationD: const Duration(seconds: 5),
                        title: 'Internet connection restored',
                        titleActionButton: 'ok',
                        color: Colors.green[700]!,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is InternetDisconnected) {
                      return const DisconnectedPageView();
                    } else {
                      return child!;
                    }
                  },
                );
              },
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
                AllergiesView.id: (context) => const AllergiesView(
                      studentId: '',
                    ),
                ChildDetailsView.id: (context) => ChildDetailsView(
                      resultForChildDetails: ResultForChildDetails(),
                    ),
                AttendanceView.id: (context) => const AttendanceView(),
                NotificationView.id: (context) => const NotificationView(
                      childDetails: [],
                    ),
                ChangePasswordPage.id: (context) => const ChangePasswordPage(),
              },
              initialRoute: isLoggedIn ? MainScreen.id : SplashView.id);
        },
      ),
    );
  }
}

class Get {
  static BuildContext? get context => navigatorKey.currentContext;
  static NavigatorState? get navigator => navigatorKey.currentState;
}
