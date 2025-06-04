import 'package:flutter/material.dart';
import 'package:smartsystemforschools/core/utils/custom_wave_widget.dart';

class CustomAppBarAddChildView extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;
  final TextStyle? textStyle;
  final bool ThereIsicon;
  final Function()? onTap;
  const CustomAppBarAddChildView({
    super.key,
    this.title,
    this.textStyle,
    required this.ThereIsicon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: const CustomWiveWidget(),
      leading: IconButton(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: onTap,
      ),
      title: Row(
        children: [
          Expanded(
            flex: ThereIsicon ? 3 : 4,
            child: const SizedBox(),
          ),
          title == null
              ? Container()
              : Text(
                  title!,
                  style: textStyle!.copyWith(color: Colors.white),
                ),
          Expanded(
            flex: ThereIsicon ? 4 : 6,
            child: const SizedBox(),
          ),
          ThereIsicon
              ? IconButton(
                  onPressed: onTap ?? () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                )
              : const SizedBox(
                  width: 0,
                  height: 0,
                )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}
