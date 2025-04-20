import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:smartsystemforschools/core/methods/show_scaffold_messanger.dart';
import 'package:smartsystemforschools/features/main_screen/presentation/views/main_screen.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/services/auth_service/auth_service.dart';
import '../../data/models/user_info_model.dart';

class CustomButtonSignup extends StatefulWidget {
  final TextEditingController userName;
  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController confirmPassword;
  final TextEditingController schoolTenantId;
  final GlobalKey<FormState> formState;
  final String text;
  const CustomButtonSignup({
    super.key,
    required this.text,
    required this.formState,
    required this.email,
    required this.password,
    required this.userName,
    required this.confirmPassword,
    required this.schoolTenantId,
  });
  @override
  State<CustomButtonSignup> createState() => _CustomButtonSignupState();
}

class _CustomButtonSignupState extends State<CustomButtonSignup>
    with SingleTickerProviderStateMixin {
  bool created = false;
  bool loading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
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
                if (widget.confirmPassword.text == widget.password.text) {
                  try {
                    setState(() {
                      loading = true;
                    });
                    final response = await AuthService().register(
                      url: 'https://school-api.runasp.net/api/Account/register',
                      body: {
                        "userName": widget.userName.text.trim(),
                        "email": widget.email.text.trim(),
                        "password": widget.password.text.trim(),
                        "confirmPassword": widget.confirmPassword.text.trim(),
                        "schoolTenantId": widget.schoolTenantId.text.trim(),
                      },
                    );
                    log(response.toString());
                    if (response.statusCode == 200) {
                      UserInfoModel userInfo =
                          UserInfoModel.fromJson(response.data);
                      AuthService().setUser(userModel: userInfo);
                      if (mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            MainScreen.id, (_) => false);
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
                  } catch (e) {
                    if (mounted) {
                      dispalySnackBar(
                        context,
                        title: 'An error occurred. Please try again.',
                        titleActionButton: 'Ok',
                        color: Colors.red,
                      );
                    }
                  } finally {
                    if (mounted) {
                      setState(() {
                        loading = false;
                      });
                    }
                  }
                } else {
                  if (mounted) {
                    dispalySnackBar(
                      context,
                      title: 'Password not match',
                      titleActionButton: 'Ok',
                      color: Colors.red,
                    );
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
                    'register ...',
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

//   void LogIn() async {
//     SharedPreferences sharedPreferences =   await SharedPreferences.getInstance();
//     try {
//       if (!created) {
//         print(created);
//         if (sharedPreferences.getBool('isLogin') == null ||
//             sharedPreferences.getBool('isLogin') == false) {
//           final userCredential1 = await FirebaseAuth.instance
//               .createUserWithEmailAndPassword(
//                   email: widget.email.text, password: widget.password.text);
//           created = true;
//           if (!userCredential1.user!.emailVerified) {
//             showAswemoDialog(
//               context: context,
//               dialogType: DialogType.success,
//               title: 'Success',
//               desc: 'Verification email sent. Please check your inbox.',
//             );
//             await userCredential1.user!.sendEmailVerification();
//             setState(() {
//               created = true;
//             });
//           }
//         } else {
//           Navigator.of(context)
//               .pushNamedAndRemoveUntil(MainScreen.id, (context) => false);
//         }
//       } else {
//         sharedPreferences = await SharedPreferences.getInstance();
//         sharedPreferences.setBool('isLogin', true);
//         Navigator.of(context)
//             .pushNamedAndRemoveUntil(MainScreen.id, (context) => false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Welcome to home page'),
//             action: SnackBarAction(
//               label: 'Ok',
//               onPressed: () {},
//             ),
//           ),
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       Handle error
//       showAswemoDialog(
//         context: context,
//         dialogType: DialogType.error,
//         title: 'Error',
//         desc: e.message ?? 'An error occurred during login.',
//       );
//     }
//   }
// }
