import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smartsystemforschools/features/payment_parent/data/cubit/parent_childs_transcations_cubit.dart';
import '../../../payment/presentation/manager/cubit/payment_cubit.dart';
import '../../../../generated/locale_keys.g.dart';

import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/assets.dart';

class CustomBalanceCardDetails extends StatelessWidget {
  const CustomBalanceCardDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A0F91),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding:
            const EdgeInsetsDirectional.only(start: 15, top: 18, bottom: 18),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      LocaleKeys.balanceCardDetails_balance.tr(),
                      style: AppStyles.styleMedium20()
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      Assets.imagesWallet,
                      fit: BoxFit.cover,
                      width: 24,
                      height: 24,
                    )
                  ],
                ),
                BlocBuilder<PaymentCubit, PaymentState>(
                  builder: (context, state) {
                    if (state is GetBalanceLoading) {
                      return LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white,
                        size: 24,
                      );
                    } else if (state is GetBalanceFailure) {
                      return Text(
                        'failed to load balance',
                        style: AppStyles.styleRegular16().copyWith(
                          color: Colors.red,
                        ),
                      );
                    } else if (state is GetBalanceSuccess) {
                      return Text(
                        '${state.getBalance.result!.amountOfMoney} EGP',
                        style: AppStyles.styleBold24().copyWith(
                          color: Colors.white,
                        ),
                      );
                    } else {
                      context.read<PaymentCubit>().getBalance();
                      return Text(
                        '0 EGP',
                        style: AppStyles.styleBold24().copyWith(
                          color: Colors.white,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            const Spacer(),
            Transform.rotate(
              angle: 3.14,
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 25,
            ),
          ],
        ),
      ),
    );
  }
}
