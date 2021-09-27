part of 'lyric_bloc.dart';

abstract class LyricState extends Equatable {
  const LyricState();
}

class LyricInitial extends LyricState {
  @override
  List<Object> get props => [];
}

class LyricDataLoading extends LyricState {
  @override
  List<Object> get props => [];
}

class LyricDataLoaded extends LyricState {
  final List<LyricItem> lyricList;
  final int songId;

  LyricDataLoaded({required this.songId, required this.lyricList});

  @override
  List<Object> get props => [lyricList, songId];
}

class LyricDataLoadingError extends LyricState {
  final String error;

  LyricDataLoadingError({required this.error});

  @override
  List<Object> get props => [error];
}
