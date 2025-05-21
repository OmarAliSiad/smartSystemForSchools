import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:smartsystemforschools/core/utils/animated_app_bar.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import 'package:smartsystemforschools/features/payment_parent/data/models/student_transcations/student_transaction_item.dart';

class TranscationDetails extends StatelessWidget {
  static const String id = '/transactionDetails';
  const TranscationDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Extracting all the data from arguments
    final String transactionId = arguments['transactionId'] ?? '';
    final String studentName = arguments['studentName'] ?? '';
    final double moneyAmountSpended = arguments['moneyAmountSpended'] ?? 0.0;
    final String date = arguments['date'] ?? '';
    final DateTime createdOn = arguments['createdOn'] ?? '';
    final String cashierName = arguments['cashierName'] ?? '';
    final List<StudentTransactionItem> studentTransactionItems =
        arguments['studentTransactionItems'] ?? [];
    final String schoolTenantId = arguments['schoolTenantId'] ?? '';

    return Scaffold(
      appBar: AnimatedCustomAppBar(
        thereIsIcon: false,
        title: 'Transaction Details',
        onTapBack: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              _buildHeaderSection(studentName, date, moneyAmountSpended)
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 200.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: 24),

              // Transaction details
              _buildTransactionDetailsSection(
                      schoolTenantId, createdOn, cashierName)
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 400.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: 24),

              // Items section
              if (studentTransactionItems.isNotEmpty)
                _buildItemsSection(studentTransactionItems)
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 600.ms)
                    .slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(String studentName, String date, double amount) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      studentName,
                      style: AppStyles.styleSemiBold14().copyWith(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: AppStyles.styleRegular14().copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '\$${amount.toStringAsFixed(2)}',
                    style: AppStyles.styleSemiBold14().copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionDetailsSection(
      String schoolTenantId, DateTime createdOn, String cashierName) {
    final dateStr = createdOn != null
        ? DateFormat('yyyy-MM-dd – kk:mm').format(
            DateTime.tryParse(createdOn.toIso8601String())!
                    .add(const Duration(hours: 1)) ??
                DateTime.now(),
          )
        : '';
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Transaction Details",
              style: AppStyles.styleSemiBold14(),
            ),
            const SizedBox(height: 16),
            _buildDetailRow("school Name", schoolTenantId),
            const Divider(height: 24),
            _buildDetailRow("Date & Time", dateStr),
            const Divider(height: 24),
            _buildDetailRow("Staff Member", cashierName),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsSection(List<StudentTransactionItem> items) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Items Purchased",
              style: AppStyles.styleSemiBold14(),
            ),
            const SizedBox(height: 16),
            // Display each item
            for (var item in items) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName.toString(),
                            style: AppStyles.styleMedium15(),
                          ),
                          Text(
                            'quantity: ${item.quantity}',
                            style: AppStyles.styleRegular12().copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${(item.price! * item.quantity!).toStringAsFixed(2)}',
                      style: AppStyles.styleSemiBold14(),
                    ),
                  ],
                ),
              )
                  .animate(
                      delay: Duration(milliseconds: 100 * items.indexOf(item)))
                  .fadeIn(duration: 300.ms)
                  .slideX(begin: 0.2, end: 0),
            ],
            const Divider(),

            // Total
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: AppStyles.styleSemiBold14(),
                  ),
                  Text(
                    '\$${_calculateTotal(items).toStringAsFixed(2)}',
                    style: AppStyles.styleSemiBold14().copyWith(
                      color: Colors.blue.shade900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppStyles.styleRegular14().copyWith(
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: AppStyles.styleMedium15(),
        ),
      ],
    );
  }

  double _calculateTotal(List<StudentTransactionItem> items) {
    double total = 0;
    for (final item in items) {
      final double price = item.price ?? 0.0;
      final int quantity = item.quantity ?? 1;
      total += price * quantity;
    }
    return total;
  }
}
