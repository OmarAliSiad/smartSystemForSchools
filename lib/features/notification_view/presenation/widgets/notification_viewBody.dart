import 'package:flutter/material.dart';
import 'package:smartsystemforschools/features/notification_view/presenation/widgets/section_notification_card.dart';
import '../../data/models/notification_card_model.dart';

class NotificationViewBody extends StatelessWidget {
  const NotificationViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 21, end: 19),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              SetcionNotificationCard(
                currentDate: 'Today',
                notificationCardModel: NotificationCardModel(
                  time: '5h ago',
                  description:
                      'Ahmed Khalid attempted a purchase,\nbut the balance was in sufficient',
                ),
              ),
              const SizedBox(
                height: 17,
              ),
              SetcionNotificationCard(
                currentDate: 'Yesterday',
                notificationCardModel: NotificationCardModel(
                  time: '7h ago',
                  description:
                      'Ahmed Khalid attempted a purchase,\nbut the balance was in sufficient',
                ),
              ),
              const SizedBox(
                height: 17,
              ),
              SetcionNotificationCard(
                currentDate: 'Last Week',
                notificationCardModel: NotificationCardModel(
                  time: '7h ago',
                  description:
                      'Ahmed Khalid attempted a purchase,\nbut the balance was in sufficient',
                ),
              ),
              SetcionNotificationCard(
                notificationCardModel: NotificationCardModel(
                  time: '7h ago',
                  description:
                      'Ahmed Khalid attempted a purchase,\nbut the balance was in sufficient',
                ),
              ),
              SetcionNotificationCard(
                notificationCardModel: NotificationCardModel(
                  time: '7h ago',
                  description:
                      'Ahmed Khalid attempted a purchase,\nbut the balance was in sufficient',
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ],
      ),
    );
  }
}
