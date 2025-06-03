import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/features/settings/data/manager/getUserDataCubit/get_user_data_cubit.dart';
import '../widgets/lower_settings_important_section.dart';
import '../widgets/upper_settings_section.dart';

class SettingsHomeView extends StatelessWidget {
  static const String id = '/settingsView';
  const SettingsHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetUserDataCubit()..getData(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height +
                    MediaQuery.of(context).size.height * 0.12),
            child: const IntrinsicHeight(
              child: Stack(
                children: [
                  UpperSettingsSection(),
                  LowerSettingsImportantSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
