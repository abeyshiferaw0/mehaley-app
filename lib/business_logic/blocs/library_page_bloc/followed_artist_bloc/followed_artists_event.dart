part of 'followed_artists_bloc.dart';

abstract class FollowedArtistsEvent extends Equatable {
  const FollowedArtistsEvent();
}

class LoadFollowedArtistsEvent extends FollowedArtistsEvent {
  @override
  List<Object?> get props => [];
}
