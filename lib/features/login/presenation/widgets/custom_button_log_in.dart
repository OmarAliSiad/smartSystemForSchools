import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';
import '../../../../core/services/fcm_token_service/fcm_token_service.dart';
import '../../../../core/utils/Constants.dart';
import '../../../main_screen/presentation/views/main_screen.dart';
import '../../../../core/methods/show_scaffold_messanger.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/services/auth_service/auth_service.dart';
import '../../data/models/user_info_model.dart';

class CustomButtonLogIn extends StatefulWidget {
  final TextEditingController userName;
  final Function(bool) callback; // Changed to accept bool parameter
  final TextEditingController password;
  final GlobalKey<FormState> formState;
  final String text;
  const CustomButtonLogIn({
    super.key,
    required this.text,
    required this.formState,
    required this.userName,
    required this.password,
    required this.callback,
  });
  @override
  State<CustomButtonLogIn> createState() => _CustomButtonLogInState();
}

class _CustomButtonLogInState extends State<CustomButtonLogIn>
    with SingleTickerProviderStateMixin {
  bool created = false;
  bool loading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      color: const Color(0xff191BA9),
      onPressed: loading
          ? null
          : () async {
              if (widget.formState.currentState!.validate()) {
                setState(() {
                  loading = true;
                });
                widget.callback(true);
                late Response response;
                try {
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  if (sharedPreferences.containsKey(Constants.email)) {
                    String email =
                        sharedPreferences.getString(Constants.email)!;
                    String username =
                        sharedPreferences.getString(Constants.username)!;
                    log('email $email');
                    log('username $username');
                  }

                  log('email ${widget.userName.text}');
                  log('password ${widget.password.text}');

                  response = await AuthService().login(
                    url: 'https://school-api.runasp.net/api/Account/login',
                    body: {
                      "userName": widget.userName.text.trim(),
                      "password": widget.password.text.trim(),
                    },
                  );

                  if (response.statusCode == 200 && response.data != null) {
                    UserInfoModel userInfo =
                        UserInfoModel.fromJson(response.data);
                    if (userInfo.username == null ||
                        userInfo.username!.trim().isEmpty) {
                      if (context.mounted) {
                        dispalySnackBar(
                          context,
                          title: LocaleKeys.Auth_invalidUserDataReceived.tr(),
                          titleActionButton: LocaleKeys.Auth_Ok.tr(),
                          color: Colors.red,
                        );
                      }
                      return;
                    }

                    FCMTokenService().saveToken();
                    log('Setting user info');
                    await AuthService().setUser(userModel: userInfo);
                    log('User info set successfully');

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text(LocaleKeys.Auth_loginSuccessfully.tr()),
                          backgroundColor: Colors.green,
                          action: SnackBarAction(
                            label: LocaleKeys.Auth_Ok.tr(),
                            textColor: Colors.white,
                            onPressed: () {},
                          ),
                        ),
                      );

                      await Future.delayed(const Duration(milliseconds: 500));

                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const MainScreen()),
                            (route) => false);
                      }
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            response.data?.toString() ??
                                LocaleKeys.Auth_loginFailed.tr(),
                          ),
                          backgroundColor: Colors.red,
                          action: SnackBarAction(
                            label: LocaleKeys.Auth_Ok.tr(),
                            textColor: Colors.white,
                            onPressed: () {},
                          ),
                        ),
                      );
                    }
                  }
                } catch (e) {
                  log('Login error: $e');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          LocaleKeys.Auth_loginFailed.tr(),
                        ),
                        backgroundColor: Colors.red,
                        action: SnackBarAction(
                          label: LocaleKeys.Auth_Ok.tr(),
                          textColor: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                    );
                  }
                } finally {
                  if (mounted) {
                    setState(() {
                      loading = false;
                    });
                    widget.callback(false);
                  }
                }
              }
            },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      minWidth: 347,
      height: 48,
      child: loading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blue,
                      )),
                ),
                const SizedBox(width: 12),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    LocaleKeys.Auth_loggingIn.tr(),
                    style: AppStyles.styleMedium18(),
                  ),
                ),
              ],
            )
          : Text(
              widget.text,
              style: AppStyles.styleMedium18().copyWith(color: Colors.white),
            ),
    );
  }
}
