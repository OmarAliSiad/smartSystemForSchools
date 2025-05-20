import 'package:flutter/material.dart';
import 'app_styles.dart';

class DisconnectedPageView extends StatelessWidget {
  const DisconnectedPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off,
              size: 100,
              color: Colors.red,
            ),
            Text(
              'No internet connection',
              style: AppStyles.styleBold20(),
            ),
          ],
        ),
      ),
    );
  }
}
