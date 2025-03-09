import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/core/utils/auth_service.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/chage_data_profile/change_data_profile_cubit.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/assets.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../login/data/models/user_info_model.dart';

class CustomAppBarHomeView extends StatefulWidget
    implements PreferredSizeWidget {
  final void Function() onTapSuffix;
  final void Function()? onTapPrefix;
  const CustomAppBarHomeView(
      {super.key, required this.onTapSuffix, this.onTapPrefix});
  @override
  State<CustomAppBarHomeView> createState() => _CustomAppBarHomeViewState();
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarHomeViewState extends State<CustomAppBarHomeView> {
  UserInfoModel? userInfo;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      UserInfoModel? fetchedUserInfo = await AuthService().getUserInfo();

      setState(() {
        userInfo = fetchedUserInfo;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: widget.onTapPrefix,
            child: BlocBuilder<ChangeDataProfileCubit, ChangeDataProfileState>(
              builder: (context, state) {
                final image = context.read<ChangeDataProfileCubit>().image;
                if (state is DataProfileLoaded && image != null) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.file(
                      image,
                      fit: BoxFit.cover,
                      width: 32,
                      height: 32,
                    ),
                  );
                } else {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      Assets.imagesProfileImage,
                      fit: BoxFit.cover,
                      width: 32,
                      height: 32,
                    ),
                  );
                }
              },
            ),
          ),
          const SizedBox(
            width: 7,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.homeView_appBarTitle.tr(),
                  style: AppStyles.styleSemiBold20(),
                ),
                const SizedBox(
                  height: 2,
                ),
                if (_isLoading)
                  const SizedBox(
                    height: 20,
                    child: Center(
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  )
                else if (_errorMessage.isNotEmpty)
                  Text(
                    'Error loading user info',
                    style: AppStyles.styleSemiBold20().copyWith(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  )
                else
                  Text(
                    userInfo?.username ?? 'Guest User',
                    style: AppStyles.styleSemiBold20(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: widget.onTapSuffix,
            child: Image.asset(
              Assets.imagesNotifications,
              fit: BoxFit.cover,
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }
}
