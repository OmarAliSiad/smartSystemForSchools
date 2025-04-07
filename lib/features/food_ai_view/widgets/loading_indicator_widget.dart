import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Widget buildLoadingView(String message, BuildContext context, Color color) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoadingAnimationWidget.hexagonDots(
          color: color,
          size: 60,
        ),
        const SizedBox(height: 20),
        Text(
          'Loading $message details...',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}
