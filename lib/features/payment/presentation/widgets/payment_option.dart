import 'package:flutter/material.dart';

class PaymentOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Widget image;
  final double? width;
  const PaymentOption({
    required this.title,
    this.isSelected = false,
    super.key,
    required this.image,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 2,
          color: isSelected ? const Color(0xFF1A0F91) : const Color(0xFFE0E0E0),
        ),
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: width ?? 16,
            child: image,
          ),
          Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF1A0F91)
                  : Colors.black.withOpacity(0.5),
              fontSize: 13,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
