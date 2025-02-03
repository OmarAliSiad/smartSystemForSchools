import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'get_user_data_state.dart';

class GetUserDataCubit extends Cubit<GetUserDataState> {
  // List<QueryDocumentSnapshot> data = [];
  GetUserDataCubit() : super(GetUserDataInitial());

  Future<void> getData() async {
    try {
      emit(Loading());
      // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      //     .collection(Constants.userAppCollection)
      //     .get();
      // data.addAll(querySnapshot.docs);
      emit(UserDataLoaded(/*data: data*/));
    } on Exception catch (e) {
      emit(UserDataFailure(errorMessage: e.toString()));
    }
  }
}
