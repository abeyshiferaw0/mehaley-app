part of 'followed_artists_bloc.dart';

abstract class FollowedArtistsState extends Equatable {
  const FollowedArtistsState();
}

class FollowedArtistsInitial extends FollowedArtistsState {
  @override
  List<Object> get props => [];
}

class FollowedArtistsLoadedState extends FollowedArtistsState {
  final List<FollowedArtist> followedArtists;

  FollowedArtistsLoadedState({required this.followedArtists});

  @override
  List<Object?> get props => [followedArtists];
}

class FollowedArtistsLoadingErrorState extends FollowedArtistsState {
  final String error;

  FollowedArtistsLoadingErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

class FollowedArtistsLoadingState extends FollowedArtistsState {
  @override
  List<Object?> get props => [];
}
