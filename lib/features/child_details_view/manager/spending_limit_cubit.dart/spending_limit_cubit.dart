import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import '../../../../core/services/payment_service/payment_service.dart';
import '../models/get_sending_limit/get_sending_limit.dart';
part 'spending_limit_state.dart';

class SpendingLimitCubit extends Cubit<SpendingLimitState> {
  SpendingLimitCubit() : super(SpendingLimitInitial());
  Future<GetSendingLimit?> getSpendingLimit({required String studentId}) async {
    try {
      emit(SpendingLimitLoading());
      GetSendingLimit getSendingLimit =
          await PaymentService().getSpenddingLimit(studentId: studentId);
      if (getSendingLimit.isSuccess == true) {
        emit(GetSpendingLimitSuccess(getSendingLimit));
        return getSendingLimit;
      } else {
        emit(GetSpendingLimitFailure(
            errorMessage: getSendingLimit.message.toString()));
        return getSendingLimit; // Return even on failure
      }
    } catch (e) {
      emit(GetSpendingLimitFailure(errorMessage: e.toString()));
      return null; // Return null on exception
    }
  }
  Future<Response> addSpendingLimit({
    required String studentId,
    double? dailySpendingLimit,
    double? weeklySpendingLimit,
    double? monthlySpendingLimit,
  }) async {
    try {
      emit(SpendingLimitLoading());
      log(dailySpendingLimit.toString());
      Response response = await PaymentService().addSpendingLimit(
          studentId: studentId,
          dailySpendingLimit: dailySpendingLimit,
          weeklySpendingLimit: weeklySpendingLimit,
          monthlySpendingLimit: monthlySpendingLimit);
      if (response.statusCode == 200) {
        return response;
      } else {
        emit(AddSpendingLimitFailure(errorMessage: response.data['message']));
        return response;
      }
    } catch (e) {
      emit(AddSpendingLimitFailure(errorMessage: e.toString()));
      return Response(
        requestOptions: RequestOptions(path: ''),
        data: {'message': 'An error occurred while adding spending limit.'},
      ); // Return null on exception
    }
  }
}
