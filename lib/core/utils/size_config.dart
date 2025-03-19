import 'package:flutter/material.dart';

class SizeConfig {
  late double width;
  late double height;

  init(BuildContext context) {
    width = MediaQuery.sizeOf(context).width;
    height = MediaQuery.sizeOf(context).height;
  }
}
