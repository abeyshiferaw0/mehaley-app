part of 'app_min_version_bloc.dart';

abstract class AppMinVersionState extends Equatable {
  const AppMinVersionState();
}

class AppMinVersionInitial extends AppMinVersionState {
  @override
  List<Object> get props => [];
}

class CheckAppMinVersionLoadingState extends AppMinVersionState {
  @override
  List<Object?> get props => [];
}

class CheckAppMinVersionLoadedState extends AppMinVersionState {
  final String minAppVersion;
  final bool isAppBelowMinVersion;
  final String newVersion;
  final String currentVersion;

  CheckAppMinVersionLoadedState(
      {required this.newVersion,
      required this.currentVersion,
      required this.minAppVersion,
      required this.isAppBelowMinVersion});

  @override
  List<Object?> get props =>
      [minAppVersion, newVersion, currentVersion, isAppBelowMinVersion];
}

class CheckAppMinVersionLoadingErrorState extends AppMinVersionState {
  final String error;

  CheckAppMinVersionLoadingErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
