import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import 'package:smartsystemforschools/core/utils/custom_app_bar.dart';
import 'package:smartsystemforschools/core/services/notification_service/notification_service.dart';

class ConfirmationRequestScreen extends StatefulWidget {
  static String id = 'confirmation_request';
  final String pendingTransactionId;
  final String studentId;
  final String studentName;
  final String amountOfMoney;
  final List<dynamic> products;

  const ConfirmationRequestScreen({
    super.key,
    required this.pendingTransactionId,
    required this.studentId,
    required this.studentName,
    required this.amountOfMoney,
    required this.products,
  });

  @override
  State<ConfirmationRequestScreen> createState() =>
      _ConfirmationRequestScreenState();
}

class _ConfirmationRequestScreenState extends State<ConfirmationRequestScreen> {
  late Timer _timeoutTimer;
  late StreamSubscription _statusSubscription;
  @override
  initState() {
    super.initState();
    _timeoutTimer = Timer(const Duration(minutes: 60), () {
      Navigator.pop(context, false);
    });
  }

  @override
  void dispose() {
    _timeoutTimer.cancel();
    _statusSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Purchase Confirmation',
        textStyle: AppStyles.styleBold20(),
        ThereIsicon: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildConfirmationHeader(context),
              const SizedBox(height: 24),
              Text(
                'Products to Purchase',
                style: AppStyles.styleBold20(),
              ),
              const SizedBox(height: 16),
              ...widget.products
                  .map((product) => _buildProductCard(context, product)),
              const SizedBox(height: 32),
              _buildTotalAmount(context),
              const SizedBox(height: 32),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmationHeader(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirmation Request',
              style: AppStyles.styleBold20(),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.studentName} is requesting to make a purchase',
              style: AppStyles.styleMedium16(),
            ),
            const SizedBox(height: 4),
            Text(
              'Student ID: ${widget.studentId}',
              style: AppStyles.styleMedium13(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, dynamic product) {
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: AppStyles.styleBold16(),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Quantity: ${product['quantity']}',
                    style: AppStyles.styleMedium13(),
                  ),
                ],
              ),
            ),
            Text(
              '${product['price']} EGP',
              style: AppStyles.styleBold16(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalAmount(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Amount:',
              style: AppStyles.styleBold16(),
            ),
            Text(
              '${widget.amountOfMoney} EGP',
              style: AppStyles.styleBold20().copyWith(
                color: Colors.blue.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _respondToRequest(context, "denied"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              'Deny',
              style: AppStyles.styleBold16().copyWith(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _respondToRequest(context, "approved"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              'Approve',
              style: AppStyles.styleBold16().copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void _respondToRequest(BuildContext context, String status) async {
    try {
      // Update transaction status in shared location
      await NotificationService().updatePendingTransactionStatus(
        pendingTransactionId: widget.pendingTransactionId,
        status: status,
      );

      // Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              status == "approved" ? 'Purchase approved' : 'Purchase denied'),
          backgroundColor: status == "approved" ? Colors.green : Colors.red,
        ),
      );

      // Go back
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
