part of 'artist_page_bloc.dart';

@immutable
abstract class ArtistPageEvent extends Equatable {}

class LoadArtistPageEvent extends ArtistPageEvent {
  final int artistId;

  LoadArtistPageEvent({required this.artistId});

  @override
  List<Object?> get props => [artistId];
}
