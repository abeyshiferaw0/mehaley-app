part of 'all_videos_bloc.dart';

abstract class AllVideosState extends Equatable {
  const AllVideosState();
}

class AllVideosInitial extends AllVideosState {
  @override
  List<Object> get props => [];
}

class AllVideosLoadingState extends AllVideosState {
  @override
  List<Object?> get props => [];
}

class AllVideosLoadedState extends AllVideosState {
  final List<Song> videoSongsList;
  final int page;

  AllVideosLoadedState({
    required this.videoSongsList,
    required this.page,
  });

  @override
  List<Object?> get props => [videoSongsList, page];
}

class AllVideosLoadingErrorState extends AllVideosState {
  final String error;

  AllVideosLoadingErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
