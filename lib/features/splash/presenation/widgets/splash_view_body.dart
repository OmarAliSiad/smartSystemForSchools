import 'package:flutter/material.dart';
import 'custom_sliding_animation.dart';
import '../../../../core/widgets/custom_bottom_container.dart';
import '../../../onBoarding/views/pageview.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> slidingAnimtaionText1;
  @override
  void initState() {
    super.initState();
    InitSlidingAnimation();
    NavigateToHome();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomSlidingAnimation(slidingAnimtaion: slidingAnimtaionText1),
          ],
        ),
        const Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: CustomBottomContainer(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  void NavigateToHome() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, PagesScreen.id);
    });
  }

  void InitSlidingAnimation() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    slidingAnimtaionText1 =
        Tween(begin: 0.0, end: 5.0).animate(animationController);
    animationController.forward();
  }
}
