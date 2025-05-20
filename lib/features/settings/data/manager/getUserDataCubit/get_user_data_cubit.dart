import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smartsystemforschools/core/services/auth_service/auth_service.dart';
import 'package:smartsystemforschools/features/login/data/models/user_info_model.dart';
part 'get_user_data_state.dart';

class GetUserDataCubit extends Cubit<GetUserDataState> {
  GetUserDataCubit() : super(GetUserDataInitial());
  Future<void> getData() async {
    try {
      emit(GetUserDataLoading());
      AuthService().getUserInfo().then((value) {
        log(value.toJson().toString());
        emit(
          GetUserDataSuccess(userInfo: value),
        );
      });
    } on Exception catch (e) {
      emit(UserDataFailure(errorMessage: e.toString()));
    }
  }
}
