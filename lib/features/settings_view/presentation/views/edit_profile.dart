import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/core/utils/custom_app_bar.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';
import '../../../../core/methods/show_scaffold_messanger.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/utils/auth_service.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/widgets/custom_bottom_container.dart';
import '../../../login/data/models/user_info_model.dart';
import '../manager/chage_data_profile/change_data_profile_cubit.dart';
import '../../data/models/profile_data_model.dart';
import '../widgets/custom_text_field_edit_profile_widget.dart';
import '../widgets/show_dialog.dart';

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
  UserInfoModel? userInfo;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    UserInfoModel fetchedUserInfo = await AuthService().getUserInfo();
    setState(() {
      userInfo = fetchedUserInfo;
      nameController.text = userInfo?.username ?? '';
      emailController.text = userInfo?.email ?? '';
    });
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
      body: userInfo == null
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
                backgroundColor: Colors.white,
              ),
            ) // Show loading indicator while fetching data
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
                return ListView(
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
                                    final image = state is DataProfileLoaded
                                        ? state.profileDataModel.image
                                        : null;
                                    return image != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image.file(
                                              image,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
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
                            padding: const EdgeInsets.symmetric(horizontal: 26),
                            child: Column(
                              children: [
                                SlideInRight(
                                  child: CustomTextFieldEditProfile(
                                    enable: false,
                                    controller: nameController,
                                    hintText:
                                        LocaleKeys.editProfile_hintName.tr(),
                                    keyboardType: TextInputType.name,
                                    title: LocaleKeys.editProfile_name.tr(),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SlideInLeft(
                                  child: CustomTextFieldEditProfile(
                                    enable: true,
                                    controller: context
                                        .read<ChangeDataProfileCubit>()
                                        .Phone,
                                    vaildatorMessage:
                                        LocaleKeys.editProfile_hintPhone.tr(),
                                    hintText:
                                        LocaleKeys.editProfile_hintPhone.tr(),
                                    keyboardType: TextInputType.phone,
                                    title: LocaleKeys.editProfile_phone.tr(),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SlideInRight(
                                  child: CustomTextFieldEditProfile(
                                    enable: false,
                                    controller: emailController,
                                    hintText:
                                        LocaleKeys.editProfile_hintEmail.tr(),
                                    keyboardType: TextInputType.emailAddress,
                                    title: LocaleKeys.editProfile_email.tr(),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 191),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 23),
                          child: BounceInDown(
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
                                  if (cubit.image == null) {
                                    showDialogProfile(
                                      context: context,
                                      title: 'Error',
                                      subTitle: 'Please select an image.',
                                      buttonCancelTitle: 'Cancel',
                                      buttonOkTitle: 'OK',
                                    );
                                  } else {
                                    await cubit.saveProfileData(
                                      ProfileDataModel(
                                        phone: cubit.Phone.text,
                                        image: cubit.image!,
                                      ),
                                    );
                                    await cubit.loadProfileData();
                                    dispalySnackBar(
                                      context,
                                      color: Colors.green,
                                      title: 'Profile updated successfully.',
                                      titleActionButton: 'Success',
                                    );
                                    Navigator.of(context).pop();
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        BounceInDown(
                          child: const CustomBottomContainer(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
    );
  }
}
