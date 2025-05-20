import 'package:flutter/material.dart';
import '../../../core/models/get_child_details/result.dart';
import 'CustomSpendingDailyLimitWidget.dart';
import 'custom_balance_widget.dart';
import '../../../core/utils/app_styles.dart';

class CardDetailsChildWidget extends StatelessWidget {
  const CardDetailsChildWidget({
    super.key,
    required this.receviedData,
    required this.dailylimit,
    required this.balance,
  });

  final ResultForChildDetails receviedData;
  final double dailylimit;
  final double balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff1A0F91),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsetsDirectional.only(
          //       top: 15.0, start: 15, end: 15, bottom: 35.0),
          //   child: Image.asset(
          //     receviedData.imagePath,
          //     height: 52,
          //     width: 52,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 15, start: 20),
                child: Text(
                  receviedData.fullName ?? 'Unknown Child',
                  style:
                      AppStyles.styleMedium20().copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 19),
                    child: CustomBalanceWidget(
                      price: balance, //,
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 25),
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Container(
                        width: 40.1,
                        height: 1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  CustomSpendingDailyLimitWidget(
                    dailyLimit: dailylimit,
                  ),
                ],
              ),
              const SizedBox(
                height: 14,
              )
            ],
          ),
        ],
      ),
    );
  }
}
