part of 'one_signal_bloc.dart';

abstract class OneSignalEvent extends Equatable {
  const OneSignalEvent();
}

class SetNotificationTagEvent extends OneSignalEvent {
  final Map<String, dynamic> notificationTags;
  final AppUserNotificationTypes appUserNotificationTypes;

  SetNotificationTagEvent(
      {required this.notificationTags, required this.appUserNotificationTypes});

  @override
  List<Object?> get props => [notificationTags, appUserNotificationTypes];
}

class SetNotificationTagErrorEvent extends OneSignalEvent {
  final String error;

  SetNotificationTagErrorEvent({required this.error});

  @override
  List<Object?> get props => [error];
}

class SetNotificationTagSuccessEvent extends OneSignalEvent {
  @override
  List<Object?> get props => [];
}

class NotificationClickedEvent extends OneSignalEvent {
  final int itemId;
  final AppItemsType itemType;

  NotificationClickedEvent({required this.itemId, required this.itemType});

  @override
  List<Object?> get props => [itemId, itemType];
}

class NotificationClickedErrorEvent extends OneSignalEvent {
  final String error;

  NotificationClickedErrorEvent({required this.error});

  @override
  List<Object?> get props => [error];
}
