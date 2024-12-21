import 'package:flutter/material.dart';
import '../widgets/splash_view_body.dart';

class SplashView extends StatelessWidget {
  static String id = 'SplashView';
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF191BA9),
      body: SplashViewBody(),
    );
  }
}
