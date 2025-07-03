import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';
import '../../../core/models/get_child_details/result.dart';
import '../../../core/utils/app_styles.dart';
import '../../Allergies/presentation/views/restricted_products_view.dart';
import '../../settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';

class RestrictedProducts extends StatelessWidget {
  final ResultForChildDetails resultForChildDetails;
  const RestrictedProducts({super.key, required this.resultForChildDetails});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        final themeMode = context.read<ThemeModeCubit>().currentTheme;
        return Card(
          color: themeMode == ThemeMode.dark ? Colors.black : Colors.white,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: themeMode == ThemeMode.dark ? Colors.black : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: themeMode == ThemeMode.dark
                      ? const Color(0xFFFFFFFF).withOpacity(.4)
                      : const Color(0xFF000000).withOpacity(.2),
                  blurRadius: 6,
                  offset: const Offset(0, 0),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 15),
              child: Row(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          LocaleKeys.childDetailsView_restrictedProducts.tr(),
                          style: AppStyles.styleMedium16(),
                        ),
                        const SizedBox(height: 10),
                        MaterialButton(
                          height: 32,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return RestrictedProductsView(
                                    studentId: resultForChildDetails.id!,
                                  );
                                },
                              ),
                            );
                          },
                          color: const Color(0xFF1A0F91),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            LocaleKeys.childDetailsView_manageRestrictions.tr(),
                            style: AppStyles.styleMedium13().copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
