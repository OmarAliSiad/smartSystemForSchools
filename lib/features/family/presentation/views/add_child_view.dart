import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/features/family/presentation/widgets/custom_app_bar_add_child_view.dart';
import '../../../../core/methods/show_scaffold_messanger.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../../../main_screen/presentation/views/main_screen.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../core/utils/assets.dart';
import '../../data/manager/add_child_cubit/add_child_cubit.dart';

class AddChildView extends StatefulWidget {
  static const String id = '/AddChildView';
  const AddChildView({super.key});

  @override
  State<AddChildView> createState() => _AddChildViewState();
}

class _AddChildViewState extends State<AddChildView> {
  final GlobalKey<FormState> formState = GlobalKey();
  final TextEditingController studentID = TextEditingController();
  bool _isNavigating = false;

  @override
  void dispose() {
    studentID.dispose();
    super.dispose();
  }

  void _handleSuccessfulAddition(BuildContext context) {
    if (_isNavigating) return;
    _isNavigating = true;

    // Show success message
    dispalySnackBar(
      context,
      title: LocaleKeys.addedChild_addedSuccessfully.tr(),
      titleActionButton: LocaleKeys.policy_ok.tr(),
      color: Colors.green,
    );

    // Refresh child data in the cubit
    context.read<AddChildCubit>().refreshChildData();

    // Navigate back to MainScreen
    Navigator.of(context).pushNamedAndRemoveUntil(
      MainScreen.id,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: ValueKey(context.locale.toString()),
      child: WillPopScope(
        onWillPop: () async {
          if (_isNavigating) return false;
          return true;
        },
        child: Scaffold(
          appBar: CustomAppBarAddChildView(
            textStyle: AppStyles.styleSemiBold20(),
            ThereIsicon: false,
            title: LocaleKeys.family_AddChild.tr(),
            onTap: () {
              if (!_isNavigating) {
                Navigator.of(context).pop();
              }
            },
          ),
          body: BlocConsumer<AddChildCubit, AddChildCubitState>(
            listener: (context, state) {
              if (state is AddChildCubitLAddedSuccess) {
                _handleSuccessfulAddition(context);
              } else if (state is AddChildCubitAddedFailure) {
                dispalySnackBar(
                  context,
                  title: state.errorMessage,
                  titleActionButton: LocaleKeys.policy_ok.tr(),
                  color: Colors.red,
                );
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 18),
                child: AbsorbPointer(
                  absorbing: state is AddChildCubitLoading || _isNavigating,
                  child: Form(
                    key: formState,
                    child: SingleChildScrollView(
                      clipBehavior: Clip.none,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 35),
                          SectionTextFiledForAddChild(
                            keyboardType: TextInputType.emailAddress,
                            image: Assets.imagesStudentId,
                            imageColor: Colors.black.withOpacity(.40),
                            controller: studentID,
                            validator: (p0) {
                              if (p0!.isEmpty) {
                                return LocaleKeys.addedChild_studentID.tr();
                              }
                              return null;
                            },
                            hintText: LocaleKeys.addedChild_studentID.tr(),
                            labelText: LocaleKeys.addedChild_studentID.tr(),
                          ),
                          const SizedBox(height: 40),
                          CustomButton(
                            isLoading: state is AddChildCubitLoading,
                            padding: const EdgeInsetsDirectional.only(
                              top: 15,
                              bottom: 18,
                              end: 123,
                              start: 124,
                            ),
                            text: LocaleKeys.addedChild_buttonText.tr(),
                            textStyle: AppStyles.styleSemiBold14(),
                            borderRadius: 20,
                            onPressed: () async {
                              if (!_isNavigating &&
                                  formState.currentState!.validate()) {
                                await context.read<AddChildCubit>().addedChild(
                                      id: studentID.text.trim(),
                                    );
                              }
                            },
                          ),
                          const SizedBox(height: 30),
                          Image.asset(Assets.imagesRafiki),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
