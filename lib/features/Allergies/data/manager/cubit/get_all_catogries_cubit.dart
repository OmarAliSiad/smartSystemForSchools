import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smartsystemforschools/core/models/catogry_details/catgory_details.dart';
import 'package:smartsystemforschools/core/utils/allegris_service.dart';

part 'get_all_catogries_state.dart';

class GetAllCatogriesCubit extends Cubit<GetAllCatogriesState> {
  GetAllCatogriesCubit() : super(GetAllCatogriesInitial());
  Future<CatgoryDetails> getAllCatogries() async {
    try {
      emit(GetAllCatogriesLoading());
      CatgoryDetails catgoryDetails = await AllergiesService().getAllCategory();
      log('catogries');
      log(catgoryDetails.result![0].toJson().toString());
      log(catgoryDetails.result![1].toJson().toString());
      emit(GetAllCatogriesLoaded(
        catgoryDetails: catgoryDetails,
      ));
      return catgoryDetails;
    } catch (e) {
      emit(GetAllCatogriesFailure(e.toString()));
      return CatgoryDetails();
    }
  }
}
