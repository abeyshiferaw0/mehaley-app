part of 'app_start_bloc.dart';

abstract class AppStartEvent extends Equatable {
  const AppStartEvent();
}

class IsAppFirstLaunchEvent extends AppStartEvent {
  @override
  List<Object?> get props => [];
}

class SetAppFirstLaunchEvent extends AppStartEvent {
  final bool isFirstTime;

  SetAppFirstLaunchEvent({required this.isFirstTime});
  @override
  List<Object?> get props => [isFirstTime];
}

class ShouldShowNotificationPermissionEvent extends AppStartEvent {
  @override
  List<Object?> get props => [];
}

class ShouldShowSubscribeDialogEvent extends AppStartEvent {
  @override
  List<Object?> get props => [];
}

class SetNotificationPermissionShownDateEvent extends AppStartEvent {
  final DateTime date;

  SetNotificationPermissionShownDateEvent({required this.date});

  @override
  List<Object?> get props => [date];
}
