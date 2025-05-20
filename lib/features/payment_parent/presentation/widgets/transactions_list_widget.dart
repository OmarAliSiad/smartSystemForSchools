import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import 'package:smartsystemforschools/core/widgets/build_loading_view.dart';
import 'package:smartsystemforschools/features/payment_parent/data/cubit/parent_childs_transcations_cubit.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';

class TransactionsListWidget extends StatelessWidget {
  final String? date;

  const TransactionsListWidget({super.key, this.date});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParentChildsTranscationsCubit,
        ParentChildsTranscationsState>(
      builder: (context, state) {
        if (state is PaymentTransactionsLoading) {
          return SliverFillRemaining(
            child: buildLoadingView('transcations', context),
          );
        } else if (state is PaymentTransactionsLoaded) {
          final transactions = state.transactions.result;
          if (transactions == null || transactions.isEmpty) {
            return const SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "No Transactions Found",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ));
          }
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final tx = transactions[index];
                final dateStr = tx.createdOn != null
                    ? DateFormat('yyyy-MM-dd – kk:mm').format(
                        DateTime.tryParse(tx.createdOn!.toIso8601String())!
                                .add(const Duration(hours: 1)) ??
                            DateTime.now(),
                      )
                    : '';
                return Container(
                  margin: const EdgeInsets.only(
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                    color: context.watch<ThemeModeCubit>().currentTheme ==
                            ThemeMode.dark
                        ? Colors.black
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: context.watch<ThemeModeCubit>().currentTheme ==
                                ThemeMode.dark
                            ? const Color(0xFFFFFFFF).withOpacity(.4)
                            : const Color(0x3F000000),
                        blurRadius: 6,
                        offset: const Offset(0, 0),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                        start: 15, top: 15, bottom: 25, end: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Transfer from your wallet to ${tx.studentName.toString()}',
                              style: AppStyles.styleRegular14(),
                            ),
                            const Spacer(),
                            Text(
                              '${tx.moneyAmountSpended.toString()}\$',
                              style: AppStyles.styleSemiBold14()
                                  .copyWith(color: const Color(0xff5CC2F2)),
                            ),
                            const SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          dateStr,
                          style: AppStyles.styleRegular12(),
                        )
                      ],
                    ),
                  ),
                );
              },
              childCount: transactions.length,
            ),
          );
        } else if (state is PaymentTransactionsError) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text('Error: ${state.message}')),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
