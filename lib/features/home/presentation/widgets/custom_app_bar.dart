import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/core/utils/auth_service.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/chage_data_profile/change_data_profile_cubit.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/chage_data_profile/change_data_profile_state.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/assets.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../login/data/models/user_info_model.dart';
import '../../../settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';

class CustomAppBarHomeView extends StatefulWidget
    implements PreferredSizeWidget {
  final void Function() onTapSuffix;
  final void Function()? onTapPrefix;
  final Color backgroundColor;
  final Color waveColor;
  const CustomAppBarHomeView(
      {super.key,
      required this.onTapSuffix,
      this.onTapPrefix,
      required this.waveColor,
      required this.backgroundColor});
  @override
  State<CustomAppBarHomeView> createState() => _CustomAppBarHomeViewState();
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 65);
}

class _CustomAppBarHomeViewState extends State<CustomAppBarHomeView>
    with SingleTickerProviderStateMixin {
  UserInfoModel? userInfo;
  bool _isLoading = true;
  String _errorMessage = '';
  late AnimationController _controller;
  bool _isWaveHeightIncreased = false;
  double _waveHeightMultiplier = 3.0;
  @override
  void initState() {
    super.initState();
    getUserInfo();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapWave() {
    setState(() {
      _isWaveHeightIncreased = true;
      _waveHeightMultiplier = 3.6;
    });

    // Reset wave height after a short delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isWaveHeightIncreased = false;
          _waveHeightMultiplier = 3.0;
        });
      }
    });
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
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        final themeState = context.read<ThemeModeCubit>().currentTheme;
        const defaultTextColor = Colors.white;
        return Container(
          height: widget.preferredSize.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.blue.shade900,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                widget.backgroundColor ?? const Color(0xFF0D47A1),
                widget.backgroundColor.withOpacity(0.9) ?? Colors.blue,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                bottom: MediaQuery.of(context).padding.bottom,
                right: 0,
                left: 0,
                child: GestureDetector(
                  onTap: _onTapWave,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: WavePainter(
                          animation: _controller,
                          waveColor: widget.waveColor,
                          heightMultiplier: _waveHeightMultiplier,
                        ),
                        size: Size.infinite,
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top,
                left: 10,
                right: 10,
                child: Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: widget.onTapPrefix,
                      child: BlocBuilder<ChangeDataProfileCubit,
                          ChangeDataProfileState>(
                        builder: (context, state) {
                          File? image;
                          if (state is ImagePicked) {
                            image = state.image;
                          } else if (state is DataProfileLoaded) {
                            image = state.profileDataModel.image;
                          }
                          return InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: widget.onTapPrefix,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: image != null
                                  ? Image.file(
                                      image,
                                      fit: BoxFit.cover,
                                      width: 32,
                                      height: 32,
                                    )
                                  : Image.asset(
                                      Assets.imagesProfileImage,
                                      fit: BoxFit.cover,
                                      width: 32,
                                      height: 32,
                                    ),
                            ),
                          );
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
                            style: AppStyles.styleSemiBold20()
                                .copyWith(color: defaultTextColor),
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
                              style: AppStyles.styleSemiBold20()
                                  .copyWith(color: defaultTextColor),
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
              ),
            ],
          ),
        );
      },
    );
  }
}

class WavePainter extends CustomPainter {
  final Animation<double> animation;
  final Color waveColor;
  final double heightMultiplier;

  WavePainter({
    required this.animation,
    required this.waveColor,
    this.heightMultiplier = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Create three paths for the three waves
    final path1 = createWavePath(size, 0.0, 0.8);
    final path2 = createWavePath(size, 0.5, 0.5);
    final path3 = createWavePath(size, 1.0, 0.3);

    // Paint for each wave with different opacity
    final paint1 = Paint()
      ..color = waveColor.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = waveColor.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final paint3 = Paint()
      ..color = waveColor.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    // Draw all three waves
    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);
    canvas.drawPath(path3, paint3);
  }

