// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../attendance_ai_service.dart';
// import 'attendance_ai_state.dart';

// class AttendanceAICubit extends Cubit<AttendanceAIState> {
//   final AttendanceAIService _attendanceAIService;

//   AttendanceAICubit(this._attendanceAIService) : super(AttendanceAIInitial()) {
//     _initModel();
//   }

//   Future<void> _initModel() async {
//     try {
//       await _attendanceAIService.loadModel();
//     } catch (e) {
//       emit(AttendanceAIError('Failed to load AI model: $e'));
//     }
//   }

//   Future<void> analyzeAttendance(List<AttendanceRecord> records) async {
//     if (!_attendanceAIService.isModelLoaded) {
//       emit(AttendanceAIError('Model not loaded yet'));
//       return;
//     }

//     emit(AttendanceAILoading());

//     try {
//       final analysis =
//           await _attendanceAIService.analyzeAttendancePattern(records);
//       emit(AttendanceAISuccess(analysis));
//     } catch (e) {
//       emit(AttendanceAIError('Error analyzing attendance: $e'));
//     }
//   }
// }
