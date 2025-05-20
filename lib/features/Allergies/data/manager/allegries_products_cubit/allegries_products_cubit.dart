// allergies_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:smartsystemforschools/core/services/alllegris_service/allegris_service.dart';
import 'package:smartsystemforschools/features/Allergies/data/manager/allegries_products_cubit/allegries_products_state.dart';

class AllergiesProductCubit extends Cubit<AllergiesProductsState> {
  final AllergiesService _allergiesService = AllergiesService();

  AllergiesProductCubit() : super(AllergiesInitial());

  Future<void> getProductAllergies(String studentId) async {
    try {
      emit(AllergiesLoading());

      final allergiesProducts = await _allergiesService.getProductAllergies(
        studentId: studentId,
      );

      emit(AllergiesLoaded(allergiesProducts: allergiesProducts));
    } catch (e) {
      emit(AllergiesError(message: e.toString()));
    }
  }

  Future<void> assignProductAllergies({
    required String studentId,
    required List<String> allergiesProducts,
  }) async {
    try {
      emit(AllergiesLoading());

      final result = await _allergiesService.assignProductAllergies(
        studentId: studentId,
        allergiesProducts: allergiesProducts,
      );

      emit(AllergiesLoaded(allergiesProducts: result));
    } catch (e) {
      emit(AllergiesError(message: e.toString()));
    }
  }

  Future<void> removeProductAllergies({
    required String studentId,
    required List<String> allergiesProducts,
  }) async {
    try {
      emit(AllergiesLoading());

      final result = await _allergiesService.removeProductAllergies(
        studentId: studentId,
        allergiesProducts: allergiesProducts,
      );

      emit(AllergiesLoaded(allergiesProducts: result));
    } catch (e) {
      emit(AllergiesError(message: e.toString()));
    }
  }
}
