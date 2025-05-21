import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/core/utils/custom_wave_widget.dart';
import 'package:smartsystemforschools/features/payment_parent/data/cubit/parent_transcations_cubit.dart';
import 'package:smartsystemforschools/features/payment_parent/presentation/widgets/custom_app_bar_spare_recharge_widget.dart';
import '../../../../core/utils/Constants.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/widgets/build_loading_view.dart';
import 'payment_bottom_sheet.dart';
import '../../../settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';

class AccountScreen extends StatefulWidget {
  final String username;
  final double balance;
  const AccountScreen(
      {super.key, required this.username, required this.balance});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  DateTime selectedDate = DateTime.now();
  String? formattedDate = '';
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade900,
              onPrimary: Colors.white,
              onSurface: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        formattedDate = DateFormat('yyyy/MM/dd').format(selectedDate);
      });
      loadTranscations(date: formattedDate);
    }
  }

  void loadTranscations({String? studentId, String? date}) {
    context
        .read<ParentTranscationsCubit>()
        .fetchParentTransactions(date: date, studentId: studentId);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarSpareAndRechargeWidget(
        title: 'Account',
      ),
      body: RefreshIndicator(
        color: Colors.black,
        backgroundColor: Colors.white,
        onRefresh: () async {
          context.read<ParentTranscationsCubit>().fetchParentTransactions();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Family Balance", style: AppStyles.styleBold20()),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.balance.toString(),
                                style: AppStyles.styleBold24()
                                    .copyWith(fontSize: 32)),
                            Text(widget.username,
                                style: AppStyles.styleMedium16()),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => Builder(builder: (context) {
                                return const PaymentMethodBottomSheet();
                              }),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Constants.blue, //Color(0xFF00BCD4),,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text("Recharge",
                              style: AppStyles.styleMedium16()
                                  .copyWith(color: Colors.white)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Transactions",
                          style: AppStyles.styleBold20(),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _selectDate(context);
                          },
                          style: ButtonStyle(
                            padding: const WidgetStatePropertyAll(
                              EdgeInsetsDirectional.symmetric(
                                horizontal: 15,
                                vertical: 0,
                              ),
                            ),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            backgroundColor:
                                const WidgetStatePropertyAll(Constants.blue),
                          ),
                          child: Text(
                            "Select Date",
                            style: AppStyles.styleRegular14().copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver:
                  BlocBuilder<ParentTranscationsCubit, ParentTranscationsState>(
                builder: (context, state) {
                  if (state is ParentTransactionsLoading) {
                    return SliverFillRemaining(
                      child: buildLoadingView('transactions', context),
                    );
                  } else if (state is ParentTransactionsLoaded) {
                    if (state.parentTranscations.result?.isEmpty ?? true) {
                      return const NoTranscationsFound();
                    }
                    final isDark =
                        context.watch<ThemeModeCubit>().currentTheme ==
                            ThemeMode.dark;
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          String dateStr = state.parentTranscations
                                      .result![index].createdAt !=
                                  null
                              ? DateFormat('yyyy-MM-dd - kk:mm').format(
                                  DateTime.tryParse(state.parentTranscations
                                          .result![index].createdAt!
                                          .toIso8601String())!
                                      .add(const Duration(hours: 1)))
                              : '';
                          return Container(
                            margin: const EdgeInsets.only(
                              bottom: 16,
                            ),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.black : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? const Color(0xFFFFFFFF).withOpacity(.4)
                                      : const Color(0x3F000000),
                                  blurRadius: 6,
                                  offset: const Offset(0, 0),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        state.parentTranscations.result![index]
                                            .studentName
                                            .toString(),
                                        style: AppStyles.styleRegular14(),
                                      ),
                                      Text(
                                        '${state.parentTranscations.result![index].amountOfMoney.toString()}\$',
                                        style: AppStyles.styleSemiBold14()
                                            .copyWith(
                                          color: const Color(0xff5CC2F2),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    dateStr.toString(),
                                    style: AppStyles.styleRegular12(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: state.parentTranscations.result!.length,
                      ),
                    );
                  } else {
                    return const NoTranscationsFound();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
