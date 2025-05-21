import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../data/cubit/notification_cubit.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import 'notification_card_widget.dart';

class SetcionNotificationCard extends StatefulWidget {
  final String dateName;
  final String date;
  final String title;
  final String message;
  final String notificationId;
  const SetcionNotificationCard({
    super.key,
    required this.date,
    required this.title,
    required this.message,
    required this.notificationId,
    required this.dateName,
  });

  @override
  State<SetcionNotificationCard> createState() =>
      _SetcionNotificationCardState();
}

class _SetcionNotificationCardState extends State<SetcionNotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.dateName,
          style: AppStyles.styleRegular20().copyWith(
            fontSize: 16,
            color: context.watch<ThemeModeCubit>().currentTheme == ThemeMode.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        widget.date == null
            ? const SizedBox()
            : const SizedBox(
                height: 17,
              ),
        Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                borderRadius: BorderRadius.circular(5),
                backgroundColor: const Color(0xffff0000),
                icon: Icons.delete,
                label: 'Delete',
                onPressed: (context) {
                  context.read<NotificationCubit>().deleteNotification(
                      notificationId: widget.notificationId);
                },
              ),
            ],
          ),
          child: NotificationCard(
            date: widget.date,
            title: widget.title,
            message: widget.message,
          ),
        ),
      ],
    );
  }
}
