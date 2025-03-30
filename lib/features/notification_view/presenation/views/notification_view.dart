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

    // Always ensure there's a filter applied
    if (notificationCubit.state is NotificationInitial ||
        !notificationCubit.hasActiveFilter()) {
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
    // Reload when dependencies change
    context.read<NotificationCubit>().reloadNotifications();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Reload when app is resumed
      context.read<NotificationCubit>().reloadNotifications();
    }
  }

  @override
  void didUpdateWidget(NotificationView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload when widget is updated
    context.read<NotificationCubit>().reloadNotifications();
  }

  // This correctly implements the WidgetsBindingObserver method
  @override
  void didPopNext() {
    // This is called when the screen becomes visible again after another screen is popped
    if (mounted) {
      context.read<NotificationCubit>().reloadNotifications();
    }
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
              final notificationCubit = context.read<NotificationCubit>();
              final currentStudentId =
                  notificationCubit.getCurrentStudentId() ??
                      widget.childDetails[0].id.toString();

              showFilterBottomSheet(
                context: context,
                childDetails: widget.childDetails,
                selectedStudentId: currentStudentId,
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
      body: BlocListener<NotificationCubit, NotificationState>(
        listener: (context, state) {
          // Handle specific state transitions if needed
          if (state is NotificationDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: NotificationViewBody(resultForChildDetails: widget.childDetails),
      ),
    );
  }
}
