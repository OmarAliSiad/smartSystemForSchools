part of 'spending_limit_cubit.dart';

@immutable
sealed class SpendingLimitState {}

final class SpendingLimitInitial extends SpendingLimitState {}

final class SpendingLimitLoading extends SpendingLimitState {}

final class GetSpendingLimitSuccess extends SpendingLimitState {
  final GetSendingLimit getSendingLimit;
  GetSpendingLimitSuccess(this.getSendingLimit);
}

final class GetSpendingLimitFailure extends SpendingLimitState {
  final String errorMessage;
  GetSpendingLimitFailure({required this.errorMessage});
}

final class AddSpendingLimitSuccess extends SpendingLimitState {
  AddSpendingLimitSuccess();
}

final class AddSpendingLimitFailure extends SpendingLimitState {
  final String errorMessage;
  AddSpendingLimitFailure({required this.errorMessage});
}
