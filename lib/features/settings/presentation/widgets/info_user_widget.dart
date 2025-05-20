import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smartsystemforschools/core/utils/assets.dart';
import 'package:smartsystemforschools/features/settings/data/manager/getUserDataCubit/get_user_data_cubit.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/chage_data_profile/change_data_profile_cubit.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/chage_data_profile/change_data_profile_state.dart';
import '../../../../core/utils/app_styles.dart';

class InfoUserRowWidget extends StatefulWidget {
  const InfoUserRowWidget({super.key});

  @override
  State<InfoUserRowWidget> createState() => _InfoUserRowWidgetState();
}

class _InfoUserRowWidgetState extends State<InfoUserRowWidget> {
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    context.read<GetUserDataCubit>().getData();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BlocBuilder<ChangeDataProfileCubit, ChangeDataProfileState>(
          builder: (context, state) {
            if (state is DataProfileLoaded) {
              return Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.file(
                    state.profileDataModel.image!,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            } else {
              return Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    Assets.imagesProfileImage,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }
          },
        ),
        const SizedBox(
          width: 20,
        ),
        BlocBuilder<GetUserDataCubit, GetUserDataState>(
          builder: (context, state) {
            if (state is GetUserDataLoading) {
              return LoadingAnimationWidget.staggeredDotsWave(
                  size: 30, color: Colors.blue);
            }
            if (state is GetUserDataSuccess) {
              return Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.userInfo.username ?? 'Unknown User',
                      style: AppStyles.styleSemiBold20(),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      state.userInfo.email ?? 'No email available',
                      style: AppStyles.styleRegular14(),
                      overflow: state.userInfo.email != null &&
                              state.userInfo.email!.length >= 20
                          ? TextOverflow.ellipsis
                          : null,
                    ),
                  ],
                ),
              );
            } else {
              return const Text('No user data available');
            }
          },
        ),
      ],
    );
  }
}
