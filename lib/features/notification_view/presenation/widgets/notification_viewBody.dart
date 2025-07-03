import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/methods/show_scaffold_messanger.dart';
import '../../../../core/models/get_child_details/result.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/services/notification_service/notification_service.dart';
import '../../../../core/widgets/build_loading_view.dart';
import '../../data/cubit/notification_cubit.dart';
import '../../data/cubit/notification_state.dart';
import '../../data/models/notification_model/notification_model.dart';
import '../views/notification_details_view.dart';
import 'section_notification_card.dart';

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
    // Get the current cubit
    final cubit = context.read<NotificationCubit>();
    // Check if we have a saved filter or need to create a new one
    if (cubit.hasActiveFilter()) {
      // Just reload with existing filter
      await cubit.reloadNotifications();
    } else {
      // Apply a new filter
      await cubit.getAllNotifications(
        filterModel: FilterNotificationModel(
          studentId: widget.resultForChildDetails[0].id.toString(),
        ),
      );
    }
  }

  String knowTheDate({required DateTime createdOn}) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));
    DateTime createdDate =
        DateTime(createdOn.year, createdOn.month, createdOn.day);
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
      buildWhen: (previous, current) =>
          current is NotificationLoading ||
          current is GetAllNotificationLoadedSuccessfully ||
          current is NotificationDeleted,
      listenWhen: (previous, current) =>
          current is NotificationFailure ||
          current is NotificationDeleted ||
          current is GetAllNotificationLoadedSuccessfully,
      listener: (context, state) {
        // Ensure we're still mounted before proceeding
        if (!mounted) return;

        String? message;
        Color? color;

        if (state is NotificationFailure) {
          message = state.error;
          color = Colors.red;
        } else if (state is NotificationDeleted) {
          message = state.message;
          color = Colors.green;
        } else if (state is GetAllNotificationLoadedSuccessfully) {
          if (state.notificationModel.result!.isEmpty) {
            message = 'No notifications found';
            color = Colors.red;
          }
          // Only show success message on explicit success states
          // Removed the "Notifications loaded successfully" message to reduce noise
        }

        // Only show SnackBar if we have a message to display
        if (message != null && color != null && context.mounted) {
          final messenger = ScaffoldMessenger.of(context);
          messenger.clearSnackBars();

          // Schedule the SnackBar for the next frame
          Future.microtask(() {
            if (context.mounted) {
              messenger.showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(8),
                  content: Text(message!),
                  backgroundColor: color,
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'Ok',
                    textColor: Colors.white,
                    onPressed: () {
                      messenger.hideCurrentSnackBar();
                    },
                  ),
                ),
              );
            }
          });
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
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsetsDirectional.only(start: 21, end: 19),
                  sliver: SliverList.separated(
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
                            createdOn:
                                notificationModel.result![index].createdOn!,
                          ),
                          notificationId:
                              notificationModel.result![index].id.toString(),
                          date: f.format(
                              notificationModel.result![index].createdOn!),
                          title:
                              notificationModel.result![index].title.toString(),
                          message: notificationModel.result![index].message
                              .toString(),
                        ),
                      );
                    },
                    itemCount: notificationModel.result!.length,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                  ),
                ),
              ],
            );
          }
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.filter_alt,
                  size: 70,
                ),
                const SizedBox(height: 20),
                Text(
                  'Select Notification Filters',
                  style: AppStyles.styleMedium20(),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

// Replace your current navigation to notification details with this
void navigateToNotificationDetails(BuildContext context, String notificationId,
    String dateName, NotificationModel notificationModel) async {
  // Store the current state before navigation
  final notificationCubit = context.read<NotificationCubit>();

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
}
