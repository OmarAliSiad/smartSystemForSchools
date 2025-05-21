import 'package:flutter/material.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import 'package:smartsystemforschools/core/utils/custom_wave_widget.dart';

class AnimatedCustomAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final String? title;
  final TextStyle? textStyle;
  final bool thereIsIcon;
  final Function()? onTapBack;
  final Function()? onTapClose;
  final Function()? onTapSuffix;
  final Color waveColor;
  final Color? backgroundColor;
  final IconButton? leading;

  const AnimatedCustomAppBar({
    super.key,
    this.title,
    this.textStyle,
    this.thereIsIcon = true,
    this.onTapBack,
    this.onTapClose,
    this.onTapSuffix,
    this.waveColor = Colors.blue,
    this.backgroundColor,
    this.leading,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<AnimatedCustomAppBar> createState() => _AnimatedCustomAppBarState();
}

class _AnimatedCustomAppBarState extends State<AnimatedCustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: widget.leading ??
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: widget.onTapBack,
          ),
      flexibleSpace: const CustomWiveWidget(),
      centerTitle: true,
      backgroundColor: widget.backgroundColor ?? Colors.transparent,
      title: Text(
        widget.title ?? '',
        style: AppStyles.styleSemiBold20().copyWith(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
