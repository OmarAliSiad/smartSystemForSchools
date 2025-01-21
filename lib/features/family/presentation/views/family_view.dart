import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import 'package:smartsystemforschools/core/utils/custom_app_bar.dart';
import 'package:smartsystemforschools/core/utils/custom_button.dart';
import 'package:smartsystemforschools/features/family/data/manager/add_child_cubit/add_child_cubit.dart';
import 'package:smartsystemforschools/features/family/presentation/views/add_child_view.dart';
import '../../../main_screen/presentation/views/main_screen.dart';
import '../widgets/custom_card_family_widget.dart';

class FamilyView extends StatelessWidget {
  static const String id = 'FamilyView';
  const FamilyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onTap: () {
          Navigator.of(context).pushReplacementNamed(MainScreen.id);
        },
        textStyle: AppStyles.styleSemiBold20(),
        title: 'Family',
        ThereIsicon: false,
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.only(start: 18, end: 22),
        child:
            CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 25,
            ),
          ),
          BlocBuilder<AddChildCubit, AddChildCubitState>(
            builder: (context, state) {
              if (state is AddChildCubitInitial) {
                final childDetailsModel =
                    context.read<AddChildCubit>().ListchildDetailsModel;
                return SliverList.builder(
                  itemCount: childDetailsModel.length,
                  itemBuilder: (context, index) {
                    {
                      return Column(
                        children: [
                          CustomCardFaimlyWidget(
                            childDetailsModel: childDetailsModel[index],
                          ),
                          SizedBox(
                            height:
                                index == childDetailsModel.length - 1 ? 30 : 25,
                          ),
                        ],
                      );
                    }
                  },
                );
              } else if (state is AddChildCubitLAddedSuccess) {
                int length =
                    context.read<AddChildCubit>().ListchildDetailsModel.length;
                final childDetailsModel =
                    context.read<AddChildCubit>().ListchildDetailsModel;
                return SliverList.builder(
                  itemCount: length,
                  itemBuilder: (context, index) {
                    {
                      return Column(
                        children: [
                          CustomCardFaimlyWidget(
                            childDetailsModel: childDetailsModel[index],
                          ),
                          SizedBox(
                            height: index == length - 1 ? 30 : 25,
                          ),
                        ],
                      );
                    }
                  },
                );
              } else {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      'error no child added yet',
                      style: AppStyles.styleMedium20(),
                    ),
                  ),
                );
              }
            },
          ),
          SliverToBoxAdapter(
            child: CustomButton(
              padding: const EdgeInsetsDirectional.only(
                top: 15,
                bottom: 18,
                end: 123,
                start: 124,
              ),
              text: 'Add Child',
              textStyle: AppStyles.styleSemiBold14(),
              borderRadius: 20,
              onPressed: () {
                Navigator.of(context).pushNamed(AddChildView.id);
              },
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),
        ]),
      ),
    );
  }
}
