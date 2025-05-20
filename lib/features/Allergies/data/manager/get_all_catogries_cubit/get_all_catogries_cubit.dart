import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../../../core/models/catogry_details/catgory_details.dart';
import '../../../../../core/services/product_catogry_service/product_catogry_service.dart';
part 'get_all_catogries_state.dart';

class GetAllCatogriesCubit extends Cubit<GetAllCatogriesState> {
  GetAllCatogriesCubit() : super(GetAllCatogriesInitial());
  Future<CatgoryDetails> getAllCatogries() async {
    try {
      emit(GetAllCatogriesLoading());
      CatgoryDetails catgoryDetails =
          await ProductAndCatogryService().getAllCategory();
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
