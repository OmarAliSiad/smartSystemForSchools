import 'package:flutter/material.dart';
import '../../../../core/utils/app_styles.dart';

class CustomAllergiesCard extends StatelessWidget {
  final bool isSelected;
  final String image;
  final String text;
  const CustomAllergiesCard({
    super.key,
    required this.image,
    required this.text,
    required this.isSelected,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: isSelected ? Colors.blue : Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 6,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 26,
            ),
            Image.asset(
              image,
              width: 45,
              height: 45,
            ),
            const SizedBox(
              height: 2,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 18,
                left: 18,
                bottom: 26,
              ),
              child: Text(
                text,
                style: AppStyles.styleRegular20().copyWith(
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
