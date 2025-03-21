part of 'payment_cubit.dart';

@immutable
sealed class PaymentState {}

final class PaymentInitial extends PaymentState {}

final class PaymentLoading extends PaymentState {}

final class PaymentSuccess extends PaymentState {}

final class PaymentFailure extends PaymentState {
  final String errorMessage;
  PaymentFailure({required this.errorMessage});
}


final class CheckoutPaymentInitial extends PaymentState {}

final class CheckoutPaymentLoading extends PaymentState {}

final class CheckoutPaymentLoaded extends PaymentState {
  final PaymentCheckoutModel?   CheckoutPaymentModel;
  CheckoutPaymentLoaded({required this.CheckoutPaymentModel});
}

final class CheckoutPaymentFailure extends PaymentState {
  final String errMessage;
  CheckoutPaymentFailure({required this.errMessage});
}
