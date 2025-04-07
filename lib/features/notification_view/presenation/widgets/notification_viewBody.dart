import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smartsystemforschools/core/methods/show_scaffold_messanger.dart';
import 'package:smartsystemforschools/core/models/get_child_details/result.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import 'package:smartsystemforschools/core/utils/notification_service/notification_service.dart';
import 'package:smartsystemforschools/core/widgets/build_loading_view.dart';
import 'package:smartsystemforschools/features/notification_view/data/cubit/notification_cubit.dart';
import 'package:smartsystemforschools/features/notification_view/data/cubit/notification_state.dart';
import 'package:smartsystemforschools/features/notification_view/data/models/notification_model/notification_model.dart';
import 'package:smartsystemforschools/features/notification_view/presenation/views/notification_details_view.dart';
import 'package:smartsystemforschools/features/notification_view/presenation/widgets/section_notification_card.dart';

class NotificationViewBody extends StatefulWidget {
  final List<ResultForChildDetails> resultForChildDetails;
  final String selectedStudentId;
  const NotificationViewBody(
      {super.key,
      required this.resultForChildDetails,
      required this.selectedStudentId});

  @override
  State<NotificationViewBody> createState() => _NotificationViewBodyState();
}

class _NotificationViewBodyState extends State<NotificationViewBody> {
  final f = DateFormat('yyyy-MM-dd hh:mm');
  @override
  initState() {
    super.initState();
    loadNotification();
  }

  loadNotification() async {
    await context.read<NotificationCubit>().getAllNotifications(
          filterModel: FilterNotificationModel(
              studentId: widget.resultForChildDetails[0].id.toString()),
        );
  }

  String knowTheDate({required DateTime createdOn}) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));
    DateTime createdDate =
        DateTime(createdOn.year, createdOn.month, createdOn.day);
    log(createdDate.toIso8601String());
    log(yesterday.toIso8601String());
    if (createdDate == today) {
      return 'Today';
    } else if (createdDate == yesterday) {
      return 'Yesterday';
    } else if (today.difference(createdDate).inDays <= 7) {
      return 'Last Week';
    } else {
      return '${createdOn.year}-${createdOn.month}-${createdOn.day}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationCubit, NotificationState>(
      listener: (context, state) {
        if (state is NotificationFailure || state is NotificationDeleted) {
          String message = '';
          if (state is NotificationDeleted) {
            message = state.message;
          }
          if (state is NotificationFailure) {
            message = state.error;
          }
          dispalySnackBar(context, title: message, color: Colors.red);
        } else if (state is GetAllNotificationLoadedSuccessfully) {
          if (state.notificationModel.result!.isEmpty) {
            dispalySnackBar(context,
                title: 'No notifications found', color: Colors.red);
          } else {
            dispalySnackBar(context,
                title: 'Notifications loaded successfully',
                color: Colors.green);
          }
        } else if (state is NotificationDeleted) {
          dispalySnackBar(context, title: state.message, color: Colors.green);
        }
      },
      builder: (context, state) {
        if (state is NotificationLoading) {
          return buildLoadingView('Notification', context);
        } else if (state is GetAllNotificationLoadedSuccessfully) {
          NotificationModel notificationModel = state.notificationModel;
          if (notificationModel.result!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.notifications_none,
                    size: 100,
                    color: Colors.grey,
                  ),
                  Text(
                    'No Notifications found',
                    style: AppStyles.styleMedium18(),
                  ),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsetsDirectional.only(start: 21, end: 19),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      navigateToNotificationDetails(
                        context,
                        notificationModel.result![index].id.toString(),
                        knowTheDate(
                          createdOn:
                              notificationModel.result![index].createdOn!,
                        ),
                        notificationModel,
                      );
                    },
                    child: SetcionNotificationCard(
                      dateName: knowTheDate(
                        createdOn: notificationModel.result![index].createdOn!,
                      ),
                      notificationId:
                          notificationModel.result![index].id.toString(),
                      date:
                          f.format(notificationModel.result![index].createdOn!),
                      title: notificationModel.result![index].title.toString(),
                      message:
                          notificationModel.result![index].message.toString(),
                    ),
                  );
                },
                itemCount: notificationModel.result!.length,
                physics: const BouncingScrollPhysics(),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
              ),
            );
          }
        } else {
          return const Center(child: Text('empty'));
        }
      },
    );
  }
}

// Replace your current navigation to notification details with this
void navigateToNotificationDetails(BuildContext context, String notificationId,
    String dateName, NotificationModel notificationModel) async {
  // Navigate and wait for result
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => NotificationDetailsView(
        notificationId: notificationId,
        dateName: dateName,
        notificationModel: notificationModel,
      ),
    ),
  );
  // When the future completes, the user has returned to this screen
  // Reload the notifications
  if (context.mounted) {
    context.read<NotificationCubit>().reloadNotifications();
  }
}
