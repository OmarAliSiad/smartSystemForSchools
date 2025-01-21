import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final bool active;
  const DotIndicator({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? Color(0xFF191BA9) : const Color(0xFFEEEEEE),
      ),
    );
  }
}
