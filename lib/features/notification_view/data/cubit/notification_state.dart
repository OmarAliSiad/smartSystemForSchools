import 'package:equatable/equatable.dart';
import 'package:smartsystemforschools/core/services/notification_service/get_notificatoin_details/get_notificatoin_details.dart';
import 'package:smartsystemforschools/features/notification_view/data/models/notification_model/notification_model.dart';

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
