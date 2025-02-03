import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final TextStyle? textStyle;
  final bool ThereIsicon;
  final Function()? onTap;
  const CustomAppBar({
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
      leading: BlocBuilder<ThemeModeCubit, ThemeModeState>(
        builder: (context, state) {
          final state = context.read<ThemeModeCubit>().currentTheme;
          return IconButton(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            icon: Icon(
              Icons.arrow_back_ios,
              color: state == ThemeMode.dark ? Colors.white : Colors.black,
            ),
            onPressed: onTap,
          );
        },
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
                  style: textStyle,
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
