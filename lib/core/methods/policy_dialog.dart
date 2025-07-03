import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import '../../generated/locale_keys.g.dart';
import '../utils/app_styles.dart';

class PolicyDialog extends StatelessWidget {
  final double raduis;
  final String mdFileName;
  PolicyDialog({super.key, required this.raduis, required this.mdFileName})
      : assert(
            mdFileName.contains('.md'), "the file should contain md extension");

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor:
          context.watch<ThemeModeCubit>().currentTheme == ThemeMode.dark
              ? Colors.black
              : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(raduis),
      ),
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: Future.delayed(const Duration(milliseconds: 150))
                  .then((value) {
                return rootBundle.loadString('assets/policy/$mdFileName');
              }),
              builder: (context, snapShot) {
                if (snapShot.hasData) {
                  return FadeIn(
                    duration: const Duration(milliseconds: 1000),
                    child: Markdown(
                      data: snapShot.data.toString(),
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          BounceInDown(
            child: MaterialButton(
              color: Colors.blue.shade900,
              padding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(raduis),
                  bottomRight: Radius.circular(raduis),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(raduis),
                    bottomRight: Radius.circular(raduis),
                  ),
                ),
                alignment: Alignment.center,
                height: 50,
                width: double.infinity,
                child: Text(
                  LocaleKeys.policy_ok.tr(),
                  style: AppStyles.styleBold20(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
