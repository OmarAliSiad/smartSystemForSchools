import 'package:flutter/material.dart';
import 'package:smartsystemforschools/core/utils/custom_app_bar.dart';
import 'package:smartsystemforschools/core/utils/custom_button.dart';
import 'package:smartsystemforschools/core/widgets/custom_bottom_container.dart';
import 'package:smartsystemforschools/features/family/presentation/widgets/custom_text_field.dart';
import '../../../../core/functions/showDialog.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/assets.dart';
import '../widgets/upload_image.dart';

class AddChildView extends StatefulWidget {
  static const String id = 'AddChildView';
  const AddChildView({super.key});

  @override
  State<AddChildView> createState() => _AddChildViewState();
}

class _AddChildViewState extends State<AddChildView> {
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController StudentID = TextEditingController();
  TextEditingController Name = TextEditingController();
  TextEditingController SchoolName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        textStyle: AppStyles.styleSemiBold20(),
        ThereIsicon: false,
        title: 'Add child',
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: formState,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 35,
                ),
                const CustomUploadImageWidget(),
                const SizedBox(
                  height: 35,
                ),
                SectionTextFiledForAddChild(
                  keyboardType: TextInputType.number,
                  image: Assets.imagesStudentId,
                  imageColor: Colors.black.withOpacity(.40),
                  controller: StudentID,
                  hintText: 'Student ID',
                  labelText: 'Student ID',
                ),
                const SizedBox(
                  height: 15,
                ),
                SectionTextFiledForAddChild(
                  keyboardType: TextInputType.name,
                  image: Assets.imagesStudentName,
                  imageColor: Colors.black.withOpacity(.40),
                  controller: Name,
                  hintText: 'Your Name',
                  labelText: 'Name',
                ),
                const SizedBox(
                  height: 15,
                ),
                SectionTextFiledForAddChild(
                  keyboardType: TextInputType.name,
                  image: Assets.imagesShcoolName,
                  imageColor: Colors.black.withOpacity(.40),
                  controller: SchoolName,
                  hintText: 'School Name',
                  labelText: 'School Name',
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomButton(
                  padding: const EdgeInsets.only(
                      top: 15, bottom: 18, right: 123, left: 124),
                  text: 'Add',
                  textStyle: AppStyles.styleSemiBold14(),
                  borderRadius: 20,
                  onPressed: () {
                    if (formState.currentState!.validate()) {
                      ShowDialogForAddedAndTransfer(
                        context: context,
                        borderRadius: 20,
                        borderRadiusButton: 5,
                        buttonText: 'Close',
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        buttonTextStyle: AppStyles.styleRegular16(),
                        imagePath: Assets.imagesSuccess,
                        title: 'Added Successfully',
                        titleTextStyle: AppStyles.styleMedium16(),
                        height: 46,
                        width: 46,
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 172,
                ),
                const CustomBottomContainer(color: Colors.black),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
