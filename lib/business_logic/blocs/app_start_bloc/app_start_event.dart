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
