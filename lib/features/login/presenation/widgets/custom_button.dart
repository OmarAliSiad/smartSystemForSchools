import 'package:flutter/material.dart';
import 'package:smartsystemforschools/features/main_screen/presentation/views/main_screen.dart';
import '../../../../core/utils/app_styles.dart';

class CustomButtonLogIn extends StatefulWidget {
  final TextEditingController email;
  final TextEditingController password;
  final GlobalKey<FormState> formState;
  final String text;
  const CustomButtonLogIn(
      {super.key,
      required this.text,
      required this.formState,
      required this.email,
      required this.password});
  @override
  State<CustomButtonLogIn> createState() => _CustomButtonLogInState();
}

class _CustomButtonLogInState extends State<CustomButtonLogIn> {
  bool created = false;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      color: const Color(0xff191BA9),
      onPressed: () async {
        if (widget.formState.currentState!.validate()) {
          Navigator.of(context).pushReplacementNamed(MainScreen.id);
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      minWidth: 347,
      height: 48,
      child: Text(
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
