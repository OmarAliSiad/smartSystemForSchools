import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smartsystemforschools/core/utils/animated_app_bar.dart';
import 'package:smartsystemforschools/features/settings/data/manager/getUserDataCubit/get_user_data_cubit.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/views/map_picker_screen.dart';
import '../../../../core/methods/show_scaffold_messanger.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/services/auth_service/auth_service.dart';
import '../../../../core/utils/custom_app_bar.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/widgets/custom_bottom_container.dart';
import '../../../login/data/models/user_info_model.dart';
import '../../../settings/data/manager/models/profile_data_model.dart';
import '../manager/chage_data_profile/change_data_profile_cubit.dart';
import '../manager/chage_data_profile/change_data_profile_state.dart';
import '../manager/themeMode/theme_mode_cubit.dart';
import '../widgets/custom_text_field_edit_profile_widget.dart';
import '../../../../generated/locale_keys.g.dart';

class EditProfile extends StatefulWidget {
  static const String id = '/EditProfile';
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  UserInfoModel? userInfo;
  bool isLoading = true;
  final String googleMapsApiKey = 'AIzaSyCm2VBimx6vdb_j8IqTcIBn3aPI9aCJmMk';

  @override
  void initState() {
    super.initState();
    getUserInfo();

    // Load saved profile data from SharedPreferences
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChangeDataProfileCubit>().loadProfileData().then((_) {
        final cubit = context.read<ChangeDataProfileCubit>();
        // Update local controllers with cubit data
        phoneController.text = cubit.Phone.text;
        genderController.text = cubit.Gender.text;
        addressController.text = cubit.Address.text;
        emailController = TextEditingController(text: userInfo?.email ?? '');
      });
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    genderController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> getUserInfo() async {
    setState(() {
      isLoading = true;
    });
    try {
      UserInfoModel fetchedUserInfo = await AuthService().getUserInfo();
      setState(() {
        userInfo = fetchedUserInfo;
        nameController.text = userInfo?.username ?? '';
        emailController.text = userInfo?.email ?? '';
        // If no saved data from SharedPreferences, load from API
        phoneController.text = userInfo?.phone ?? '';
        genderController.text = userInfo?.gender ?? '';
        addressController.text = userInfo?.address ?? '';
      });
    } catch (e) {
      print("Error loading user data: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetUserDataCubit(),
      child: KeyedSubtree(
        key: ValueKey(context.locale.toString()),
        child: Scaffold(
          appBar: AnimatedCustomAppBar(
            title: LocaleKeys.editProfile_editProfile.tr(),
            textStyle: AppStyles.styleSemiBold20(),
            thereIsIcon: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                    backgroundColor: Colors.white,
                  ),
                )
              : BlocConsumer<ChangeDataProfileCubit, ChangeDataProfileState>(
                  listener: (context, state) {
                    if (state is ChangeDataProfileError) {
                      dispalySnackBar(
                        context,
                        color: Colors.red,
                        title: state.message,
                        titleActionButton: 'Error',
                      );
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      children: [
                        Expanded(
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            children: [
                              Column(
                                children: [
                                  const SizedBox(height: 30),
                                  BounceInDown(
                                    child: Stack(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            context
                                                .read<ChangeDataProfileCubit>()
                                                .pickImage();
                                          },
                                          child: BlocBuilder<
                                              ChangeDataProfileCubit,
                                              ChangeDataProfileState>(
                                            builder: (context, state) {
                                              final image = (state
                                                      is ImagePicked)
                                                  ? state.image
                                                  : (context
                                                      .read<
                                                          ChangeDataProfileCubit>()
                                                      .image);

                                              return image != null
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: Image.file(
                                                        image,
                                                        width: 100,
                                                        height: 100,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: Image.asset(
                                                        Assets
                                                            .imagesProfileImage,
                                                        width: 100,
                                                        height: 100,
                                                      ),
                                                    );
                                            },
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            width: 27,
                                            height: 27,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xff1A0F91),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(6),
                                              child:
                                                  Image.asset(Assets.imagesPen),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 21),
                                  Form(
                                    key: _formKey,
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.symmetric(
                                        horizontal: 26,
                                      ),
                                      child: Column(
                                        children: [
                                          CustomTextFieldEditProfile(
                                            enable: false,
                                            controller: nameController,
                                            hintText: LocaleKeys
                                                .editProfile_hintName
                                                .tr(),
                                            keyboardType: TextInputType.name,
                                            title: LocaleKeys.editProfile_name
                                                .tr(),
                                          )
                                              .animate()
                                              .fadeIn(
                                                  duration: 600.ms,
                                                  delay: const Duration(
                                                      milliseconds: 150 * 1))
                                              .slideX(begin: .2, end: 0),
                                          const SizedBox(height: 10),
                                          CustomTextFieldEditProfile(
                                            enable: true,
                                            controller: phoneController,
                                            vaildatorMessage: LocaleKeys
                                                .editProfile_hintPhone
                                                .tr(),
                                            hintText: LocaleKeys
                                                .editProfile_hintPhone
                                                .tr(),
                                            keyboardType: TextInputType.phone,
                                            title: LocaleKeys.editProfile_phone
                                                .tr(),
                                          )
                                              .animate()
                                              .fadeIn(
                                                  duration: 600.ms,
                                                  delay: const Duration(
                                                      milliseconds: 150 * 2))
                                              .slideX(begin: -0.2, end: 0),
                                          const SizedBox(height: 10),
                                          CustomTextFieldEditProfile(
                                            enable: true,
                                            controller: emailController,
                                            hintText: LocaleKeys
                                                .editProfile_hintEmail
                                                .tr(),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            title: LocaleKeys.editProfile_email
                                                .tr(),
                                          )
                                              .animate()
                                              .fadeIn(
                                                  duration: 600.ms,
                                                  delay: const Duration(
                                                      milliseconds: 150 * 3))
                                              .slideX(begin: .2, end: 0),
                                          const SizedBox(height: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Address',
                                                style:
                                                    AppStyles.styleMedium16(),
                                              ),
                                              const SizedBox(height: 10),
                                              DropdownButtonFormField(
                                                dropdownColor: context
                                                            .watch<
                                                                ThemeModeCubit>()
                                                            .currentTheme ==
                                                        ThemeMode.dark
                                                    ? Colors.black
                                                    : Colors.white,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: context
                                                              .watch<
                                                                  ThemeModeCubit>()
                                                              .currentTheme ==
                                                          ThemeMode.dark
                                                      ? Colors.transparent
                                                      : Colors.white,
                                                  enabledBorder:
                                                      buildOutlineBorder(),
                                                  focusedBorder:
                                                      buildOutlineBorder(),
                                                  border: buildOutlineBorder(),
                                                ),
                                                value: genderController.text ==
                                                        'male'
                                                    ? 'male'
                                                    : 'female',
                                                isExpanded: true,
                                                onChanged: (value) {
                                                  genderController.text =
                                                      value!;
                                                },
                                                items: ['male', 'female'].map(
                                                  (value) {
                                                    return DropdownMenuItem(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  },
                                                ).toList(),
                                              )
                                            ],
                                          )
                                              .animate()
                                              .fadeIn(
                                                  duration: 600.ms,
                                                  delay: const Duration(
                                                      milliseconds: 150 * 4))
                                              .slideX(begin: -0.2, end: 0),
                                          const SizedBox(height: 10),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child:
                                                    CustomTextFieldEditProfile(
                                                  enable: true,
                                                  controller: addressController,
                                                  hintText: 'select address',
                                                  keyboardType: TextInputType
                                                      .streetAddress,
                                                  title: 'Address',
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              IconButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          MapPickerScreen(
                                                        onLocationSelected:
                                                            (location) {
                                                          addressController
                                                              .text = location;
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                                icon: Container(
                                                  margin:
                                                      const EdgeInsetsDirectional
                                                          .only(bottom: 10),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue[900],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: const Icon(
                                                    Icons.location_on,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                              .animate()
                                              .fadeIn(
                                                  duration: 600.ms,
                                                  delay: const Duration(
                                                      milliseconds: 150 * 5))
                                              .slideX(begin: .2, end: 0),
                                          const SizedBox(height: 30),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Place the button and CustomBottomContainer at the bottom
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 23),
                              child: BounceInUp(
                                child: CustomButton(
                                  padding:
                                      const EdgeInsetsDirectional.symmetric(
                                          vertical: 15),
                                  text: LocaleKeys.editProfile_save.tr(),
                                  textStyle: AppStyles.styleSemiBold14(),
                                  borderRadius: 20,
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      final cubit = context
                                          .read<ChangeDataProfileCubit>();
                                      // Create profile data model with all required fields
                                      ProfileDataModel profileData =
                                          ProfileDataModel(
                                        username: nameController.text,
                                        email: emailController.text,
                                        phone: phoneController.text,
                                        gender: genderController.text,
                                        address: addressController.text,
                                        image: cubit
                                            .image, // Preserve existing image
                                      );

                                      // Save the profile data
                                      await cubit.saveProfileData(profileData);

                                      // Show success message
                                      dispalySnackBar(
                                        context,
                                        color: Colors.green,
                                        title: 'Profile updated successfully.',
                                        titleActionButton: 'Success',
                                      );

                                      // Pop back to previous screen with result = true to indicate data was updated
                                      Navigator.of(context).pop(true);
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            BounceInUp(
                              child: const CustomBottomContainer(
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }
}
