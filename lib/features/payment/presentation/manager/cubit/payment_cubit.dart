import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:meta/meta.dart';
import '../../../../../core/models/get_balance/get_balance.dart';
import '../../../../../core/models/money_recharge_model/money_recharge_model.dart';
import '../../../../../core/models/parent_to_stuent_transcation/parent_to_stuent_transcation.dart';
import '../../../../../core/models/parent_to_stuent_transcation/result.dart';
import '../../../../../core/services/payment_service/payment_service.dart';
import '../../../../../core/services/stripe_service.dart';
import '../../../../../core/utils/paymobService.dart';
import '../../../data/models/payment_intent_model/payment_intent_input_model.dart';
import '../../views/payment_webView.dart';
part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());
  // Future<void> makePaymenStripeService({
  //   required PaymentIntentInputModel paymentIntentInputModel,
  //   required BuildContext context,
  // }) async {
  //   StripeService stripeService = StripeService();
  //   emit(PaymentLoading());
  //   try {
  //     bool data = await stripeService.makePayment(
  //         paymentIntentInputModel: paymentIntentInputModel, context: context);
  //     if (!data) {
  //       emit(PaymentFailure(errorMessage: 'Payment Failed, try again'));
  //     } else {
  //       emit(PaymentSuccess());
  //     }
  //   } on StripeException catch (e) {
  //     emit(PaymentFailure(errorMessage: e.toString()));
  //   } catch (e) {
  //     emit(PaymentFailure(errorMessage: e.toString()));
  //   }
  // }

  // void makePaymentWithPaymob({required BuildContext context}) async {
  //   emit(PaymentLoading());
  //   await PaymobService()
  //       .getPaymentKey(amount: 10, currency: "EGP")
  //       .then((paymentKey) async {
  //     Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: (context) {
  //           return PaymentWebview(
  //             url: Uri.parse(
  //                 'https://accept.paymob.com/api/acceptance/iframes/899682?payment_token=$paymentKey'),
  //           );
  //         },
  //       ),
  //     );
  //     emit(PaymentSuccess());
  //   }).catchError((e) {
  //     emit(PaymentFailure(errorMessage: e.toString()));
  //   });
  // }

  Future<void> checkoutPayment({required String amount}) async {
    try {
      emit(CheckoutPaymentLoading());
      MoneyRechargeModel paymentCheckoutModel =
          await PaymentService().moneyRecharge(
        amount: double.parse(amount),
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

  Future<void> getBalance() async {
    emit(GetBalanceLoading());
    try {
      GetBalance getBalance = await PaymentService().getBalance();
      if (getBalance.isSuccess == true) {
        emit(GetBalanceSuccess(getBalance: getBalance));
      } else {
        emit(GetBalanceFailure(errorMessage: getBalance.message.toString()));
      }
    } catch (e) {
      emit(GetBalanceFailure(errorMessage: e.toString()));
    }
  }

  Future<void> setMoneyForChild(
      {required String studentId, required double amountOfMoney}) async {
    emit(SetMoneyLoading());
    try {
      await PaymentService()
          .setMoneyForStudent(
        amountOfMoney: amountOfMoney,
        studentId: studentId,
      )
          .then((value) {
        if (value.isSuccess == true || value.statusCode == 200) {
          emit(SetMoneySuccess(parentToStuentTranscation: value.result!));
        } else {
          emit(SetMoneyFailure(errorMessage: value.message!));
        }
      });
    } catch (e) {
      emit(SetMoneyFailure(errorMessage: e.toString()));
    }
  }

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
