part of 'attendance_cubit.dart';

@immutable
sealed class AttendanceState {}

final class AttendanceInitial extends AttendanceState {}

final class AttendanceLoading extends AttendanceState {}

final class AttendanceLoaded extends AttendanceState {
  final AttendanceModel? attendanceModel;
  AttendanceLoaded({required this.attendanceModel});
}

final class AttendanceFailure extends AttendanceState {
  final String errMessage;
  AttendanceFailure({required this.errMessage});
}
