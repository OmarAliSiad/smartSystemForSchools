import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Allergies/data/manager/allegris_catogries/allegris_cubit.dart';
import '../../../core/models/get_child_details/result.dart';
import '../../../core/utils/app_styles.dart';
import '../../settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';

class BuildAllergyChip extends StatefulWidget {
  final String? name;
  final int? categoryId;
  final ResultForChildDetails childDetails;
  final Function(int)? onDelete;

  const BuildAllergyChip({
    super.key,
    required this.name,
    this.categoryId,
    this.onDelete,
    required this.childDetails,
  });

  @override
  State<BuildAllergyChip> createState() => _BuildAllergyChipState();
}

class _BuildAllergyChipState extends State<BuildAllergyChip>
    with SingleTickerProviderStateMixin {
  bool isdelete = false;
  late AnimationController _dragController;

  @override
  void initState() {
    super.initState();
    _dragController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _dragController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        context.read<ThemeModeCubit>().currentTheme == ThemeMode.dark;

    return InkWell(
      splashColor: Colors.grey,
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
