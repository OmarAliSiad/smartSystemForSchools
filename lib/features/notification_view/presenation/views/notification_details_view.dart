import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/core/utils/custom_wave_widget.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';
import '../../../../core/methods/show_scaffold_messanger.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/services/notification_service/get_notificatoin_details/get_notificatoin_details.dart';
import '../../../../core/widgets/build_loading_view.dart';
import '../../data/cubit/notification_cubit.dart';
import '../../data/cubit/notification_state.dart';
import '../../data/models/notification_model/notification_model.dart';
import '../../../settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';

class NotificationDetailsView extends StatefulWidget {
  final String notificationId;
  final String dateName;
  final NotificationModel notificationModel;
  const NotificationDetailsView({
    super.key,
    required this.notificationId,
    required this.notificationModel,
    required this.dateName,
  });

  @override
  State<NotificationDetailsView> createState() =>
      _NotificationDetailsViewState();
}

class _NotificationDetailsViewState extends State<NotificationDetailsView> {
  @override
  void initState() {
    super.initState();
    _loadNotificationDetails();
  }

  void _loadNotificationDetails() {
    context.read<NotificationCubit>().getNotificationDetails(
          notificationId: widget.notificationId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          LocaleKeys.notificationDetails_NotificationDetails.tr(),
          style: AppStyles.styleSemiBold20().copyWith(color: Colors.white),
        ),
        forceMaterialTransparency: true,
        flexibleSpace: const CustomWiveWidget(),
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
      body: BlocConsumer<NotificationCubit, NotificationState>(
        listener: (context, state) {
          if (state is NotificationFailure) {
            dispalySnackBar(
              context,
              title: state.error,
              color: Colors.red,
            );
          }
        },
        builder: (context, state) {
          if (state is NotificationDetailsLoaded) {
            final details = state.notificationDetails;
            if (details.isSuccess == false) {
              return Center(
                child: Text(
                    LocaleKeys.notificationDetails_NoDetailsAvailable.tr()),
              );
            }
            return _buildDetailsContent(details);
          } else if (state is NotificationDetailsLoading) {
            return buildLoadingView(
                LocaleKeys.notificationDetails_Notification.tr(), context);
          } else {
            String message = '';
            if (state is NotificationFailure) {
              message = state.error;
            }
            return Center(child: Text(message));
          }
        },
      ),
    );
  }

  Widget _buildDetailsContent(GetNotificatoinDetails notificationDetails) {
    final themeMode = context.read<ThemeModeCubit>().currentTheme;
    final backgroundColor =
        themeMode == ThemeMode.dark ? Colors.grey[850] : Colors.white;
    final textColor = themeMode == ThemeMode.dark ? Colors.white : Colors.black;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xff1A0F91).withOpacity(.10),
                child: _getNotificationIcon(notificationDetails.message ??
                    LocaleKeys.notificationDetails_Notification.tr()),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.notificationModel.result![0].title ??
                          LocaleKeys.notificationDetails_NoTitle.tr(),
                      style: AppStyles.styleSemiBold20(),
                    ),
                    if (notificationDetails.result!.createdOn != null)
                      Text(
                        '${LocaleKeys.notificationDetails_createdAt.tr()} ${DateFormat.yMMMd().add_jm().format(notificationDetails.result!.createdOn!.add(const Duration(hours: 1)))}',
                        style: TextStyle(color: textColor.withOpacity(0.7)),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Status indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color:
                  _getStatusColor(notificationDetails.result!.studentName ?? "")
                      .withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${LocaleKeys.notificationDetails_studentName.tr()} : ${notificationDetails.result!.studentName}' ??
                  LocaleKeys.notificationDetails_UnknownStatus.tr(),
              style: TextStyle(
                color: _getStatusColor(
                    notificationDetails.result!.studentName ?? ""),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Message content
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: themeMode == ThemeMode.dark ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: themeMode == ThemeMode.dark
                      ? const Color(0xFFFFFFFF).withOpacity(.4)
                      : const Color(0x3F000000),
                  blurRadius: 6,
                  offset: const Offset(0, 0),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.notificationDetails_Message.tr(),
                  style: AppStyles.styleMedium16().copyWith(
                    color: const Color(0xff1A0F91),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.notificationModel.result![0].message ??
                      LocaleKeys.notificationDetails_NoMessageContent.tr(),
                  style: AppStyles.styleRegular16(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Additional Info Section
          Text(
            LocaleKeys.notificationDetails_AdditionalInformation.tr(),
            style: AppStyles.styleSemiBold20().copyWith(fontSize: 18),
          ),
          const SizedBox(height: 16),
          if (notificationDetails.result!.studentId != null)
            _buildInfoItem(
                LocaleKeys.notificationDetails_StudentID.tr(),
                notificationDetails.result!.studentId ??
                    LocaleKeys.notificationDetails_NotAvailable.tr()),
          if (notificationDetails.result!.studentName != null)
            _buildInfoItem(
                LocaleKeys.notificationDetails_StudentName.tr(),
                notificationDetails.result!.studentName ??
                    LocaleKeys.notificationDetails_NotAvailable.tr()),
          if (notificationDetails.result!.cashierId != null)
            _buildInfoItem(
                LocaleKeys.notificationDetails_cashierId.tr(),
                notificationDetails.result!.cashierId ??
                    LocaleKeys.notificationDetails_NotAvailable.tr()),
          if (notificationDetails.result!.cashierName != null)
            _buildInfoItem(
                LocaleKeys.notificationDetails_cashierName.tr(),
                notificationDetails.result!.cashierName ??
                    LocaleKeys.notificationDetails_NotAvailable.tr()),
          if (notificationDetails.result!.createdOn != null)
            _buildInfoItem(
                LocaleKeys.notificationDetails_createdat.tr(),
                DateFormat('yyyy-MM-dd hh:mm')
                        .format(notificationDetails.result!.createdOn!) ??
                    LocaleKeys.notificationDetails_NotAvailable.tr()),
          if (notificationDetails.result!.schoolTenantId != null)
            _buildInfoItem(
                LocaleKeys.notificationDetails_schoolName.tr(),
                notificationDetails.result!.schoolTenantId ??
                    LocaleKeys.notificationDetails_NotAvailable.tr()),
          const SizedBox(height: 16),
          Text(
            LocaleKeys.notificationDetails_productInformation.tr(),
            style: AppStyles.styleSemiBold20().copyWith(fontSize: 18),
          ),
          _buildInfoItem(
              LocaleKeys.notificationDetails_ProductNames.tr(),
              notificationDetails.result!.studentTransactionItems!
                      .map((e) => e.productName!)
                      .toList()
                      .toString() ??
                  LocaleKeys.notificationDetails_NotAvailable.tr()),
          _buildInfoItem(
              LocaleKeys.notificationDetails_Productprices.tr(),
              notificationDetails.result!.studentTransactionItems!
                  .map((e) => e.price!)
                  .toList()
                  .toString()),
          _buildInfoItem(
              LocaleKeys.notificationDetails_Productquantities.tr(),
              notificationDetails.result!.studentTransactionItems!
                  .map((e) => e.quantity!)
                  .toList()
                  .toString()),
          _buildInfoItem(
              LocaleKeys.notificationDetails_TotalAmountOfMoney.tr(),
              notificationDetails.result!.studentTransactionItems!
                  .map((e) => e.quantity! * e.price!)
                  .reduce((a, b) => a + b)
                  .toString()),
          // Actions buttons row
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    final themeMode = context.read<ThemeModeCubit>().currentTheme;
    return Container(
      margin: const EdgeInsetsDirectional.symmetric(vertical: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeMode == ThemeMode.dark ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: themeMode == ThemeMode.dark
                ? const Color(0xFFFFFFFF).withOpacity(.4)
                : const Color(0x3F000000),
            blurRadius: 6,
            offset: const Offset(0, 0),
            spreadRadius: 0,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppStyles.styleBold14().copyWith(
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8.0),
            Text(
              value,
              style: AppStyles.styleRegular16(),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    status = status.toLowerCase();
    if (status == "read") return Colors.green;
    if (status == "unread") return Colors.blue;
    if (status.contains("fail") || status.contains("error")) return Colors.red;
    return Colors.grey;
  }

  // Returns the appropriate icon based on notification type
  Widget _getNotificationIcon(String title) {
    IconData iconData = Icons.notifications_none_rounded;

    if (title.toLowerCase().contains("transaction")) {
      iconData = Icons.payment;
    } else if (title.toLowerCase().contains("attendance")) {
      iconData = Icons.event_available;
    } else if (title.toLowerCase().contains("notice")) {
      iconData = Icons.announcement;
    }
    return Icon(
      size: 36,
      iconData,
      color: const Color(0xff1A0F91),
    );
  }
}
