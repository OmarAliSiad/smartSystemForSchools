import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCard extends StatelessWidget {
  final String date;
  final String title;
  final String message;

  const NotificationCard({
    super.key,
    required this.date,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final themeMode = context.read<ThemeModeCubit>().currentTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: themeMode == ThemeMode.dark ? null : Colors.white,
        border: Border.all(
          color: themeMode == ThemeMode.dark ? Colors.white : Colors.white,
        ),
        boxShadow: [
          themeMode == ThemeMode.light
              ? const BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 6.80,
                  offset: Offset(0, 0),
                  spreadRadius: 0,
                )
              : BoxShadow(
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                  color: Colors.black.withOpacity(0.13),
                )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circle Avatar - Keep this exactly as it was
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xff1A0F91).withOpacity(.10),
              child: _getNotificationIcon(title),
            ),
            const SizedBox(width: 12),
            // Content area - Use Expanded to take remaining space
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row with flexible layout
                  Row(
                    children: [
                      // Make title flexible to avoid overflow
                      Expanded(
                        child: Text(
                          title,
                          style: AppStyles.styleSemiBold20(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Date with constrained width to avoid overflow
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          _formatDate(date),
                          style: AppStyles.styleRegular14().copyWith(
                            color:
                                context.read<ThemeModeCubit>().currentTheme ==
                                        ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black.withOpacity(.70),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Message content
                  Text(
                    message,
                    style: AppStyles.styleRegular16().copyWith(
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to format date string to save horizontal space
  String _formatDate(String dateStr) {
    try {
      if (dateStr.isEmpty) return '';

      // Parse the date string
      final DateTime date = DateTime.parse(dateStr);

      // Format as needed - using a shorter format
      return DateFormat('MMM d, h:mm a')
          .format(date.add(const Duration(hours: 1)));
    } catch (e) {
      return dateStr; // Return original if parsing fails
    }
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
      size: 28,
      iconData,
      color: const Color(0xff1A0F91),
    );
  }
}
