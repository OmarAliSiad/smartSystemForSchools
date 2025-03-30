import 'package:bloc/bloc.dart';
import 'package:smartsystemforschools/core/utils/notification_service/notification_service.dart';
import 'package:smartsystemforschools/features/notification_view/data/cubit/notification_state.dart';
import 'package:smartsystemforschools/features/notification_view/data/models/notification_model/notification_model.dart';

// Cubit
class NotificationCubit extends Cubit<NotificationState> {
  final NotificationService _notificationService = NotificationService();
  NotificationModel? _cachedNotifications;
  FilterNotificationModel? _currentFilter;

  NotificationCubit() : super(NotificationInitial());

  Future<void> getAllNotifications(
      {FilterNotificationModel? filterModel}) async {
    emit(NotificationLoading());
    try {
      // Use provided filter or default to previously used filter or create a new one
      _currentFilter = filterModel;
      final result = await _notificationService.getAllNotifications(
        filterNotificationModel: _currentFilter!,
      );
      if (result.isSuccess == true) {
        _cachedNotifications = result;
        emit(GetAllNotificationLoadedSuccessfully(notificationModel: result));
      } else {
        emit(NotificationFailure(
            error: result.message ?? 'Failed to load notifications'));
      }
    } catch (e) {
      emit(NotificationFailure(error: e.toString()));
    }
  }

  Future<void> getNotificationDetails({required String notificationId}) async {
    emit(NotificationLoading());
    try {
      final result = await _notificationService.getNotificationtDetails(
        notificationId: notificationId,
      );
      if (result.isSuccess == true) {
        emit(NotificationDetailsLoaded(notificationDetails: result));
      } else {
        emit(NotificationFailure(
            error: result.message ?? 'Failed to load notification details'));
      }
    } catch (e) {
      emit(NotificationFailure(error: e.toString()));
    }
  }

  Future<void> deleteNotification({required String notificationId}) async {
    emit(NotificationLoading());
    try {
      final result = await _notificationService.deleteNotification(
        notificationId: notificationId,
      );
      emit(NotificationDeleted(message: result));
      // Refresh notifications after deletion
      await getAllNotifications();
    } catch (e) {
      emit(NotificationFailure(error: e.toString()));
    }
  }

  // Method to apply filters
  Future<void> applyFilter({
    required String studentId,
    String? date,
    int? status,
    int? title,
  }) async {
    final filter = FilterNotificationModel(
      studentId: studentId,
      date: date,
      status: status,
      title: title,
    );
    await getAllNotifications(filterModel: filter);
  }
}
