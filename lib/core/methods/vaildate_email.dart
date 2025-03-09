import 'package:flutter/material.dart';

String? vaildateEmail(String? value, TextEditingController emailController,
    String vaildateMessage) {
  final bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(emailController.text);
  if (value!.isEmpty) {
    return vaildateMessage;
  } else if (!emailValid) {
    return 'enter vaild email';
  } else {
    return null;
  }
}
