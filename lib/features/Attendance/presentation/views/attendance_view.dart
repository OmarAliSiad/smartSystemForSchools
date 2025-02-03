import 'package:flutter/material.dart';
import 'package:smartsystemforschools/core/utils/custom_app_bar.dart';
import 'package:smartsystemforschools/features/Attendance/data/models/child_attendce_model.dart';
import 'package:smartsystemforschools/features/main_screen/presentation/views/main_screen.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/assets.dart';
import '../widgets/card_details_attendce.dart';

class AttendanceView extends StatelessWidget {
  static List<ChildAttendceModel> childs = [
    ChildAttendceModel(
        imagePath1: Assets.imagesShahdImage,
        imagePath2: Assets.imagesArrowRightBlue,
        text1: 'Shahd Arrived',
        text2: 'School',
        text3: '8:15 AM'),
    ChildAttendceModel(
        imagePath1: Assets.imagesHodaImage,
        imagePath2: Assets.imagesArrowRightBlue,
        text1: 'Hoda Arrived',
        text2: 'School',
        text3: '8:15 AM'),
    ChildAttendceModel(
        imagePath1: Assets.imagesAhmedImage,
        imagePath2: Assets.imagesArrowRightBlue,
        text1: 'Ahmed Arrived',
        text2: 'School',
        text3: '8:15 AM'),
    ChildAttendceModel(
        imagePath1: Assets.imagesShahdImage,
        imagePath2: Assets.imagesArrowRightRed,
        text1: 'Shadh Arrived',
        text2: 'School',
        text3: '2:00 PM'),
  ];
  static const String id = 'AttendanceView';
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        ThereIsicon: false,
        title: 'Attendance',
        textStyle: AppStyles.styleSemiBold20(),
        onTap: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(MainScreen.id, (context) => false);
        },
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.only(start: 18, end: 22),
        child: Column(
          children: [
            const SizedBox(
              height: 35,
            ),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: childs.length,
                separatorBuilder: (context, index) => const SizedBox(
                  height: 20,
                ),
                itemBuilder: (context, index) => CardDetailsAttendenceWidget(
                  childAttendceModel: childs[index],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
