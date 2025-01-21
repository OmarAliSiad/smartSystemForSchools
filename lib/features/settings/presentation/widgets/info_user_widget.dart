import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/chage_data_profile/change_data_profile_cubit.dart';

class InfoUserRowWidget extends StatefulWidget {
  const InfoUserRowWidget({super.key});

  @override
  State<InfoUserRowWidget> createState() => _InfoUserRowWidgetState();
}

class _InfoUserRowWidgetState extends State<InfoUserRowWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.supervised_user_circle_outlined,
        ),
        const SizedBox(
          width: 12,
        ),
        BlocBuilder<ChangeDataProfileCubit, ChangeDataProfileState>(
          builder: (context, state) {
            final text = context.read<ChangeDataProfileCubit>().Name.text;
            return Text(
              text.isEmpty ? 'omar' : text,
              style: AppStyles.styleMedium18(),
            );
          },
        )
      ],
    );
  }
}
