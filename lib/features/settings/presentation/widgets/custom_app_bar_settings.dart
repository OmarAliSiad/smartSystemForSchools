import 'package:flutter/material.dart';

class CustomAppBarSettings extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final TextStyle style;
  const CustomAppBarSettings({
    super.key,
    required this.title,
    required this.style,
  });
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      forceMaterialTransparency: true,
      scrolledUnderElevation: 0,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        title,
        style: style,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
