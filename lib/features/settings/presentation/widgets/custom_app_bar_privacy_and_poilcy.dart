import 'package:flutter/material.dart';

class CustomAppBarTermsAndConditionAndPrivacy extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final TextStyle? textStyle;
  final void Function()? onTap;
  const CustomAppBarTermsAndConditionAndPrivacy(
      {super.key, required this.title, this.textStyle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: textStyle,
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
        ),
        onPressed: onTap,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}
