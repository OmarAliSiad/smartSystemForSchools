part of    'checkout_payment_cubit.dart';

@immutable
sealed class CheckoutPaymentState {}

final class CheckoutPaymentInitial extends CheckoutPaymentState {}

final class CheckoutPaymentLoading extends CheckoutPaymentState {}

final class CheckoutPaymentLoaded extends CheckoutPaymentState {
  final PaymentCheckoutModel?   CheckoutPaymentModel;
  CheckoutPaymentLoaded({required this.CheckoutPaymentModel});
}

final class CheckoutPaymentFailure extends CheckoutPaymentState {
  final String errMessage;
  CheckoutPaymentFailure({required this.errMessage});
}
