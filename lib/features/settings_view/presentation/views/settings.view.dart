// import 'dart:developer';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:smartsystemforschools/features/settings_view/presentation/views/edit_profile.dart';
// import 'package:smartsystemforschools/features/settings_view/presentation/views/privacy_view.dart';
// import 'package:smartsystemforschools/features/splash_feature/presenation/views/splash_view.dart';
// import '../../../../core/utils/app_styles.dart';
// import '../../../../core/utils/assets.dart';
// import '../manager/chage_data_profile/change_data_profile_cubit.dart';
// import '../manager/themeMode/theme_mode_cubit.dart';
// import '../widgets/custom_container_settings_widget.dart';

// class SettingsView extends StatefulWidget {
//   static String id = "settings";
//   const SettingsView({super.key});

//   @override
//   State<SettingsView> createState() => _SettingsViewState();
// }

// class _SettingsViewState extends State<SettingsView> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         scrolledUnderElevation: 0,
//         leading: InkWell(
//             borderRadius: BorderRadius.circular(30),
//             onTap: () {
//               Navigator.of(context).pop();
//             },
//             child: const Icon(Icons.arrow_back_ios)),
//       ),
//       body: SizedBox(
//         width: MediaQuery.sizeOf(context).width,
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 43,
//             ),
//             InkWell(
//               onTap: () {
//                 Navigator.of(context).pushNamed(EditProfile.id);
//               },
//               child: Stack(
//                 children: [
//                   BlocBuilder<ChangeDataProfileCubit, ChangeDataProfileState>(
//                     builder: (context, state) {
//                       if (state is DataProfileLoaded) {
//                         log(state.profileDataModel.image.toString());
//                         return Image.file(
//                           state.profileDataModel.image!,
//                           width: 100,
//                           height: 100,
//                         );
//                       } else {
//                         return Image.asset(
//                           Assets.imagesProfileImage,
//                           width: 100,
//                           height: 100,
//                         );
//                       }
//                     },
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: Container(
//                       width: 27,
//                       height: 27,
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Color(0xff1A0F91),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsetsDirectional.all(6),
//                         child: Image.asset(
//                           Assets.imagesPen,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 12,
//                   ),
//                 ],
//               ),
//             ),
//             BlocBuilder<ChangeDataProfileCubit, ChangeDataProfileState>(
//               builder: (context, state) {
//                 if (state is DataProfileLoaded) {
//                   return BlocBuilder<ThemeModeCubit, ThemeModeState>(
//                     builder: (context, state) {
//                       return Text(
//                         context.read<ChangeDataProfileCubit>().Name.text,
//                         style: AppStyles.styleMedium18(),
//                       );
//                     },
//                   );
//                 } else {
//                   return BlocBuilder<ThemeModeCubit, ThemeModeState>(
//                     builder: (context, state) {
//                       return Text('Martin Shah',
//                           style: AppStyles.styleMedium18());
//                     },
//                   );
//                 }
//               },
//             ),
//             const SizedBox(
//               height: 42,
//             ),
//             Padding(
//               padding: const EdgeInsetsDirectional.symmetric(horizontal: 34),
//               child: Column(
//                 children: [
//                   CustomContainerSettingsView(
//                     onTap: () {
//                       Navigator.of(context).pushNamed(PrivacyView.id);
//                     },
//                     iconImage: Assets.imagesPrivacy,
//                     title: 'Privacy',
//                   ),
//                   const SizedBox(
//                     height: 16,
//                   ),
//                   CustomContainerSettingsView(
//                     onTap: () {
//                       showAboutDialog(
//                         applicationIcon: Image.asset(
//                           Assets.imagesLogoColorblue,
//                           width: 100,
//                           height: 100,
//                           color: const Color(0xff191BA9),
//                         ),
//                         context: context,
//                         applicationName: 'Canteen App',
//                         applicationVersion: '1.0.0+1',
//                         applicationLegalese:
//                             'Copyright © 2023 Canteen App. All rights reserved.',
//                       );
//                     },
//                     iconImage: Assets.imagesHelp,
//                     title: 'About',
//                   ),
//                   const SizedBox(
//                     height: 16,
//                   ),
//                   CustomContainerSettingsView(
//                     onTap: () {
//                       Navigator.of(context).pushNamed(EditProfile.id);
//                     },
//                     iconImage: Assets.imagesSettings,
//                     title: 'Settings',
//                   ),
//                   const SizedBox(
//                     height: 16,
//                   ),
//                   CustomContainerSettingsView(
//                       onTap: () {
//                         if (context.locale == const Locale('en')) {
//                           context.setLocale(const Locale('ar'));
//                         } else {
//                           context.setLocale(const Locale('en'));
//                         }
//                       },
//                       icon: Icons.language,
//                       title: 'Localaziton'),
//                   const SizedBox(
//                     height: 16,
//                   ),
//                   CustomContainerSettingsView(
//                     onTap: () {
//                       context.read<ThemeModeCubit>().changeThemeMode();
//                     },
//                     icon: Icons.dark_mode,
//                     title: 'Dark Mode',
//                   ),
//                   const SizedBox(
//                     height: 16,
//                   ),
//                   CustomContainerSettingsView(
//                     onTap: () {
//                       Navigator.of(context).pushNamedAndRemoveUntil(
//                           SplashView.id, (context) => false);
//                     },
//                     iconImage: Assets.imagesLogout,
//                     title: 'Logout',
//                     colorIcon: Colors.red,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 16,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
