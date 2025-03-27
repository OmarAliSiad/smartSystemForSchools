import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/core/methods/show_scaffold_messanger.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import 'package:smartsystemforschools/core/utils/assets.dart';
import 'package:smartsystemforschools/core/utils/auth_service.dart';
import 'package:smartsystemforschools/core/utils/custom_app_bar.dart';
import 'package:smartsystemforschools/core/utils/custom_button.dart';
import 'package:smartsystemforschools/core/widgets/custom_bottom_container.dart';
import 'package:smartsystemforschools/features/login/data/models/user_info_model.dart';
import 'package:smartsystemforschools/features/settings/data/manager/models/profile_data_model.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/chage_data_profile/change_data_profile_cubit.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/chage_data_profile/change_data_profile_state.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/widgets/custom_text_field_edit_profile_widget.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';

class EditProfile extends StatefulWidget {
  static const String id = 'EditProfile';
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

  @override
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
    return Scaffold(
      appBar: CustomAppBar(
        title: LocaleKeys.editProfile_editProfile.tr(),
        textStyle: AppStyles.styleSemiBold20(),
        ThereIsicon: true,
        onTap: () {
          Navigator.of(context).pop();
        },
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
                                      child: BlocBuilder<ChangeDataProfileCubit,
                                          ChangeDataProfileState>(
                                        builder: (context, state) {
                                          final image = (state is ImagePicked)
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
                                                    Assets.imagesProfileImage,
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
                                          child: Image.asset(Assets.imagesPen),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 26),
                                  child: Column(
                                    children: [
                                      CustomTextFieldEditProfile(
                                        enable: false,
                                        controller: nameController,
                                        hintText: LocaleKeys
                                            .editProfile_hintName
                                            .tr(),
                                        keyboardType: TextInputType.name,
                                        title: LocaleKeys.editProfile_name.tr(),
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
                                        title:
                                            LocaleKeys.editProfile_phone.tr(),
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
                                        title:
                                            LocaleKeys.editProfile_email.tr(),
                                      )
                                          .animate()
                                          .fadeIn(
                                              duration: 600.ms,
                                              delay: const Duration(
                                                  milliseconds: 150 * 3))
                                          .slideX(begin: .2, end: 0),
                                      const SizedBox(height: 10),
                                      // Add Gender field
                                      CustomTextFieldEditProfile(
                                        enable: true,
                                        controller: genderController,
                                        hintText: "Enter your gender",
                                        vaildatorMessage: "Enter your gender",
                                        keyboardType: TextInputType.text,
                                        title: "Gender",
                                      )
                                          .animate()
                                          .fadeIn(
                                              duration: 600.ms,
                                              delay: const Duration(
                                                  milliseconds: 150 * 4))
                                          .slideX(begin: -0.2, end: 0),
                                      const SizedBox(height: 10),
                                      // Add Address field
                                      CustomTextFieldEditProfile(
                                        enable: true,
                                        controller: addressController,
                                        hintText: "Enter your address",
                                        vaildatorMessage: "Enter your address",
                                        keyboardType:
                                            TextInputType.streetAddress,
                                        title: "Address",
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
                          padding: const EdgeInsets.symmetric(horizontal: 23),
                          child: BounceInUp(
                            child: CustomButton(
                              padding: const EdgeInsetsDirectional.symmetric(
                                  vertical: 15),
                              text: LocaleKeys.editProfile_save.tr(),
                              textStyle: AppStyles.styleSemiBold14(),
                              borderRadius: 20,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final cubit =
                                      context.read<ChangeDataProfileCubit>();

                                  // Create profile data model with all required fields
                                  ProfileDataModel profileData =
                                      ProfileDataModel(
                                    email: emailController.text,
                                    phone: phoneController.text,
                                    gender: genderController.text,
                                    address: addressController.text,
                                    image:
                                        cubit.image, // Preserve existing image
                                  );

                                  // Save the profile data
                                  await cubit.saveProfileData(profileData);
                                  dispalySnackBar(
                                    context,
                                    color: Colors.green,
                                    title: 'Profile updated successfully.',
                                    titleActionButton: 'Success',
                                  );
                                  Navigator.of(context).pop();
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
    );
  }
}
