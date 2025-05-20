import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/models/allegry_details/allegry_details.dart';
import 'allegris_state.dart';
import '../../../../../core/services/alllegris_service/allegris_service.dart';

class AllergiesCubitCatogry extends Cubit<AllergiesState> {
  final AllergiesService allergiesService;
  AllergiesCubitCatogry(this.allergiesService)
      : super(AssignAllergiesInitial());
  Future<AllegryCatogryDetails> assignAllergies(
      String studentId, List<int> allergyCategories) async {
    log('studet id :$studentId  , allergyCategories : $allergyCategories ');
    emit(AssignAllergiesLoading());
    try {
      late AllegryCatogryDetails result;
      // We'll need to make a call for each selected category
      for (int categoryId in allergyCategories) {
        final allergies = await allergiesService.assingAllegrisCatogries(
            studentId, categoryId);
        result = allergies;
      }
      emit(AssignAllergiesLoaded(result));
      return result;
    } catch (e) {
      emit(AssignAllergiesFailure(e.toString()));
      return AllegryCatogryDetails(message: e.toString());
    }
  }

  Future<void> getAllegrisForStudent(
    String studentId,
  ) async {
    log('studet id :$studentId');
    emit(GetAllergiesLoading());
    try {
      late AllegryCatogryDetails result;
      final allergies = await allergiesService.getAllegrisCatogries(studentId);
      result = allergies;
      log(result.toJson().toString());
      emit(GetAllergiesLoaded(result));
    } catch (e) {
      emit(GetAllergiesFailure(e.toString()));
    }
  }

  Future<AllegryCatogryDetails> deleteAllegris(
      String studentId, List<int> allergyCategories) async {
    log('studet id :$studentId  , allergyCategories : $allergyCategories ');
    emit(deleteAllergiesLoading());
    try {
      late AllegryCatogryDetails result;
      // We'll need to make a call for each selected category
      for (int categoryId in allergyCategories) {
        final allergies = await allergiesService.deleteAllegrisCatogries(
            studentId, categoryId);
        result = allergies;
      }
      emit(AllergiesDeleted());
      return result;
    } catch (e) {
      emit(AssignAllergiesFailure(e.toString()));
      return AllegryCatogryDetails(message: e.toString());
    }
  }
}
