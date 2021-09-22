part of 'song_menu_bloc.dart';

@immutable
abstract class SongMenuEvent extends Equatable {}

class LoadSearchLeftOverMenusEvent extends SongMenuEvent {
  final Song song;

  LoadSearchLeftOverMenusEvent({required this.song});

  @override
  List<Object?> get props => [song];
}
