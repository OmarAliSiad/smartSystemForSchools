import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

void showAswemoDialog(
    {required DialogType dialogType,
    required BuildContext context,
    required String title,
    required String desc}) {
  AwesomeDialog(
    dialogBackgroundColor: Theme.of(context).colorScheme.surface,
    context: context,
    dialogType: dialogType,
    animType: AnimType.rightSlide,
    title: title,
    descTextStyle: const TextStyle(fontSize: 16),
    desc: desc,
    btnCancelOnPress: () {},
    btnOkOnPress: () {},
  ).show();
}
