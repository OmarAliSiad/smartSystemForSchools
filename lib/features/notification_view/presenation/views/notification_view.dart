import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smartsystemforschools/core/models/get_child_details/result.dart';
import 'package:smartsystemforschools/core/utils/notification_service/notification_service.dart';
import 'package:smartsystemforschools/features/notification_view/data/cubit/notification_cubit.dart';
import 'package:smartsystemforschools/features/notification_view/data/cubit/notification_state.dart';
import 'package:smartsystemforschools/features/notification_view/presenation/widgets/show_modal_bottom_sheet.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import '../../../../core/utils/app_styles.dart';
import '../widgets/notification_viewBody.dart';

class NotificationView extends StatefulWidget {
  final List<ResultForChildDetails> childDetails;
  static const String id = 'NotificationView';
  const NotificationView({super.key, required this.childDetails});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView>
    with WidgetsBindingObserver {
  String selectedStudentId = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Log child details for debugging
    for (var child in widget.childDetails) {
      log(child.id.toString());
      log(child.fullName.toString());
    }

    // Initialize notifications if needed
    _loadInitialNotifications();
  }

  void _loadInitialNotifications() {
    // Check if we have an active filter or need to set a default one
    final notificationCubit = context.read<NotificationCubit>();
    if (notificationCubit.state is NotificationInitial) {
      // Apply initial filter with first child's ID
      notificationCubit.applyFilter(
        studentId: widget.childDetails[0].id.toString(),
      );
    } else {
      // Reload with existing filter
      notificationCubit.reloadNotifications();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This can also be a good place to reload data
  }

  @override
  void didPopNext() {
    // This is called when the screen becomes visible again after another screen is popped
    context.read<NotificationCubit>().reloadNotifications();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              showFilterBottomSheet(
                context: context,
                childDetails: widget.childDetails,
                selectedStudentId: widget.childDetails[0].id.toString(),
                onStudentSelected: (studentId) {
                  setState(() {
                    selectedStudentId = studentId;
                  });
                },
                isDark: context.read<ThemeModeCubit>().currentTheme ==
                        ThemeMode.dark
                    ? true
                    : false,
              );
            },
          )
        ],
        elevation: 0,
        title: Text('Notifications', style: AppStyles.styleSemiBold20()),
        forceMaterialTransparency: true,
        leading: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back_ios)),
      ),
      body: NotificationViewBody(
          resultForChildDetails: widget.childDetails,
          selectedStudentId: selectedStudentId),
    );
  }
}
