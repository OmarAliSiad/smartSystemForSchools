import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smartsystemforschools/features/payment_parent/data/models/parent_transcations/parent_transcations.dart';
import 'package:smartsystemforschools/features/payment_parent/data/services/transcations_parent.dart';
part 'parent_transcations_state.dart';

class ParentTranscationsCubit extends Cubit<ParentTranscationsState> {
  ParentTranscationsCubit() : super(ParentTranscationsInitial());
  Future<void> fetchParentTransactions(
      {String? studentId, String? date}) async {
    try {
      emit(ParentTransactionsLoading());
      await PaymentTransactionsService()
          .fetchParentTransactions(date: date, studentId: studentId)
          .then((value) {
        if (value.isSuccess == true) {
          emit(ParentTransactionsLoaded(value));
        } else {
          emit(ParentTransactionsError(value.message.toString()));
        }
      });
    } catch (e) {
      emit(ParentTransactionsError(e.toString()));
    }
  }
}
