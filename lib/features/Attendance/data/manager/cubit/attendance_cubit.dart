import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smartsystemforschools/core/utils/attendance_service.dart';
import '../../../../../core/models/attendance_model/attendance_model.dart';
part 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit() : super(AttendanceInitial());
  Future<AttendanceModel?> getChildsAttendance({String? date}) async {
    try {
      emit(AttendanceLoading());
      AttendanceModel? attendanceModel =
          await AttendanceService().getAttendanceByParent(date: date);
      emit(AttendanceLoaded(attendanceModel: attendanceModel));
      return attendanceModel!;
    } catch (error) {
      emit(AttendanceFailure(errMessage: error.toString()));
      return null;
    }
  }
}
