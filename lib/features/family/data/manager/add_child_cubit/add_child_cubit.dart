import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import '../../../../../core/models/get_child_details/result.dart';
import '../../../../../core/utils/school_service.dart';

part 'add_child_cubit_state.dart';

class AddChildCubit extends Cubit<AddChildCubitState> {
  List<ResultForChildDetails> listchildDetails = [];
  File? image;
  final SchoolService _schoolService = SchoolService();

  AddChildCubit() : super(AddChildCubitInitial());

  Future<void> addedChild({
    required String id,
  }) async {
    try {
      emit(AddChildCubitLoading());

      final response = await _schoolService.addChild(id: id);

      if (response['isSuccess'] == true) {
        emit(AddChildCubitLAddedSuccess());
      } else {
        emit(AddChildCubitAddedFailure(
          errorMessage: response['message'] ?? 'Failed to add child',
        ));
      }
    } catch (e) {
      log("Error adding child: $e");
      emit(AddChildCubitAddedFailure(errorMessage: e.toString()));
    }
  }

  Future<void> getChildDetails() async {
    emit(AddChildCubitLoading());
    try {
      // Use the new method that returns a list of children
      List<ResultForChildDetails> results =
          await _schoolService.getAllChildDetails();

      // Clear the list before adding new data to avoid duplicates
      listchildDetails.clear();

      // Add all valid children to the list
      for (var child in results) {
        if (child.id != null) {
          listchildDetails.add(child);
          log("Added child to list: ${child.fullName}");
        } else {
          log("Child data is incomplete: ${child.toString()}");
        }
      }

      emit(AddChildCubitLAddedSuccess());
    } catch (e) {
      log("Error getting child details: $e");
      emit(AddChildCubitAddedFailure(errorMessage: e.toString()));
    }
  }

  Future<void> refreshChildData() async {
    try {
      await getChildDetails();
    } catch (e) {
      log("Error refreshing child data: $e");
      // Don't emit failure here to avoid UI disruption during refresh
    }
  }

  pickImage() async {
    try {
      ImagePicker imagePicker = ImagePicker();
      final pickedImage =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        image = File(pickedImage.path);
        emit(AddChildCubitLAddedSuccess());
      }
    } catch (e) {
      log("Error picking image: $e");
      // Don't emit failure for image picking to avoid disrupting the flow
    }
  }
}
