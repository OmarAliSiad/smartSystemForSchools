import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import '../../../../core/utils/app_styles.dart';

class CustomAllergiesCard extends StatelessWidget {
  final bool isSelected;
  final String text;

  const CustomAllergiesCard({
    super.key,
    required this.text,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        final themeMode = context.read<ThemeModeCubit>().currentTheme;
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: isSelected ? Colors.blue : Colors.transparent,
              width: isSelected ? 2 : 0,
            ),
          ),
          child: Container(
            decoration: ShapeDecoration(
              color: themeMode == ThemeMode.dark ? Colors.black : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              shadows: [
                BoxShadow(
                  color: themeMode == ThemeMode.dark
                      ? const Color(0x3FFFFFFF).withOpacity(.4)
                      : const Color(0x3F000000),
                  blurRadius: 6,
                  offset: const Offset(0, 0),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 26,
                ),
                // Selection indicator
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                    size: 30,
                  ),
                const SizedBox(
                  height: 2,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    end: 18,
                    start: 18,
                    bottom: 26,
                  ),
                  child: FittedBox(
                    child: Text(
                      text,
                      style: AppStyles.styleRegular20().copyWith(
                        color: themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
