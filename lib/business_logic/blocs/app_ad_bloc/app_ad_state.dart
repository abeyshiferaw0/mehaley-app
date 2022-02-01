part of 'app_ad_bloc.dart';

abstract class AppAdState extends Equatable {
  const AppAdState();
}

class AppAdInitial extends AppAdState {
  @override
  List<Object> get props => [];
}

class AppAdLoadingState extends AppAdState {
  @override
  List<Object> get props => [];
}

class AppAdLoadedState extends AppAdState {
  final AppAdData appAdData;

  AppAdLoadedState({required this.appAdData});

  @override
  List<Object> get props => [appAdData];
}

class AppAdLoadingErrorState extends AppAdState {
  final String error;

  AppAdLoadingErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
