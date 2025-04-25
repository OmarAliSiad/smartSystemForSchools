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
  final MoneyRechargeModel? CheckoutPaymentModel;
  CheckoutPaymentLoaded({required this.CheckoutPaymentModel});
}

final class CheckoutPaymentFailure extends PaymentState {
  final String errMessage;
  CheckoutPaymentFailure({required this.errMessage});
}

final class GetBalanceLoading extends PaymentState {}

final class GetBalanceSuccess extends PaymentState {
  final GetBalance getBalance;
  GetBalanceSuccess({required this.getBalance});
}

final class GetBalanceFailure extends PaymentState {
  final String errorMessage;
  GetBalanceFailure({required this.errorMessage});
}


final class SetMoneyLoading extends PaymentState {}

final class SetMoneySuccess extends PaymentState {
  final Result parentToStuentTranscation;
  SetMoneySuccess({required this.parentToStuentTranscation});
}

final class SetMoneyFailure extends PaymentState {
  final String errorMessage;
  SetMoneyFailure({required this.errorMessage});
}
