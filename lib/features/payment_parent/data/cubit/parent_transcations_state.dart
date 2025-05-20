part of 'parent_transcations_cubit.dart';

sealed class ParentTranscationsState extends Equatable {
  const ParentTranscationsState();

  @override
  List<Object> get props => [];
}

final class ParentTranscationsInitial extends ParentTranscationsState {}

class ParentTransactionsLoading extends ParentTranscationsState {}

class ParentTransactionsLoaded extends ParentTranscationsState {
  final ParentTranscationsModel parentTranscations;
  ParentTransactionsLoaded(this.parentTranscations);
}

class ParentTransactionsError extends ParentTranscationsState {
  final String message;
  ParentTransactionsError(this.message);
}
