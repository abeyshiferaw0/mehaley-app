part of 'profile_page_bloc.dart';

abstract class ProfilePageState extends Equatable {
  const ProfilePageState();
}

class ProfilePageInitial extends ProfilePageState {
  @override
  List<Object> get props => [];
}

class ProfilePageLoadingState extends ProfilePageState {
  @override
  List<Object?> get props => [];
}

class ProfilePageLoadedState extends ProfilePageState {
  final ProfilePageData profilePageData;

  ProfilePageLoadedState({required this.profilePageData});

  @override
  List<Object?> get props => [profilePageData];
}

class ProfilePageLoadingErrorState extends ProfilePageState {
  final String error;

  ProfilePageLoadingErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
