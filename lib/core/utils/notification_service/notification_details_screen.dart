import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import 'package:smartsystemforschools/core/utils/custom_app_bar.dart';
import 'package:smartsystemforschools/core/utils/notification_service/notification_model.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import 'package:smartsystemforschools/main.dart';

class NotificationDetails extends StatelessWidget {
  static String id = 'notification_details';
  final NotificationProductModel notificationModel;
  const NotificationDetails({super.key, required this.notificationModel});
  // Helper method to split string lists
  List<String> _splitList(String input) {
    // Remove outer brackets and split
    String cleanInput = input
        .replaceAll(RegExp(r'^\[|\]$'), '') // Remove first and last brackets
        .replaceAll('[[', '') // Remove any remaining double opening brackets
        .replaceAll(']]', ''); // Remove any remaining double closing brackets
    return cleanInput.split(',').map((e) => e.trim()).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Split list-like strings
    final productName = _splitList(notificationModel.name.toString());
    log(productName.toString());
    final productImage = _splitList(notificationModel.productImg.toString());
    log(productImage.toString());
    final productIds = _splitList(notificationModel.id.toString());
    final quantities = _splitList(notificationModel.quantity.toString());
    final descriptions = _splitList(notificationModel.description);
    final prices = _splitList(notificationModel.price.toString());

    return Scaffold(
      appBar: CustomAppBar(
        onTap: () {
          Navigator.of(context).pop();
        },
        title: 'Notification Details',
        textStyle: AppStyles.styleBold20(),
        ThereIsicon: false,
      ),
      body: BlocBuilder<ThemeModeCubit, ThemeModeState>(
        builder: (context, state) {
          final isDark =
              context.read<ThemeModeCubit>().currentTheme == ThemeMode.dark;
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (notificationModel.message!.contains('failed'))
                      _StatusCard(
                        statusmessage: notificationModel.reason.toString(),
                        title: 'the payment is failed',
                        icon: Icons.error,
                      ),
                    if (notificationModel.message!.contains('success'))
                      _StatusCard(
                        statusmessage: notificationModel.message.toString(),
                        title: 'the payment is success',
                        icon: Icons.check,
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Products he want to purchase',
                      style: AppStyles.styleBold20(),
                    ),
                    // Detailed Information Cards
                    ...List.generate(
                      productIds.length,
                      (index) => _buildDetailCard(
                        context,
                        isDark: isDark,
                        index: index,
                        productImage: productImage[index],
                        studentId: notificationModel.studentId,
                        amountOfMoney: notificationModel.amountOfMoney,
                        productName: productName[index],
                        productId: productIds[index],
                        quantity: quantities[index],
                        description: descriptions[index],
                        price: prices[index],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context, {
    required int index,
    required bool isDark,
    required String studentId,
    required String productImage,
    required String amountOfMoney,
    required String productId,
    required String productName,
    required String quantity,
    required String description,
    required String price,
  }) {
    return Column(
      children: [
        Container(
                margin: const EdgeInsetsDirectional.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isDark ? Colors.black : Colors.white,
                  boxShadow: [
                    isDark
                        ? BoxShadow(
                            blurRadius: 6,
                            offset: const Offset(0, 0),
                            color: const Color(0xFFFFFFFF).withOpacity(.4))
                        : BoxShadow(
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                            color: Colors.black.withOpacity(0.13),
                          )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Product ${index + 1}',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              width: 20,
                              'https://school-api.runasp.net/Products/$productImage',
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                child: Icon(Icons.error),
                              ),
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) =>
                                      loadingProgress == null
                                          ? child
                                          : const Center(
                                              child: CircularProgressIndicator(
                                                backgroundColor: Colors.white,
                                                color: Colors.blue,
                                              ),
                                            ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      _buildDetailRow('Student ID', studentId),
                      _buildDetailRow('Amount of Money', amountOfMoney),
                      _buildDetailRow('Product Name', productName),
                      _buildDetailRow('Product ID', productId),
                      _buildDetailRow('Quantity', quantity),
                      _buildDetailRow('Description', description),
                      _buildDetailRow('Price', price),
                    ],
                  ),
                ))
            .animate(delay: (index * 200).ms)
            .fadeIn(duration: 600.ms)
            .slideX(
                begin: index % 2 == 0 ? 0.1 : -.1, end: 0, duration: 600.ms),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: FittedBox(
        child: Row(
          children: [
            FittedBox(
              child: Text(
                '$label:',
                style: AppStyles.styleBold14(),
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            value.contains(']')
                ? Text(value.split(']').first)
                : Text(value.split('[').last),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String statusmessage;
  const _StatusCard({
    super.key,
    required this.title,
    required this.icon,
    required this.statusmessage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        color: statusmessage.contains('success') ? Colors.green : Colors.red,
        child: Padding(
          padding: const EdgeInsetsDirectional.all(10),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStyles.styleMedium16().copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    statusmessage,
                    style: AppStyles.styleMedium12().copyWith(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    )
        .animate(delay: 200.ms)
        .fadeIn(duration: 600.ms)
        .slideX(begin: -.1, end: 0, duration: 600.ms);
  }
}
