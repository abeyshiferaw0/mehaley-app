part of 'album_page_bloc.dart';

@immutable
abstract class AlbumPageEvent extends Equatable {}

class LoadAlbumPageEvent extends AlbumPageEvent {
  final int albumId;

  LoadAlbumPageEvent({required this.albumId});

  @override
  List<Object?> get props => [];
}
