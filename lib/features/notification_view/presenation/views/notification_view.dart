import 'package:flutter/material.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../main_screen/presentation/views/main_screen.dart';
import '../widgets/notification_viewBody.dart';

class NotificationView extends StatelessWidget {
  static const String id = 'NotificationView';
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text('Notifications', style: AppStyles.styleSemiBold20()),
        forceMaterialTransparency: true,
        leading: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                MainScreen.id,
                (context) => false,
              );
            },
            child: const Icon(Icons.arrow_back_ios)),
      ),
      body: const NotificationViewBody(),
    );
  }
}
