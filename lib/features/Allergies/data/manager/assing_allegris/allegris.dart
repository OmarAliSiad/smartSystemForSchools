import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/core/models/allegry_details/allegry_details.dart';
import 'package:smartsystemforschools/features/Allergies/data/manager/assing_allegris/allegris_state.dart';
import '../../../../../core/utils/allegris_service.dart';

class AllergiesCubit extends Cubit<AllergiesState> {
  final AllergiesService allergiesService;
  AllergiesCubit(this.allergiesService) : super(AssignAllergiesInitial());
  Future<AllegryDetails> assignAllergies(
      String studentId, List<int> allergyCategories) async {
    log('studet id :$studentId  , allergyCategories : $allergyCategories ');
    emit(AssignAllergiesLoading());
    try {
      late AllegryDetails result;
      // We'll need to make a call for each selected category
      for (int categoryId in allergyCategories) {
        final allergies =
            await allergiesService.assingAllegris(studentId, categoryId);
        result = allergies;
      }
      emit(AssignAllergiesLoaded(result));
      return result;
    } catch (e) {
      emit(AssignAllergiesFailure(e.toString()));
      return AllegryDetails(message: e.toString());
    }
  }

  Future<void> getAllegrisForStudent(
    String studentId,
  ) async {
    log('studet id :$studentId');
    emit(GetAllergiesLoading());
    try {
      late AllegryDetails result;
      final allergies = await allergiesService.getAllegris(studentId);
      result = allergies;
      log(result.toJson().toString());
      emit(GetAllergiesLoaded(result));
    } catch (e) {
      emit(GetAllergiesFailure(e.toString()));
    }
  }
}
