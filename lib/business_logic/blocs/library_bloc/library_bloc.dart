import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/data/repositories/like_follow_repository.dart';
import 'package:meta/meta.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  LibraryBloc({required this.libraryDataRepository}) : super(LibraryInitial());

  final LikeFollowRepository libraryDataRepository;

  @override
  Stream<LibraryState> mapEventToState(
    LibraryEvent event,
  ) async* {
    if (event is LikeUnlikeSongEvent) {
      ///ADD TO RECENTLY LIKED OR UNLIKED
      libraryDataRepository.addRecentlyLikedUnlikedSong(
        event.id,
        event.appLikeFollowEvents,
      );
      yield SongLikeUnlikeLoadingState();
      try {
        await libraryDataRepository.likeUnlikeSong(
          event.id,
          event.appLikeFollowEvents,
        );

        ///REMOVE FROM ALTERNATIVE BOXES LIKE OR UNLIKE
        libraryDataRepository.removeAlternativeLikedUnlikedSong(
          event.id,
          event.appLikeFollowEvents,
        );
        yield SongLikeUnlikeSuccessState(
          id: event.id,
          appLikeFollowEvents: event.appLikeFollowEvents,
        );
      } catch (error) {
        ///REMOVE TO RECENTLY LIKED OR UNLIKED
        libraryDataRepository.removeRecentlyLikedUnlikedSong(
          event.id,
          event.appLikeFollowEvents,
        );
        yield SongLikeUnlikeErrorState(
          id: event.id,
          appLikeFollowEvents: event.appLikeFollowEvents,
        );
      }
    } else if (event is LikeUnLikeAlbumEvent) {
      ///ADD TO RECENTLY LIKED OR UNLIKED
      libraryDataRepository.addRecentlyLikedUnlikedAlbum(
        event.id,
        event.appLikeFollowEvents,
      );
      yield AlbumLikeUnlikeLoadingState();
      try {
        await libraryDataRepository.likeUnlikeAlbum(
          event.id,
          event.appLikeFollowEvents,
        );

        ///REMOVE FROM ALTERNATIVE BOXES LIKE OR UNLIKE
        libraryDataRepository.removeAlternativeLikedUnlikedAlbum(
          event.id,
          event.appLikeFollowEvents,
        );
        yield AlbumLikeUnlikeSuccessState(
          id: event.id,
          appLikeFollowEvents: event.appLikeFollowEvents,
        );
      } catch (error) {
        ///REMOVE TO RECENTLY LIKED OR UNLIKED
        libraryDataRepository.removeRecentlyLikedUnlikedAlbum(
          event.id,
          event.appLikeFollowEvents,
        );
        yield AlbumLikeUnlikeErrorState(
          id: event.id,
          appLikeFollowEvents: event.appLikeFollowEvents,
        );
      }
    } else if (event is FollowUnFollowPlaylistEvent) {
      ///ADD TO RECENTLY FOLLOWED OR UNFOLLOWED
      libraryDataRepository.addRecentlyFollowedUnFollowedPlaylist(
        event.id,
        event.appLikeFollowEvents,
      );
      yield PlaylistFollowUnFollowLoadingState();
      try {
        await libraryDataRepository.followUnFollowPlaylist(
          event.id,
          event.appLikeFollowEvents,
        );

        ///REMOVE FROM ALTERNATIVE BOXES FOLLOW OR UNFOLLOW
        libraryDataRepository.removeAlternativeFollowedUnFollowedPlaylist(
          event.id,
          event.appLikeFollowEvents,
        );
        yield PlaylistFollowUnFollowSuccessState(
          id: event.id,
          appLikeFollowEvents: event.appLikeFollowEvents,
        );
      } catch (error) {
        ///REMOVE TO RECENTLY FOLLOW UNFOLLOW
        libraryDataRepository.removeRecentlyFollowedUnFollowedPlaylist(
          event.id,
          event.appLikeFollowEvents,
        );
        yield PlaylistFollowUnFollowErrorState(
          id: event.id,
          appLikeFollowEvents: event.appLikeFollowEvents,
        );
      }
    } else if (event is FollowUnFollowArtistEvent) {
      ///ADD TO RECENTLY FOLLOWED OR UNFOLLOWED
      libraryDataRepository.addRecentlyFollowedUnFollowedArtist(
        event.id,
        event.appLikeFollowEvents,
      );
      yield ArtistFollowUnFollowLoadingState();
      try {
        await libraryDataRepository.followUnFollowArtist(
          event.id,
          event.appLikeFollowEvents,
        );

        ///REMOVE FROM ALTERNATIVE BOXES FOLLOW OR UNFOLLOW
        libraryDataRepository.removeAlternativeFollowedUnFollowedArtist(
          event.id,
          event.appLikeFollowEvents,
        );
        yield ArtistFollowUnFollowSuccessState(
          id: event.id,
          appLikeFollowEvents: event.appLikeFollowEvents,
        );
      } catch (error) {
        ///REMOVE TO RECENTLY FOLLOW UNFOLLOW
        libraryDataRepository.removeRecentlyFollowedUnFollowedArtist(
          event.id,
          event.appLikeFollowEvents,
        );
        yield ArtistFollowUnFollowErrorState(
          id: event.id,
          appLikeFollowEvents: event.appLikeFollowEvents,
        );
      }
    }
  }
}
