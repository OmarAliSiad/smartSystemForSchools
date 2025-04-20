import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:meta/meta.dart';
import 'package:smartsystemforschools/core/models/payment_checkout_model/payment_checkout_model.dart';
import 'package:smartsystemforschools/core/services/school_service/school_service.dart';
import 'package:smartsystemforschools/core/services/stripe_service.dart';
import '../../../../../core/utils/paymobService.dart';
import '../../../data/models/payment_intent_model/payment_intent_input_model.dart';
import '../../views/payment_webView.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());
  Future<void> makePaymenStripeService({
    required PaymentIntentInputModel paymentIntentInputModel,
    required BuildContext context,
  }) async {
    StripeService stripeService = StripeService();
    emit(PaymentLoading());
    try {
      bool data = await stripeService.makePayment(
          paymentIntentInputModel: paymentIntentInputModel, context: context);
      if (!data) {
        emit(PaymentFailure(errorMessage: 'Payment Failed, try again'));
      } else {
        emit(PaymentSuccess());
      }
    } on StripeException catch (e) {
      emit(PaymentFailure(errorMessage: e.toString()));
    } catch (e) {
      emit(PaymentFailure(errorMessage: e.toString()));
    }
  }

  void makePaymentWithPaymob({required BuildContext context}) async {
    emit(PaymentLoading());
    await PaymobService()
        .getPaymentKey(amount: 10, currency: "EGP")
        .then((paymentKey) async {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return PaymentWebview(
              url: Uri.parse(
                  'https://accept.paymob.com/api/acceptance/iframes/899682?payment_token=$paymentKey'),
            );
          },
        ),
      );
      emit(PaymentSuccess());
    }).catchError((e) {
      emit(PaymentFailure(errorMessage: e.toString()));
    });
  }

  Future<void> checkoutPayment(
      {required String studentId, required String amount}) async {
    try {
      emit(CheckoutPaymentLoading());
      PaymentCheckoutModel paymentCheckoutModel =
          await SchoolService().checkPaymentStatus(
        amount: double.parse(amount),
        studentId: studentId,
      );

      // Check if the payment was successful
      if (paymentCheckoutModel.isSuccess == true) {
        emit(
          CheckoutPaymentLoaded(
            CheckoutPaymentModel: paymentCheckoutModel,
          ),
        );
      } else {
        // Handle unsuccessful payment with the error message from the model
        String errorMessage = paymentCheckoutModel.message ??
            'Payment processing failed. Please try again.';

        // Special handling for server errors
        if (paymentCheckoutModel.statusCode == 500) {
          errorMessage = 'Server error occurred. Please try again later.';
        }

        log('Payment checkout failed: $errorMessage');
        emit(CheckoutPaymentFailure(errMessage: errorMessage));
      }
    } catch (error) {
      log('Exception in checkout payment: $error');
      emit(CheckoutPaymentFailure(errMessage: error.toString()));
    }
  }
  // In payment_cubit.dart, add this method:

  Future<void> makePaymentWithSession(
      {required String sessionId,
      required String pubKey,
      required String secretKey,
      required String sessionUrl,
      required BuildContext context,
      required}) async {
    StripeService stripeService = StripeService();
    emit(PaymentLoading());
    try {
      bool success = await stripeService.makePaymentWithSession(
        sessionId: sessionId,
        pubKey: pubKey,
        context: context,
        sessionUrl: sessionUrl,
        secretKey: secretKey,
      );

      if (!success) {
        emit(PaymentFailure(errorMessage: 'Payment Failed, try again'));
      } else {
        emit(PaymentSuccess());
      }
    } on StripeException catch (e) {
      emit(PaymentFailure(errorMessage: e.toString()));
    } catch (e) {
      emit(PaymentFailure(errorMessage: e.toString()));
    }
  }
}
