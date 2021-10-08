part of 'pages_dominant_color_bloc.dart';

@immutable
abstract class PagesDominantColorEvent extends Equatable {}

class AlbumPageDominantColorChanged extends PagesDominantColorEvent {
  final String dominantColor;

  AlbumPageDominantColorChanged({required this.dominantColor});

  @override
  List<Object?> get props => [dominantColor];
}

class PlaylistPageDominantColorChanged extends PagesDominantColorEvent {
  final String dominantColor;

  PlaylistPageDominantColorChanged({required this.dominantColor});

  @override
  List<Object?> get props => [dominantColor];
}

class PlayerPageDominantColorChanged extends PagesDominantColorEvent {
  final String dominantColor;

  PlayerPageDominantColorChanged({required this.dominantColor});

  @override
  List<Object?> get props => [dominantColor];
}

class UserPlaylistPageDominantColorChanged extends PagesDominantColorEvent {
  final HexColor dominantColor;

  UserPlaylistPageDominantColorChanged({required this.dominantColor});

  @override
  List<Object?> get props => [dominantColor];
}

class UserProfilePageDominantColorChanged extends PagesDominantColorEvent {
  final HexColor dominantColor;

  UserProfilePageDominantColorChanged({required this.dominantColor});

  @override
  List<Object?> get props => [dominantColor];
}
