 import 'package:flutter/material.dart';

String? vaildatePassword(String? value, TextEditingController passwordController) {
     final bool vaildPassword = RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(passwordController.text);
    if (value!.isEmpty) {
      return 'enter password';
    } else if (!vaildPassword) {
      return 'should be at least 8 characters ex (P@ssw0rd)';
    } else {
      return null;
    }
  }
