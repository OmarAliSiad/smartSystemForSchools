import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import 'package:smartsystemforschools/core/utils/modern_error_screen.dart';
import 'package:smartsystemforschools/features/payment_parent/data/cubit/parent_childs_transcations_cubit.dart';
import 'package:smartsystemforschools/features/payment_parent/data/cubit/parent_transcations_cubit.dart';
import 'package:smartsystemforschools/features/payment_parent/presentation/screens/transcation_details.dart';
import 'core/connectivity_cubit/connectivity_cubit.dart';
import 'core/connectivity_cubit/connectivity_state.dart';
import 'core/methods/show_scaffold_messanger.dart';
import 'core/models/get_child_details/result.dart';
import 'core/services/notification_service/confirmation_request_screen.dart';
import 'core/services/notification_service/notification_details_screen.dart';
import 'core/themes/dark_theme.dart';
import 'core/themes/light_theme.dart';
import 'core/services/alllegris_service/allegris_service.dart';
import 'core/utils/AppNavigatorKeys.dart';
import 'core/utils/api_keys.dart';
import 'core/utils/disconnect_page_view.dart';
import 'core/services/notification_service/messaging_config.dart';
import 'features/Allergies/data/manager/allegries_products_cubit/allegries_products_cubit.dart';
import 'features/Allergies/data/manager/get_all_catogries_cubit/get_all_catogries_cubit.dart';
import 'features/Allergies/data/manager/products_cubit/products_cubit.dart';
import 'features/Allergies/presentation/views/AllergiesView.dart';
import 'features/Attendance/data/manager/cubit/attendance_cubit.dart';
import 'features/Attendance/presentation/views/attendance_view.dart';
import 'features/chatbot/data/cubit/cubit/chatbot_cubit.dart';
import 'features/child_details_view/manager/spending_limit_cubit.dart/spending_limit_cubit.dart';
import 'features/child_details_view/views/child_details_view.dart';
import 'features/family/data/manager/add_child_cubit/add_child_cubit.dart';
import 'features/family/presentation/views/add_child_view.dart';
import 'features/family/presentation/views/family_view.dart';
import 'features/food_ai_view/data/cubit/cubit/meal_recommendation_cubit.dart';
import 'features/home/presentation/views/home_screen.dart';
import 'features/login/presenation/views/forgot_password.dart';
import 'features/login/presenation/views/log_in.dart';
import 'features/login/presenation/views/send_code.dart';
import 'features/login/presenation/views/sign_up_screen.dart';
import 'features/login/presenation/views/verfiy_code.dart';
import 'features/main_screen/presentation/views/main_screen.dart';
import 'features/notification_view/data/cubit/notification_cubit.dart';
import 'features/notification_view/presenation/views/notification_view.dart';
import 'features/onBoarding/views/pageview.dart';
import 'features/payment/presentation/manager/cubit/payment_cubit.dart';
import 'features/settings_view/presentation/manager/chage_data_profile/change_data_profile_cubit.dart';
import 'features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import 'features/settings_view/presentation/views/edit_profile.dart';
import 'features/settings_view/presentation/views/language_selection_page.dart';
import 'features/settings_view/presentation/views/privacy_view.dart';
import 'features/settings_view/presentation/views/terms_and_condition_view.dart';
import 'firebase_options.dart';
import 'generated/codegen_loader.g.dart';
import 'features/settings/presentation/widgets/change_password_page.dart';
import 'core/services/auth_service/auth_service.dart';
import 'features/Allergies/data/manager/allegris_catogries/allegris_cubit.dart';
import 'features/splash/presenation/views/splash_view.dart';
import 'features/settings/presentation/views/settings_view.dart';
import 'generated/locale_keys.g.dart';

bool isLoggedIn = false;
// Use the AppNavigatorKeys singleton to manage navigation keys
final appNavigatorKeys = AppNavigatorKeys();
void main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) => ModernErrorScreen(
        errorDetails: details,
      );
  Stripe.publishableKey = ApiKeys.stripePublishableKey;
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MessagingConfig.initFirebaseMessaging();
  FirebaseMessaging.onBackgroundMessage(MessagingConfig.messageHandler);
  isLoggedIn = await AuthService().isLoggedIn();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('fr'),
        Locale('es'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale(
        'en',
      ),
      assetLoader: const CodegenLoader(),
      useOnlyLangCode: true,
      saveLocale: true,
      child: MyApp(connectivity: Connectivity()),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Connectivity connectivity;
  const MyApp({super.key, required this.connectivity});

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
        BlocProvider(
            create: (context) => AllergiesCubitCatogry(AllergiesService())),
        BlocProvider(create: (context) => PaymentCubit()),
        BlocProvider(create: (context) => SpendingLimitCubit()),
        BlocProvider(
          create: (context) => InternetCubit(connectivity: Connectivity()),
        ),
        BlocProvider(
          create: (context) => AllergiesProductCubit(),
        ),
        BlocProvider(
          create: (context) => NotificationCubit(),
        ),
        BlocProvider(create: (context) => MealRecommendationCubit()),
        BlocProvider(
          create: (context) =>
              ParentChildsTranscationsCubit()..fetchTransactions(),
        ),
        BlocProvider(create: (context) => ChatCubit()),
        BlocProvider(create: (context) => ProductsCubit()),
        BlocProvider(
          create: (context) =>
              ParentTranscationsCubit()..fetchParentTransactions(),
        ),
        // BlocProvider<ChatHistoryCubit>(create: (context) => ChatHistoryCubit()),
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
              navigatorKey: appNavigatorKeys.mainNavigatorKey,
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
                  listener: (context, state) async {
                    int count = await getCount();
                    if (state is InternetDisconnected) {
                      dispalySnackBar(
                        context,
                        durationD: const Duration(days: 1),
                        color: Colors.red[700]!,
                        title: '',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.wifi_off_rounded,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    LocaleKeys
                                        .internetConnection_noInternetConnection
                                        .tr(),
                                    style: AppStyles.styleMedium16()
                                        .copyWith(color: Colors.white),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    LocaleKeys
                                        .internetConnection_pleaseYourNetworkSettings
                                        .tr(),
                                    style: AppStyles.styleMedium15()
                                        .copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state is InternetConnected) {
                      count == 1
                          ? dispalySnackBar(
                              context,
                              durationD: const Duration(seconds: 5),
                              title: LocaleKeys
                                  .internetConnection_internetConnectionRestored
                                  .tr(),
                              titleActionButton: 'ok',
                              color: Colors.green[700]!,
                            )
                          : null;
                      count++;
                      saveCount(count);
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
                LanguageSelectionPage.id: (context) =>
                    const LanguageSelectionPage(),
                ConfirmationRequestScreen.id: (context) =>
                    const ConfirmationRequestScreen(),
                NotificationDetails.id: (context) =>
                    const NotificationDetails(),
                TranscationDetails.id: (context) => const TranscationDetails(),
              },
              initialRoute: isLoggedIn ? MainScreen.id : SplashView.id);
        },
      ),
    );
  }
}

class Get {
  static BuildContext? get context =>
      appNavigatorKeys.mainNavigatorKey.currentContext;
  static NavigatorState? get navigator =>
      appNavigatorKeys.mainNavigatorKey.currentState;
}

void saveCount(int count) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('count', count);
}

Future<int> getCount() async {
  return await SharedPreferences.getInstance().then(
    (value) {
      return value.getInt('count') ?? 1;
    },
  );
}
