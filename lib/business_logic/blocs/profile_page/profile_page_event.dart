part of 'profile_page_bloc.dart';

abstract class ProfilePageEvent extends Equatable {
  const ProfilePageEvent();
}

class LoadProfilePageEvent extends ProfilePageEvent {
  LoadProfilePageEvent();

  @override
  List<Object?> get props => [];
}
