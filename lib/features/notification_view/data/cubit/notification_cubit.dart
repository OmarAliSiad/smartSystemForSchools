import 'dart:developer';
import 'package:bloc/bloc.dart';
import '../../../../core/services/notification_service/notification_service.dart';
import 'notification_state.dart';

// Cubit
class NotificationCubit extends Cubit<NotificationState> {
  final NotificationService _notificationService = NotificationService();
  // Store the last used filter to reuse when navigating back
  FilterNotificationModel? _lastUsedFilter;

  NotificationCubit() : super(NotificationInitial());

  // Check if we have an active filter
  bool hasActiveFilter() {
    return _lastUsedFilter != null;
  }

  // Get the current student ID from filter for UI state restoration
  String? getCurrentStudentId() {
    return _lastUsedFilter?.studentId;
  }

  Future<void> getAllNotifications(
      {FilterNotificationModel? filterModel}) async {
    // Only show loading if we're actually going to fetch data
    if (filterModel != null || _lastUsedFilter != null) {
      emit(NotificationLoading());
      try {
        // Save the filter model for later use
        _lastUsedFilter = filterModel ?? _lastUsedFilter;

        log('Getting notifications with filter: ${_lastUsedFilter?.studentId}');

        final result = await _notificationService.getAllNotifications(
          filterNotificationModel: _lastUsedFilter!,
        );
        if (result.isSuccess == true) {
          log('Notifications loaded successfully: ${result.result?.length ?? 0} items');
          emit(GetAllNotificationLoadedSuccessfully(notificationModel: result));
        } else {
          log('Failed to load notifications: ${result.message}');
          emit(NotificationFailure(
              error: result.message ?? 'Failed to load notifications'));
        }
      } catch (e) {
        log('Error loading notifications: $e');
        emit(NotificationFailure(error: e.toString()));
      }
    } else {
      log('No filter available, cannot load notifications');
      emit(const NotificationFailure(error: 'No filter available'));
    }
  }

  // Verify this method in notification_cubit.dart
  Future<void> reloadNotifications() async {
    if (_lastUsedFilter != null) {
      log('Reloading notifications with stored filter: ${_lastUsedFilter?.studentId}');
      await getAllNotifications(filterModel: _lastUsedFilter);
    } else {
      log('Cannot reload: No filter available');
      emit(const NotificationFailure(error: 'No filter available'));
    }
  }

  Future<void> getNotificationDetails({required String notificationId}) async {
    emit(NotificationDetailsLoading());
    log('notification id : $notificationId');
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
      // Refresh notifications after deletion using the last filter
      await reloadNotifications();
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
    log('Applying new filter for student: $studentId');
    final filter = FilterNotificationModel(
      studentId: studentId,
      date: date,
      status: status,
      title: title,
    );
    await getAllNotifications(filterModel: filter);
  }
}
