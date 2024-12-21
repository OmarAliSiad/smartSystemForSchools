import 'package:flutter/material.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import 'package:smartsystemforschools/core/utils/custom_button.dart';
import '../models/card_item_model.dart';
import '../widgets/alertDialog.dart';

Future<dynamic> ShowDialogForRecharge({
  required BuildContext context,
  required String title,
  required String hintText,
  required TextStyle hintTextStyle,
  required TextStyle titleTextStyle,
  required String buttonOkTitle,
  required String buttonCancelTitle,
  required Color buttonOkColor,
  required Color buttonCancelColor,
  CardItemModel? cardItemModel,
}) {
  return showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: titleTextStyle,
            ),
            const SizedBox(
              height: 32,
            ),
            TextField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: hintTextStyle,
                border: outlineInputBorder(),
                enabledBorder: outlineInputBorder(),
                focusedBorder: outlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  textAlign: TextAlign.left,
                  'Recharge starts from 1 EGP',
                  style: AppStyles.styleRegular10().copyWith(
                    color: const Color(0xffFF0000),
                  ),
                )
              ],
            )
          ],
        ),
        actions: <Widget>[
          CustomButtonAlertDailog(
            onPressed: () {
              Navigator.pop(context);
            },
            colorFont: Colors.white,
            containerColor: buttonOkColor,
            title: buttonOkTitle,
          ),
          const SizedBox(
            width: 20,
          ),
          CustomButtonAlertDailog(
            onPressed: () => Navigator.pop(context),
            colorFont: Colors.white,
            containerColor: buttonCancelColor,
            title: buttonCancelTitle,
          ),
        ],
      );
    },
  );
}

Future<dynamic> ShowDialogForDailyLimit({
  required BuildContext context,
  required String title,
  required String hintText,
  required TextStyle hintTextStyle,
  required TextStyle titleTextStyle,
  required String buttonOkTitle,
  required String buttonCancelTitle,
  required Color buttonOkColor,
  required Color buttonCancelColor,
  CardItemModel? cardItemModel,
}) {
  return showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: titleTextStyle,
            ),
            const SizedBox(
              height: 32,
            ),
            TextField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: hintTextStyle,
                border: outlineInputBorder(),
                enabledBorder: outlineInputBorder(),
                focusedBorder: outlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
        actions: <Widget>[
          CustomButtonAlertDailog(
            onPressed: () {
              Navigator.pop(context);
            },
            colorFont: Colors.white,
            containerColor: buttonOkColor,
            title: buttonOkTitle,
          ),
          const SizedBox(
            width: 20,
          ),
          CustomButtonAlertDailog(
            onPressed: () => Navigator.pop(context),
            colorFont: Colors.white,
            containerColor: buttonCancelColor,
            title: buttonCancelTitle,
          ),
        ],
      );
    },
  );
}

Future<dynamic> ShowDialogForAddedAndTransfer({
  required BuildContext context,
  required String imagePath,
  required String title,
  required TextStyle titleTextStyle,
  required double width,
  required double height,
  required String buttonText,
  required TextStyle buttonTextStyle,
  required double borderRadius,
  required double borderRadiusButton,
  void Function()? onPressed,
}) {
  return showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 21,
            ),
            Image.asset(
              imagePath,
              width: width,
              height: height,
            ),
            const SizedBox(
              height: 9,
            ),
            Text(
              title,
              style: titleTextStyle,
            ),
            const SizedBox(
              height: 48,
            ),
            CustomButton(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.5, horizontal: 92.5),
              text: buttonText,
              textStyle: buttonTextStyle,
              borderRadius: borderRadiusButton,
              onPressed: onPressed,
            ),
          ],
        ),
      );
    },
  );
}

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(
      width: 0.50,
      color: Colors.black.withOpacity(.20),
    ),
  );


}
  // ShowDialogForDailyLimit(
  //   hintText = 'Price',
  //   hintTextStyle = AppStyles.styleRegular12(),
  //   buttonCancelTitle = 'Cancel',
  //   buttonOkTitle = 'Edit',
  //   context = context,
  //   titleLarge = 'Daily Limit',
  //   buttonOkColor = const Color(0xff1A0F91),
  //   buttonCancelColor = const Color(0xffFF0000),
  //   titleTextStyle = AppStyles.styleMedium18(),
  // );
  // ShowDialogForRecharge(
  //   hintText = 'Price',
  //   hintTextStyle = AppStyles.styleRegular12(),
  //   buttonCancelTitle = 'Cancel',
  //   buttonOkTitle = 'Recharge',
  //   context = context,
  //   titleLarge = 'Recharge',
  //   buttonOkColor = const Color(0xff1A0F91),
  //   buttonCancelColor = const Color(0xffFF0000),
  //   titleTextStyle = AppStyles.styleMedium18(),
  // );