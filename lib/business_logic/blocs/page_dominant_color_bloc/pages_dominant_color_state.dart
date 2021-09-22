part of 'pages_dominant_color_bloc.dart';

@immutable
abstract class PagesDominantColorState extends Equatable {}

class PagesDominantColorInitial extends PagesDominantColorState {
  @override
  List<Object?> get props => [];
}

class PagesDominantColorInitialState extends PagesDominantColorState {
  final Color dominantColor = AppColors.appGradientDefaultColor;
  @override
  List<Object?> get props => [dominantColor];
}

class AlbumPageDominantColorChangedState extends PagesDominantColorState {
  final Color color;

  AlbumPageDominantColorChangedState({required this.color});

  @override
  List<Object?> get props => [color];
}

class PlaylistPageDominantColorChangedState extends PagesDominantColorState {
  final Color color;

  PlaylistPageDominantColorChangedState({required this.color});

  @override
  List<Object?> get props => [color];
}

class PlayerPageDominantColorChangedState extends PagesDominantColorState {
  final Color color;

  PlayerPageDominantColorChangedState({required this.color});

  @override
  List<Object?> get props => [color];
}

// class PlayerPageLightDominantColorChangedState extends PagesDominantColorState {
//   final Color color;
//
//   PlayerPageLightDominantColorChangedState({required this.color});
//
//   @override
//   List<Object?> get props => [color];
// }
