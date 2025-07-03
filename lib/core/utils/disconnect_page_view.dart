import 'package:flutter/material.dart';
import '../../generated/locale_keys.g.dart';
import 'app_styles.dart';
import 'package:easy_localization/easy_localization.dart';

class DisconnectedPageView extends StatelessWidget {
  const DisconnectedPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: ValueKey(context.locale.toString()),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off,
                size: 100,
                color: Colors.red,
              ),
              Text(
                LocaleKeys.internetConnection_noInternetConnection.tr(),
                style: AppStyles.styleBold20(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
