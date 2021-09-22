part of 'artist_page_bloc.dart';

@immutable
abstract class ArtistPageState extends Equatable {}

class ArtistPageInitial extends ArtistPageState {
  @override
  List<Object?> get props => [];
}

class ArtistPageLoadingState extends ArtistPageState {
  @override
  List<Object?> get props => [];
}

class ArtistPageLoadedState extends ArtistPageState {
  final ArtistPageData artistPageData;

  ArtistPageLoadedState({required this.artistPageData});

  @override
  List<Object?> get props => [ArtistPageData];
}

class ArtistPageLoadingErrorState extends ArtistPageState {
  final String error;

  ArtistPageLoadingErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
