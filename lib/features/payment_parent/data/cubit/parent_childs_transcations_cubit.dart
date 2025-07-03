import 'package:bloc/bloc.dart';
import 'package:smartsystemforschools/features/payment_parent/data/models/student_transcations/parent_transctions_model.dart';
import 'package:smartsystemforschools/features/payment_parent/data/services/transcations_parent.dart';
part 'parent_childs_transcations_state.dart';

class ParentChildsTranscationsCubit
    extends Cubit<ParentChildsTranscationsState> {
  ParentChildsTranscationsCubit() : super(PaymentTransactionsInitial());
  Future<void> fetchTransactions({String? date}) async {
    try {
      emit(PaymentTransactionsLoading());
      await PaymentTransactionsService()
          .fetchTransactions(date: date)
          .then((value) {
        if (value.isSuccess == true) {
          emit(PaymentTransactionsLoaded(value));
        } else {
          emit(PaymentTransactionsError(value.message.toString()));
        }
      });
    } catch (e) {
      emit(PaymentTransactionsError(e.toString()));
    }
  }
}
