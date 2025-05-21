import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../child_details_view/views/child_details_view.dart';
import '../../../settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import '../../../../core/models/get_child_details/result.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/custom_button_transfer.dart';

class CustomDetailsChildView extends StatefulWidget {
  final ResultForChildDetails childDetailsModel;
  final int index;
  const CustomDetailsChildView({
    super.key,
    required this.childDetailsModel,
    required this.index,
  });

  @override
  State<CustomDetailsChildView> createState() => _CustomDetailsChildViewState();
}

class _CustomDetailsChildViewState extends State<CustomDetailsChildView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        log(widget.childDetailsModel.id.toString());
        final themeMode = context.read<ThemeModeCubit>().currentTheme;
        return Container(
          decoration: BoxDecoration(
            color: themeMode == ThemeMode.dark ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: themeMode == ThemeMode.dark
                    ? const Color(0xFFFFFFFF).withOpacity(.4)
                    : const Color(0x3F000000),
                blurRadius: 6,
                offset: const Offset(0, 0),
                spreadRadius: 0,
              )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding:
                    EdgeInsetsDirectional.only(start: 15, top: 15, bottom: 10),
                child: SizedBox(),
              ),
              const SizedBox(
                width: 16,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 15, bottom: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.childDetailsModel.fullName!,
                      style: AppStyles.styleRegular16(),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    //price
                    Text(
                      '${widget.childDetailsModel.amountOfMoney.toString()}\$',
                      style: AppStyles.styleSemiBold14()
                          .copyWith(color: const Color(0xff1A0F91)),
                    )
                  ],
                ),
              ),
              const Spacer(),
              CustomButtonTransfer(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return ChildDetailsView(
                        resultForChildDetails: widget.childDetailsModel,
                      );
                    }),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
