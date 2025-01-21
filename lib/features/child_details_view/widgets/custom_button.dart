import 'package:flutter/material.dart';
import '../../../core/utils/app_styles.dart';

class CustomButtonChildDetails extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final String imagePath;
  const CustomButtonChildDetails(
      {super.key,
      this.onPressed,
      required this.title,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 15,
        ),
        MaterialButton(
          padding: EdgeInsetsDirectional.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: const Color(0xFF1A0F91),
          minWidth: 117,
          height: 32,
          onPressed: onPressed,
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: 22,
                height: 22,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                title,
                style: AppStyles.styleMedium12().copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
