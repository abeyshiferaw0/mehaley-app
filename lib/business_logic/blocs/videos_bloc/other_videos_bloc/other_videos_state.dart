part of 'other_videos_bloc.dart';

abstract class OtherVideosState extends Equatable {
  const OtherVideosState();
}

class OtherVideosInitial extends OtherVideosState {
  @override
  List<Object> get props => [];
}

class OtherVideosLoadingState extends OtherVideosState {
  @override
  List<Object?> get props => [];
}

class OtherVideosLoadedState extends OtherVideosState {
  final OtherVideosPageData otherVideosPageData;

  OtherVideosLoadedState({required this.otherVideosPageData});

  @override
  List<Object?> get props => [otherVideosPageData];
}

class OtherVideosLoadingErrorState extends OtherVideosState {
  final String error;

  OtherVideosLoadingErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
