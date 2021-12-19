part of 'newer_version_bloc.dart';

abstract class NewerVersionState extends Equatable {
  const NewerVersionState();
}

class NewerVersionInitial extends NewerVersionState {
  @override
  List<Object> get props => [];
}

class ShouldShowNewVersionLoadingState extends NewerVersionState {
  @override
  List<Object> get props => [];
}

class ShouldShowNewVersionLoadedState extends NewerVersionState {
  final bool shouldShow;

  ShouldShowNewVersionLoadedState({required this.shouldShow});
  @override
  List<Object> get props => [shouldShow];
}

class ShouldShowNewVersionLoadingErrorState extends NewerVersionState {
  final String error;

  ShouldShowNewVersionLoadingErrorState({required this.error});
  @override
  List<Object> get props => [error];
}
