import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/core/utils/custom_app_bar.dart';

import '../../../../core/methods/show_scaffold_messanger.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/widgets/custom_bottom_container.dart';
import '../manager/chage_data_profile/change_data_profile_cubit.dart';
import '../../data/models/profile_data_model.dart';
import '../widgets/custom_text_field_edit_profile_widget.dart';
import '../widgets/show_dialog.dart';

class EditProfile extends StatefulWidget {
  static String id = 'EditProfile';
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Edit Profile',
        textStyle: AppStyles.styleSemiBold20(),
        ThereIsicon: true,
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Stack(
                children: [
                  InkWell(
                    onTap: () {
                      context.read<ChangeDataProfileCubit>().pickImage();
                    },
                    child: BlocBuilder<ChangeDataProfileCubit,
                        ChangeDataProfileState>(
                      builder: (context, state) {
                        if (state is DataProfileLoaded) {
                          return state.profileDataModel.image != ''
                              ? Image.file(
                                  state.profileDataModel.image!,
                                  width: 100,
                                  height: 100,
                                )
                              : Image.asset(
                                  Assets.imagesProfileImage,
                                  width: 100,
                                  height: 100,
                                );
                        } else {
                          return Image.asset(
                            Assets.imagesProfileImage,
                            width: 100,
                            height: 100,
                          );
                        }
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
                        child: Image.asset(
                          Assets.imagesPen,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 21,
              ),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.only(right: 29, left: 26),
                  child: Column(
                    children: [
                      CustomTextFieldEditProfile(
                        length: 10,
                        controller: context.read<ChangeDataProfileCubit>().Name,
                        hintText: 'Enter Name',
                        keyboardType: TextInputType.name,
                        title: 'Name',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFieldEditProfile(
                        length: 12,
                        controller:
                            context.read<ChangeDataProfileCubit>().Phone,
                        hintText: 'Enter Phone Number',
                        keyboardType: TextInputType.number,
                        title: 'Phone',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFieldEditProfile(
                        controller:
                            context.read<ChangeDataProfileCubit>().Email,
                        hintText: 'Enter Email',
                        keyboardType: TextInputType.emailAddress,
                        title: 'Email',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 191,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 23,
                  right: 22,
                ),
                child: CustomButton(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  text: 'Save',
                  textStyle: AppStyles.styleSemiBold14(),
                  borderRadius: 20,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (context.read<ChangeDataProfileCubit>().image ==
                          null) {
                        showDialogProfile(
                          buttonCancelTitle: 'Cancel',
                          buttonOkTitle: 'Ok',
                          context: context,
                          subTitle: 'Please Select Image',
                          title: 'Error',
                        );
                      } else if (context.read<ChangeDataProfileCubit>().image !=
                              null &&
                          context
                              .read<ChangeDataProfileCubit>()
                              .image!
                              .path
                              .isNotEmpty) {
                        context.read<ChangeDataProfileCubit>().saveProfileData(
                              ProfileDataModel(
                                image: context
                                    .read<ChangeDataProfileCubit>()
                                    .image!,
                                name: context
                                    .read<ChangeDataProfileCubit>()
                                    .Name
                                    .text,
                                phone: context
                                    .read<ChangeDataProfileCubit>()
                                    .Phone
                                    .text,
                                email: context
                                    .read<ChangeDataProfileCubit>()
                                    .Email
                                    .text,
                              ),
                            );
                        context
                            .read<ChangeDataProfileCubit>()
                            .loadProfileData();
                        dispalySnackBar(
                          context,
                          color: Colors.green,
                          title: 'Profile Updated Successfully',
                          titleActionButton: 'Edited',
                        );
                        Navigator.of(context).pop();
                      }
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const CustomBottomContainer(
                color: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
