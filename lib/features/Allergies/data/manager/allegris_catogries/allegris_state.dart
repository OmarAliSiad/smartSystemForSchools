// States for the AssignAllergiesCubit
import 'package:smartsystemforschools/core/models/allegry_details/allegry_details.dart';

abstract class AllergiesState {}

class AssignAllergiesInitial extends AllergiesState {}

class AssignAllergiesLoading extends AllergiesState {}

class GetAllergiesLoading extends AllergiesState {}

class deleteAllergiesLoading extends AllergiesState {}

class AssignAllergiesLoaded extends AllergiesState {
  final AllegryCatogryDetails allergyItems;
  AssignAllergiesLoaded(this.allergyItems);
}

class GetAllergiesLoaded extends AllergiesState {
  final AllegryCatogryDetails allergyItems;
  GetAllergiesLoaded(this.allergyItems);
}

class AssignAllergiesFailure extends AllergiesState {
  final String errMessage;
  AssignAllergiesFailure(this.errMessage);
}

class GetAllergiesFailure extends AllergiesState {
  final String errMessage;
  GetAllergiesFailure(this.errMessage);
}

class AllergiesDeleted extends AllergiesState {}
