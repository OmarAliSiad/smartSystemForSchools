import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/features/family/data/manager/add_child_cubit/add_child_cubit.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/assets.dart';

class CustomUploadImageWidget extends StatelessWidget {
  final void Function()? onTap;
  const CustomUploadImageWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.grey,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 0.50),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 7,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 33, start: 33),
                child: Text(
                  'Student id',
                  style:
                      AppStyles.styleMedium16().copyWith(color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 47, start: 45),
                child: BlocBuilder<AddChildCubit, AddChildCubitState>(
                  builder: (context, state) {
                    if (state is AddChildCubitInitial) {
                      return Image.asset(
                        Assets.imagesUploadImage,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      );
                    } else if (state is AddChildCubitLAddedSuccess) {
                      return Image.file(
                        context.read<AddChildCubit>().image!,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      );
                    } else {
                      //failure image return the defalut image
                      return Image.asset(
                        Assets.imagesUploadImage,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 5,
              )
            ],
          ),
        ),
      ),
    );
  }
}
