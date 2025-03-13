import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/app_styles.dart';
import '../../settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';

class buildAllergyChip extends StatefulWidget {
  final String? name;
  const buildAllergyChip({super.key, required this.name});
  @override
  State<buildAllergyChip> createState() => _buildAllergyChipState();
}

class _buildAllergyChipState extends State<buildAllergyChip> {
  bool isdelete = false;
  @override
  Widget build(BuildContext context) {
    final isDark =
        context.read<ThemeModeCubit>().currentTheme == ThemeMode.dark;

    return InkWell(
      splashColor: Colors.grey,
      onLongPress: () {
        isdelete = !isdelete;
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isDark
              ? const Color(0xff1A0F91).withOpacity(0.2)
              : const Color(0xff1A0F91).withOpacity(0.08),
          border: Border.all(
            color: isdelete == true
                ? Colors.red
                : const Color(0xff1A0F91).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.name.toString(),
              style: AppStyles.styleMedium16().copyWith(
                fontSize: 14,
                color: isDark ? Colors.white : const Color(0xff1A0F91),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
