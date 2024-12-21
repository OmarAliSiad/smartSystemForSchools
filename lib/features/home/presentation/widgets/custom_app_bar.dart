import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/chage_data_profile/change_data_profile_cubit.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/views/settings.view.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/assets.dart';

class CustomAppBarHomeView extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBarHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              Navigator.of(context).pushNamed(SettingsView.id);
            },
            child: BlocBuilder<ChangeDataProfileCubit, ChangeDataProfileState>(
              builder: (context, state) {
                final image = context.read<ChangeDataProfileCubit>().image;
                if (state is DataProfileLoaded) {
                  return Image.file(
                    image!,
                    fit: BoxFit.cover,
                    width: 32,
                    height: 32,
                  );
                } else {
                  return Image.asset(
                    Assets.imagesProfileImage,
                    fit: BoxFit.cover,
                    width: 32,
                    height: 32,
                  );
                }
              },
            ),
          ),
          const SizedBox(
            width: 7,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning,',
                style: AppStyles.styleSemiBold20(),
              ),
              BlocBuilder<ChangeDataProfileCubit, ChangeDataProfileState>(
                builder: (context, state) {
                  final name = context.read<ChangeDataProfileCubit>().Name.text;
                  if (state is DataProfileLoaded) {
                    return Text(
                      name,
                      style: AppStyles.styleSemiBold20(),
                    );
                  } else {
                    return Text(
                      'Kari Colon',
                      style: AppStyles.styleSemiBold20(),
                    );
                  }
                },
              ),
            ],
          ),
          const Spacer(),
          Image.asset(
            Assets.imagesNotifications,
            fit: BoxFit.cover,
            width: 24,
            height: 24,
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
