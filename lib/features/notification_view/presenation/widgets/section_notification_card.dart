import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import '../../data/models/notification_card_model.dart';
import 'notification_card_widget.dart';

class SetcionNotificationCard extends StatefulWidget {
  final String? currentDate;
  final NotificationCardModel notificationCardModel;
  const SetcionNotificationCard({
    super.key,
    this.currentDate,
    required this.notificationCardModel,
  });

  @override
  State<SetcionNotificationCard> createState() =>
      _SetcionNotificationCardState();
}

class _SetcionNotificationCardState extends State<SetcionNotificationCard> {
  bool isdeleted = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.currentDate ?? '',
          style: AppStyles.styleRegular20().copyWith(
            fontSize: 16,
            color: context.read<ThemeModeCubit>().currentTheme == ThemeMode.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        widget.currentDate == null
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
                  isdeleted = true;
                  setState(() {});
                },
              ),
            ],
          ),
          child: isdeleted
              ? Container()
              : NotificationCard(
                  notificationCardModel: widget.notificationCardModel,
                ),
        ),
      ],
    );
  }
}
