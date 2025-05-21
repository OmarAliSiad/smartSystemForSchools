import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/fcm_token_service/fcm_token_service.dart';
import '../../../../core/utils/Constants.dart';
import '../../../main_screen/presentation/views/main_screen.dart';
import '../../../../core/methods/show_scaffold_messanger.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/services/auth_service/auth_service.dart';
import '../../data/models/user_info_model.dart';

class CustomButtonLogIn extends StatefulWidget {
  final TextEditingController userName;
  final Function(bool login) callback;
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
                widget.callback(true);
                setState(() {
                  loading = true;
                });
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
                  } else {
                    log('email not found in SharedPreferences');
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
                  if (response.statusCode == 200) {
                    FCMTokenService().saveToken();
                    log('set user');
                    UserInfoModel userInfo =
                        UserInfoModel.fromJson(response.data);
                    log(userInfo.toJson().toString());
                    AuthService().setUser(userModel: userInfo);
                    log('user is set');
                    if (mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const MainScreen()),
                          (route) => false);
                      dispalySnackBar(
                        context,
                        title: 'Login Successfully',
                        titleActionButton: 'Ok',
                        color: Colors.green,
                      );
                    }
                  } else {
                    if (mounted) {
                      dispalySnackBar(
                        context,
                        title: response.data.toString(),
                        titleActionButton: 'Ok',
                        color: Colors.red,
                      );
                    }
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
                    'Logging in...',
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
