import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import '../../../core/methods/show_scaffold_messanger.dart';
import '../../../core/utils/Constants.dart';
import '../../../core/widgets/build_loading_view.dart';
import 'dart:developer';
import '../manager/spending_limit_cubit.dart/spending_limit_cubit.dart';

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

class _SpendingLimitsViewState extends State<SpendingLimitsView> {
  bool isDailyExpanded = false;
  bool isWeeklyExpanded = false;
  bool isMonthlyExpanded = false;

  final TextEditingController dailyController = TextEditingController();
  final TextEditingController weeklyController = TextEditingController();
  final TextEditingController monthlyController = TextEditingController();
  @override
  void dispose() {
    dailyController.dispose();
    weeklyController.dispose();
    monthlyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spending Limit', style: AppStyles.styleSemiBold20()),
        centerTitle: true,
        elevation: 0,
        forceMaterialTransparency: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      backgroundColor: widget.isDarkMode ? Colors.grey[900] : Colors.white,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocProvider(
                create: (context) => SpendingLimitCubit()
                  ..getSpendingLimit(studentId: widget.studentId),
                child: BlocConsumer<SpendingLimitCubit, SpendingLimitState>(
                  listener: (context, state) {
                    if (state is GetSpendingLimitSuccess) {
                      // Update the text controllers when spending limits are loaded
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
                      dispalySnackBar(context,
                          color: Colors.green,
                          title: 'Spending limits loaded successfully',
                          titleActionButton: 'ok');
                    } else if (state is AddSpendingLimitFailure) {
                      final errorMessage = state.errorMessage;
                      dispalySnackBar(context,
                          color: Colors.red,
                          title: errorMessage,
                          titleActionButton: 'ok');
                      // Show loading indicator
                    }
                  },
                  builder: (context, state) {
                    return (state is SpendingLimitLoading)
                        ? SizedBox(
                            width: double.infinity,
                            height: 650,
                            child: buildLoadingView(
                              'Spending limits',
                              context,
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: widget.isDarkMode
                                  ? Colors.grey[900]
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: widget.isDarkMode ? [] : [],
                            ),
                            child: Padding(
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
                                        'Spending Limits',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: widget.isDarkMode
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                    ],
                                  )
                                      .animate()
                                      .fadeIn(duration: 300.ms, delay: 100.ms),

                                  const SizedBox(height: 8),

                                  // Description
                                  Text(
                                    'Enable daily, weekly, or monthly limits to encourage healthy spending habits',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: widget.isDarkMode
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                    ),
                                  )
                                      .animate()
                                      .fadeIn(duration: 300.ms, delay: 200.ms),

                                  const SizedBox(height: 16),

                                  // Daily Limit Section
                                  _buildLimitSection(
                                    context,
                                    'Daily',
                                    'Resets every midnight',
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
                                    'Weekly',
                                    'Resets every Sunday',
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
                                    'Monthly',
                                    'Resets every month',
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
                                        backgroundColor:
                                            const Color(0xFF1A0F91),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: const Text(
                                        'Save',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                      .animate()
                                      .fadeIn(duration: 400.ms, delay: 600.ms)
                                      .slideY(begin: 0.2, end: 0),
                                ],
                              ),
                            ),
                          );
                  },
                ),
              ),
            ],
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
    return Container(
      decoration: BoxDecoration(
        color: widget.isDarkMode ? Colors.grey[850] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
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
                    color: widget.isDarkMode ? Colors.grey[800] : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(
                      isExpanded ? Icons.close : Icons.add,
                      color: Colors.blue,
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
                    hintText: 'Enter amount',
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

    // Return true to indicate limits were updated successfully
    if (response.statusCode == 200) {
      Navigator.of(context).pop(true);
    } else {
      Navigator.of(context).pop(false);
    }
  }
}
