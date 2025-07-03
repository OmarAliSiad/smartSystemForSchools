import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import 'package:smartsystemforschools/core/utils/custom_wave_widget.dart';
import '../../../core/utils/Constants.dart';
import '../../../core/widgets/build_loading_view.dart';
import 'dart:developer';
import '../../../generated/locale_keys.g.dart';
import '../manager/spending_limit_cubit.dart/spending_limit_cubit.dart';
import 'package:easy_localization/easy_localization.dart';

class SpendingLimitsView extends StatefulWidget {
  final String studentId;
  final bool isDarkMode;

  const SpendingLimitsView({
    super.key,
    required this.studentId,
    this.isDarkMode = false,
  });

  @override
  State<SpendingLimitsView> createState() => _SpendingLimitsViewState();
}

class _SpendingLimitsViewState extends State<SpendingLimitsView>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDailyExpanded = false;
  bool isWeeklyExpanded = false;
  bool isMonthlyExpanded = false;
  late final SpendingLimitCubit _spendingLimitCubit;
  bool _isDisposed = false;

  final TextEditingController dailyController = TextEditingController();
  final TextEditingController weeklyController = TextEditingController();
  final TextEditingController monthlyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _spendingLimitCubit = SpendingLimitCubit();
    _loadSpendingLimits();
  }

  Future<void> _loadSpendingLimits() async {
    if (!mounted) return;
    await _spendingLimitCubit.getSpendingLimit(studentId: widget.studentId);
  }

  @override
  void dispose() {
    _isDisposed = true;
    dailyController.dispose();
    weeklyController.dispose();
    monthlyController.dispose();
    _spendingLimitCubit.close();
    super.dispose();
  }

  void _showMessage(String message, bool isError) {
    if (_isDisposed || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    // Use Future.microtask to avoid animation conflicts
    Future.microtask(() {
      if (!_isDisposed && mounted) {
        messenger.showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(8),
            content: Text(
              message,
              style: AppStyles.styleMedium13().copyWith(color: Colors.white),
            ),
            backgroundColor: isError ? Colors.red : Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return KeyedSubtree(
      key: ValueKey(context.locale.toString()),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          flexibleSpace: const CustomWiveWidget(),
          title: Text(
            LocaleKeys.spendingLimitsView_title.tr(),
            style: AppStyles.styleSemiBold20().copyWith(color: Colors.white),
          ),
          centerTitle: true,
          elevation: 0,
          forceMaterialTransparency: true,
          leading: IconButton(
            color: Colors.white,
            onPressed: () {
              if (!_isDisposed && mounted) {
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: BlocProvider.value(
          value: _spendingLimitCubit,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocConsumer<SpendingLimitCubit, SpendingLimitState>(
                  listener: (context, state) {
                    if (_isDisposed || !mounted) return;

                    if (state is GetSpendingLimitSuccess) {
                      if (!mounted) return;

                      setState(() {
                        if (!_isDisposed) {
                          dailyController.text = state
                                  .getSendingLimit.result?.dailySpendingLimit
                                  ?.toString() ??
                              '';
                          weeklyController.text = state
                                  .getSendingLimit.result?.weeklySpendingLimit
                                  ?.toString() ??
                              '';
                          monthlyController.text = state
                                  .getSendingLimit.result?.monthlySpendingLimit
                                  ?.toString() ??
                              '';
                        }
                      });

                      _showMessage(
                          LocaleKeys.spendingLimitsView_spendingLimitsLoaded
                              .tr(),
                          false);
                    } else if (state is AddSpendingLimitFailure) {
                      _showMessage(state.errorMessage, true);
                    }
                  },
                  builder: (context, state) {
                    if (state is SpendingLimitLoading) {
                      return SizedBox(
                        width: double.infinity,
                        height: height - 200,
                        child: buildLoadingView(
                          LocaleKeys.spendingLimitsView_loadingSpendingLimits
                              .tr(),
                          context,
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title Section
                          Row(
                            children: [
                              const Icon(
                                Icons.account_balance_wallet_outlined,
                                color: Constants.blue,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                LocaleKeys.spendingLimitsView_spendingLimits
                                    .tr(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ).animate().fadeIn(duration: 300.ms, delay: 100.ms),

                          const SizedBox(height: 8),

                          // Description
                          Text(
                            LocaleKeys.spendingLimitsView_description.tr(),
                            style: TextStyle(
                              fontSize: 14,
                              color: widget.isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ).animate().fadeIn(duration: 300.ms, delay: 200.ms),

                          const SizedBox(height: 16),

                          // Daily Limit Section
                          _buildLimitSection(
                            context,
                            LocaleKeys.spendingLimitsView_daily.tr(),
                            LocaleKeys.spendingLimitsView_dailyReset.tr(),
                            isDailyExpanded,
                            dailyController,
                            () {
                              setState(() {
                                isDailyExpanded = !isDailyExpanded;
                              });
                            },
                            300.ms,
                          ),

                          const SizedBox(height: 12),

                          // Weekly Limit Section
                          _buildLimitSection(
                            context,
                            LocaleKeys.spendingLimitsView_weekly.tr(),
                            LocaleKeys.spendingLimitsView_weeklyReset.tr(),
                            isWeeklyExpanded,
                            weeklyController,
                            () {
                              setState(() {
                                isWeeklyExpanded = !isWeeklyExpanded;
                              });
                            },
                            400.ms,
                          ),

                          const SizedBox(height: 12),

                          // Monthly Limit Section
                          _buildLimitSection(
                            context,
                            LocaleKeys.spendingLimitsView_monthly.tr(),
                            LocaleKeys.spendingLimitsView_monthlyReset.tr(),
                            isMonthlyExpanded,
                            monthlyController,
                            () {
                              setState(() {
                                isMonthlyExpanded = !isMonthlyExpanded;
                              });
                            },
                            500.ms,
                          ),

                          const SizedBox(height: 20),

                          // Save Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                _saveSpendingLimits(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A0F91),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                LocaleKeys.spendingLimitsView_save.tr(),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 400.ms, delay: 600.ms)
                              .slideY(begin: 0.2, end: 0),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLimitSection(
    BuildContext context,
    String title,
    String subtitle,
    bool isExpanded,
    TextEditingController controller,
    VoidCallback onToggle,
    Duration animationDelay,
  ) {
    return Card(
      color: widget.isDarkMode ? const Color(0xFF1C1C22) : Colors.white,
      child: Column(
        children: [
          // Header section with title and toggle button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color:
                            widget.isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.isDarkMode
                            ? Colors.grey[400]
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.isDarkMode
                        ? Colors.grey[800]
                        : Colors.blue.shade800,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(
                      isExpanded ? Icons.close : Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: onToggle,
                  ),
                ).animate(target: isExpanded ? 1 : 0).rotate(
                      duration: 300.ms,
                      begin: 0,
                      end: 0.25,
                    ),
              ],
            ),
          ),

          // Expanded section with input field
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: widget.isDarkMode ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: controller,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: LocaleKeys.spendingLimitsView_enterAmount.tr(),
                    hintStyle: TextStyle(
                      color: widget.isDarkMode
                          ? Colors.grey[400]
                          : Colors.grey[500],
                    ),
                    prefixIcon: const Icon(
                      Icons.attach_money,
                      color: Colors.blue,
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  ),
                ),
              ).animate().fadeIn(duration: 200.ms).slideY(begin: -0.1, end: 0),
            ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: animationDelay)
        .slideY(begin: 0.05, end: 0);
  }

  void _saveSpendingLimits(BuildContext context) async {
    final cubit = context.read<SpendingLimitCubit>();
    double? dailyLimit = dailyController.text.trim().isEmpty
        ? null
        : double.tryParse(dailyController.text);

    double? weeklyLimit = weeklyController.text.trim().isEmpty
        ? null
        : double.tryParse(weeklyController.text);

    double? monthlyLimit = monthlyController.text.trim().isEmpty
        ? null
        : double.tryParse(monthlyController.text);

    log('Daily limit: $dailyLimit, Weekly limit: $weeklyLimit, Monthly limit: $monthlyLimit');

    final response = await cubit.addSpendingLimit(
      studentId: widget.studentId,
      dailySpendingLimit: dailyLimit,
      weeklySpendingLimit: weeklyLimit,
      monthlySpendingLimit: monthlyLimit,
    );
    if (response.statusCode == 200) {
      if (context.mounted) {
        Navigator.of(context).pop(true);
      }
    } else {
      if (context.mounted) {
        Navigator.of(context).pop(false);
      }
    }
  }
}
