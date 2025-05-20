import 'package:equatable/equatable.dart';
import '../../../../core/services/notification_service/get_notificatoin_details/get_notificatoin_details.dart';
import '../models/notification_model/notification_model.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class GetAllNotificationLoadedSuccessfully extends NotificationState {
  final NotificationModel notificationModel;

  const GetAllNotificationLoadedSuccessfully({required this.notificationModel});

  @override
  List<Object?> get props => [notificationModel];
}

class NotificationDetailsLoading extends NotificationState {}
class NotificationDetailsLoaded extends NotificationState {
  final GetNotificatoinDetails notificationDetails;

  const NotificationDetailsLoaded({required this.notificationDetails});

  @override
  List<Object?> get props => [notificationDetails];
}

class NotificationDeleted extends NotificationState {
  final String message;

  const NotificationDeleted({required this.message});

  @override
  List<Object?> get props => [message];
}

class NotificationFailure extends NotificationState {
  final String error;

  const NotificationFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
