part of 'app_start_bloc.dart';

abstract class AppStartState extends Equatable {
  const AppStartState();
}

class AppStartInitial extends AppStartState {
  @override
  List<Object> get props => [];
}

class IsAppFirstLaunchState extends AppStartState {
  final bool isFirstTime;

  IsAppFirstLaunchState({required this.isFirstTime});
  @override
  List<Object?> get props => [isFirstTime];
}

class ShowNotificationPermissionState extends AppStartState {
  final bool shouldShow;

  ShowNotificationPermissionState({required this.shouldShow});
  @override
  List<Object?> get props => [shouldShow];
}

class ShowSubscribeDialogState extends AppStartState {
  final bool shouldShow;

  ShowSubscribeDialogState({required this.shouldShow});
  @override
  List<Object?> get props => [shouldShow];
}
