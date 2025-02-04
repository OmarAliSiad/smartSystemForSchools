import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:smartsystemforschools/core/methods/show_scaffold_messanger.dart';
import 'package:smartsystemforschools/core/utils/api_keys.dart';
import 'package:smartsystemforschools/core/utils/api_service.dart';
import 'package:smartsystemforschools/core/widgets/show_dialog.dart';
import 'package:smartsystemforschools/features/payment/data/models/payment_intent_model/payment_intent_input_model.dart';
import 'package:smartsystemforschools/features/payment/data/models/payment_intent_model/payment_intent_model.dart';
import 'package:smartsystemforschools/features/payment/data/models/ephemeral_key_model/ephmeral_key_model.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';

class StripeService {
  final String url = 'https://api.stripe.com/v1/payment_intents';
  final ApiService apiService = ApiService();

  // Create a PaymentIntent
  Future<PaymentIntentModel> createPaymentIntent(
      PaymentIntentInputModel paymentIntentInputModel) async {
    try {
      Response response = await apiService.post(
        url: url,
        body: paymentIntentInputModel.toJson(),
        token: ApiKeys.secretKey,
        headers: {
          'Authorization': 'Bearer ${ApiKeys.secretKey}',
        },
      );
      PaymentIntentModel paymentIntentModel =
          PaymentIntentModel.fromJson(response.data);
      return paymentIntentModel;
    } catch (e) {
      log('Error creating PaymentIntent: $e');
      rethrow;
    }
  }

  // Initialize the Payment Sheet
  Future<void> initPaymentSheet(
    BuildContext context, {
    required String customerId,
    required String ephemeralKeySecret,
    required String clientSecret,
  }) async {
    try {
      // Get the current theme mode from the ThemeModeCubit
      final themeMode = context.read<ThemeModeCubit>().currentTheme;
      final bool isDarkMode = themeMode == ThemeMode.dark;

      // Initialize the payment sheet with the appropriate theme
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Main params
          merchantDisplayName: 'omar ali',
          paymentIntentClientSecret: clientSecret, // Use the clientSecret here
          customerId: customerId,
          customerEphemeralKeySecret: ephemeralKeySecret,
          // Set the theme based on the current theme mode
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: isDarkMode ? Colors.blueAccent : Colors.blue,
              background: isDarkMode ? Colors.black : Colors.white,
              componentBackground:
                  isDarkMode ? Colors.grey[900]! : Colors.white,
              componentBorder:
                  isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
              componentDivider:
                  isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
              componentText: isDarkMode ? Colors.white : Colors.black,
              primaryText: isDarkMode ? Colors.white : Colors.black,
              secondaryText: isDarkMode ? Colors.grey[400]! : Colors.grey[600]!,
              placeholderText:
                  isDarkMode ? Colors.grey[500]! : Colors.grey[400]!,
              icon: isDarkMode ? Colors.white : Colors.black,
              error: isDarkMode ? Colors.red[400]! : Colors.red,
            ),
          ),
        ),
      );
    } catch (e) {
      dispalySnackBar(
        context,
        title: 'Error: $e',
        titleActionButton: 'ok',
        color: Colors.red,
      );
      rethrow;
    }
  }

  // Display the Payment Sheet
  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      log('Error displaying Payment Sheet: $e');
      rethrow;
    }
  }

  // Make a Payment
  Future<bool> makePayment({
    required PaymentIntentInputModel paymentIntentInputModel,
    required BuildContext context,
  }) async {
    try {
      // Step 1: Create a PaymentIntent
      PaymentIntentModel paymentIntentModel =
          await createPaymentIntent(paymentIntentInputModel);

      // Log the clientSecret for debugging
      log('Client Secret: ${paymentIntentModel.clientSecret}');

      // Step 2: Create an Ephemeral Key
      var ephemeralKeyModel =
          await createEphemeralKey(customerID: paymentIntentModel.customer!);

      // Step 3: Initialize the Payment Sheet
      await initPaymentSheet(
        context,
        clientSecret: paymentIntentModel.clientSecret!, // Pass the clientSecret
        ephemeralKeySecret: ephemeralKeyModel.secret!,
        customerId: paymentIntentModel.customer!,
      );

      // Step 4: Display the Payment Sheet
      await displayPaymentSheet();

      // If the payment is successful, show a success message
      showAswemoDialog(
        dialogType: DialogType.success,
        context: context,
        title: 'Payment successful!',
        desc: 'Your payment has been processed successfully.',
      );
      return true;
    } on StripeException catch (e) {
      // Handle Stripe-specific errors

      if (e.error.code == FailureCode.Canceled) {
        // User canceled the payment flow
        dispalySnackBar(
          context,
          title: 'Payment canceled by the user.',
          titleActionButton: 'ok',
          color: Colors.orange,
        );
      } else {
        // Other Stripe errors
        dispalySnackBar(
          context,
          title: 'Error: ${e.error.localizedMessage}',
          titleActionButton: 'ok',
          color: Colors.red,
        );
      }
      return false;
    } catch (e) {
      // Handle generic errors
      dispalySnackBar(
        context,
        title: 'Error: $e',
        titleActionButton: 'ok',
        color: Colors.red,
      );
      return false;
    }
  }

  // Create a Customer
  Future<PaymentIntentModel> createCustomer(
      PaymentIntentInputModel paymentIntentInputModel) async {
    try {
      Response response = await apiService.post(
        url: 'https://api.stripe.com/v1/customers',
        body: paymentIntentInputModel.toJson(),
        token: ApiKeys.secretKey,
        headers: {
          'Authorization': 'Bearer ${ApiKeys.secretKey}',
        },
      );
      PaymentIntentModel paymentIntentModel =
          PaymentIntentModel.fromJson(response.data);
      return paymentIntentModel;
    } catch (e) {
      log('Error creating Customer: $e');
      rethrow;
    }
  }

  // Create an Ephemeral Key
  Future<EphemeralKeyModel> createEphemeralKey({
    required String customerID,
  }) async {
    try {
      Response ephemeralResponse = await apiService.post(
        url: 'https://api.stripe.com/v1/ephemeral_keys',
        body: {'customer': customerID},
        token: ApiKeys.secretKey,
        headers: {
          'Authorization': 'Bearer ${ApiKeys.secretKey}',
          'Stripe-Version': '2024-10-28.acacia', // Ensure this is correct
        },
      );
      EphemeralKeyModel ephemeralKeyModel =
          EphemeralKeyModel.fromJson(ephemeralResponse.data);
      return ephemeralKeyModel;
    } catch (e) {
      log('Error creating Ephemeral Key: $e');
      rethrow;
    }
  }
}
