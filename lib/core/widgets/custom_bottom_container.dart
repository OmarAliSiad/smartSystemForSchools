import 'package:flutter/material.dart';

class CustomBottomContainer extends StatelessWidget {
  final Color color;
  const CustomBottomContainer({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        width: 134,
        height: 5,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
