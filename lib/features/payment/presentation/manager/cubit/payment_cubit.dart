import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:meta/meta.dart';
import 'package:smartsystemforschools/core/utils/stripe_service.dart';
import '../../../data/models/payment_intent_model/payment_intent_input_model.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());
  Future<void> makePayment({
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
}
