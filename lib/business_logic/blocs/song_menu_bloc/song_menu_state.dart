part of 'song_menu_bloc.dart';

@immutable
abstract class SongMenuState extends Equatable {}

class SongMenuInitial extends SongMenuState {
  @override
  List<Object?> get props => [];
}

class SongMenuLeftOverDataLoading extends SongMenuState {
  @override
  List<Object?> get props => [];
}

class SongMenuLeftOverDataLoaded extends SongMenuState {
  final SongMenuLeftOverData songMenuLeftOverData;

  SongMenuLeftOverDataLoaded({required this.songMenuLeftOverData});

  @override
  List<Object?> get props => [songMenuLeftOverData];
}

class SongMenuLeftOverDataNotLoaded extends SongMenuState {
  @override
  List<Object?> get props => [];
}
