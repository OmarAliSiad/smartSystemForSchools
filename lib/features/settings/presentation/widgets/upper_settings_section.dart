import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../core/utils/app_styles.dart';
import '../../../../../../core/utils/assets.dart';
import '../../../../../../generated/locale_keys.g.dart';

class UpperSettingsSection extends StatelessWidget {
  const UpperSettingsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      child: FadeInDown(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: 294,
          decoration: const ShapeDecoration(
            color: Color(0xFF0D47A1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              SvgPicture.asset(Assets.imagesSettingsSvg),
              const SizedBox(width: 8),
              Text(
                LocaleKeys.Settings_settings.tr(),
                style: AppStyles.styleMedium18().copyWith(
                    letterSpacing: 0.98, color: Colors.white, fontSize: 28),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
