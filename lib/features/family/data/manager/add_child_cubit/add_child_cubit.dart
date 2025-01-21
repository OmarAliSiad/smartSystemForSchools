import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import '../../../../../core/models/child_details_model.dart';
import '../../../../../core/utils/assets.dart';
part 'add_child_cubit_state.dart';

class AddChildCubit extends Cubit<AddChildCubitState> {
  List<ChildDetailsModel> ListchildDetailsModel = [
    ChildDetailsModel(
        imagePath: Assets.imagesShahdImage, name: 'Shahd', price: '40 EGP'),
    ChildDetailsModel(
        imagePath: Assets.imagesAhmedImage, name: 'Ahmed', price: '100  EGP'),
    ChildDetailsModel(
        imagePath: Assets.imagesHodaImage, name: 'Hoda', price: '40  EGP'),
  ];
  File? image;
  AddChildCubit() : super(AddChildCubitInitial());

  void addedChild({required ChildDetailsModel childDetailsModel}) {
    ListchildDetailsModel.add(childDetailsModel);
    emit(
      AddChildCubitLAddedSuccess(),
    );
  }

  pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    image = await imagePicker.pickImage(source: ImageSource.gallery).then(
          (value) => File(
            value!.path,
          ),
        );
    emit(AddChildCubitLAddedSuccess());
  }
}
