import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/core/utils/custom_wave_widget.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';
import '../../../../core/models/get_child_details/result.dart';
import '../../data/cubit/notification_cubit.dart';
import '../../data/cubit/notification_state.dart';
import '../widgets/show_modal_bottom_sheet.dart';
import '../../../settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import '../../../../core/utils/app_styles.dart';
import '../widgets/notification_viewBody.dart';

class NotificationView extends StatefulWidget {
  final List<ResultForChildDetails> childDetails;
  static const String id = '/NotificationView';
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

    // Initialize selectedStudentId with first child's ID
    if (widget.childDetails.isNotEmpty) {
      selectedStudentId = widget.childDetails[0].id.toString();
    }

    // Schedule the initial load for after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialNotifications();
    });
  }

  void _loadInitialNotifications() {
    // Ensure the widget is still mounted before accessing context
    if (!mounted) return;

    // Check if we have an active filter or need to set a default one
    final notificationCubit = context.read<NotificationCubit>();
    if (notificationCubit.state is NotificationInitial) {
      // Apply initial filter with first child's ID
      if (widget.childDetails.isNotEmpty) {
        notificationCubit.applyFilter(
          studentId: widget.childDetails[0].id.toString(),
        );
      }
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
    log('Reloading notifications after returning to this screen');
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
  Widget build(BuildContext mainContext) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const CustomWiveWidget(),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              if (widget.childDetails.isNotEmpty) {
                showFilterBottomSheet(
                  context: mainContext,
                  childDetails: widget.childDetails,
                  selectedStudentId: selectedStudentId.isNotEmpty
                      ? selectedStudentId
                      : widget.childDetails[0].id.toString(),
                  onStudentSelected: (studentId) {
                    if (mounted) {
                      setState(() {
                        selectedStudentId = studentId;
                      });
                    }
                  },
                  isDark: context.read<ThemeModeCubit>().currentTheme ==
                          ThemeMode.dark
                      ? true
                      : false,
                );
              }
            },
          )
        ],
        elevation: 0,
        title: Text(
          LocaleKeys.notifacation_appBarText.tr(),
          style: AppStyles.styleSemiBold20().copyWith(color: Colors.white),
        ),
        forceMaterialTransparency: true,
        leading: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: NotificationViewBody(
        resultForChildDetails: widget.childDetails,
        selectedStudentId: selectedStudentId,
      ),
    );
  }
}
