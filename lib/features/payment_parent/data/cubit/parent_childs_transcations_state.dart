part of 'parent_childs_transcations_cubit.dart';

sealed class ParentChildsTranscationsState {
  const ParentChildsTranscationsState();
  
  @override
  List<Object> get props => [];
}

class PaymentTransactionsInitial extends ParentChildsTranscationsState {}

class PaymentTransactionsLoading extends ParentChildsTranscationsState {}

class PaymentTransactionsLoaded extends ParentChildsTranscationsState {
  final ChildTransactionsModel transactions;
  PaymentTransactionsLoaded(this.transactions);
}

class PaymentTransactionsError extends ParentChildsTranscationsState {
  final String message;
  PaymentTransactionsError(this.message);
}