  Path createWavePath(Size size, double phaseShift, double heightFactor) {
    final path = Path();
    final waveHeight = 15.0 * heightMultiplier * heightFactor;
    // Define the number of waves (exactly 3 complete waves)
    const waveCount = 3;
    final waveWidth = size.width / waveCount;
    // Start from top-left
    path.moveTo(0, 0);
    // Draw top line
    path.lineTo(0, size.height * 0.6);
    // Draw waves
    for (int i = 0; i <= waveCount * 2; i++) {
      final dx = i * waveWidth / 2;
      final dy = size.height * 0.6 +
          waveHeight *
              sin((animation.value * 2 * pi) +
                  (i * pi / waveCount) +
                  phaseShift * pi);
      path.lineTo(dx, dy);
    }
    // Complete the path
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
}

// import 'dart:async';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:smartsystemforschools/core/utils/auth_service.dart';
// import 'package:smartsystemforschools/features/settings_view/presentation/manager/chage_data_profile/change_data_profile_cubit.dart';
// import '../../../../core/utils/app_styles.dart';
// import '../../../../core/utils/assets.dart';
// import '../../../../generated/locale_keys.g.dart';
// import '../../../login/data/models/user_info_model.dart';

// class CustomAppBarHomeView extends StatefulWidget
//     implements PreferredSizeWidget {
//   final void Function() onTapSuffix;
//   final void Function()? onTapPrefix;
//   const CustomAppBarHomeView(
//       {super.key, required this.onTapSuffix, this.onTapPrefix});
//   @override
//   State<CustomAppBarHomeView> createState() => _CustomAppBarHomeViewState();
//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }

// class _CustomAppBarHomeViewState extends State<CustomAppBarHomeView> {
//   UserInfoModel? userInfo;
//   bool _isLoading = true;
//   String _errorMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     getUserInfo();
//   }

//   Future<void> getUserInfo() async {
//     try {
//       setState(() {
//         _isLoading = true;
//         _errorMessage = '';
//       });

//       UserInfoModel? fetchedUserInfo = await AuthService().getUserInfo();

//       setState(() {
//         userInfo = fetchedUserInfo;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = e.toString();
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       elevation: 0,
//       scrolledUnderElevation: 0,
//       title: Row(
//         children: [
//           InkWell(
//             borderRadius: BorderRadius.circular(10),
//             onTap: widget.onTapPrefix,
//             child: BlocBuilder<ChangeDataProfileCubit, ChangeDataProfileState>(
//               builder: (context, state) {
//                 final image = context.read<ChangeDataProfileCubit>().image;
//                 if (state is DataProfileLoaded && image != null) {
//                   return ClipRRect(
//                     borderRadius: BorderRadius.circular(100),
//                     child: Image.file(
//                       image,
//                       fit: BoxFit.cover,
//                       width: 32,
//                       height: 32,
//                     ),
//                   );
//                 } else {
//                   return ClipRRect(
//                     borderRadius: BorderRadius.circular(100),
//                     child: Image.asset(
//                       Assets.imagesProfileImage,
//                       fit: BoxFit.cover,
//                       width: 32,
//                       height: 32,
//                     ),
//                   );
//                 }
//               },
//             ),
//           ),
//           const SizedBox(
//             width: 7,
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   LocaleKeys.homeView_appBarTitle.tr(),
//                   style: AppStyles.styleSemiBold20(),
//                 ),
//                 const SizedBox(
//                   height: 2,
//                 ),
//                 if (_isLoading)
//                   const SizedBox(
//                     height: 20,
//                     child: Center(
//                       child: LinearProgressIndicator(
//                         backgroundColor: Colors.transparent,
//                       ),
//                     ),
//                   )
//                 else if (_errorMessage.isNotEmpty)
//                   Text(
//                     'Error loading user info',
//                     style: AppStyles.styleSemiBold20().copyWith(
//                       color: Colors.red,
//                       fontSize: 14,
//                     ),
//                   )
//                 else
//                   Text(
//                     userInfo?.username ?? 'Guest User',
//                     style: AppStyles.styleSemiBold20(),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//               ],
//             ),
//           ),
//           const Spacer(),
//           InkWell(
//             onTap: widget.onTapSuffix,
//             child: Image.asset(
//               Assets.imagesNotifications,
//               fit: BoxFit.cover,
//               width: 24,
//               height: 24,
//             ),
//           ),
//           const SizedBox(
//             width: 10,
//           )
//         ],
//       ),
//     );
//   }
// }
