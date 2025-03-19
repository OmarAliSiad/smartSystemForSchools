import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smartsystemforschools/core/models/payment_checkout_model/payment_checkout_model.dart';
import 'package:smartsystemforschools/core/utils/school_service.dart';
part 'checkout_payment_state.dart';

class CheckoutPaymentCubit extends Cubit<CheckoutPaymentState> {
  CheckoutPaymentCubit() : super(CheckoutPaymentInitial());
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
}
