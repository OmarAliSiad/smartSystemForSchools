import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import '../../../../core/services/auth_service/auth_service.dart';
import '../../../login/data/models/user_info_model.dart';

class InfoUserRowWidget extends StatefulWidget {
  const InfoUserRowWidget({super.key});

  @override
  State<InfoUserRowWidget> createState() => _InfoUserRowWidgetState();
}

class _InfoUserRowWidgetState extends State<InfoUserRowWidget> {
  late UserInfoModel userInfo;
  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    UserInfoModel info = await AuthService().getUserInfo();
    setState(() {
      userInfo = info;
    });
    log(userInfo.username.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.supervised_user_circle_outlined,
        ),
        const SizedBox(
          width: 12,
        ),
        Text(
          userInfo.username!,
          style: AppStyles.styleMedium18(),
        ),
      ],
    );
  }
}
