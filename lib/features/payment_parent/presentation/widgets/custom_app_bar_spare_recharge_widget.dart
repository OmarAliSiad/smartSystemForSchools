import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import 'package:smartsystemforschools/core/utils/custom_wave_widget.dart';

import '../../../../generated/locale_keys.g.dart';

class CustomAppBarSpareAndRechargeWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  const CustomAppBarSpareAndRechargeWidget({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: const CustomWiveWidget(),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Text(
        title,
        style: AppStyles.styleSemiBold20().copyWith(color: Colors.white),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class NoTranscationsFound extends StatelessWidget {
  const NoTranscationsFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            Text(
              LocaleKeys.spare_noTransactionsFound.tr(),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
