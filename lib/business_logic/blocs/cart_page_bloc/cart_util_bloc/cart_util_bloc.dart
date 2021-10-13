import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/data/repositories/cart_data_repository.dart';
import 'package:equatable/equatable.dart';

part 'cart_util_event.dart';
part 'cart_util_state.dart';

class CartUtilBloc extends Bloc<CartUtilEvent, CartUtilState> {
  CartUtilBloc({required this.cartRepository}) : super(CartUtilInitial());

  final CartRepository cartRepository;

  @override
  Stream<CartUtilState> mapEventToState(
    CartUtilEvent event,
  ) async* {
    if (event is ClearAllCartEvent) {
      yield CartUtilLoadingState();
      try {
        await cartRepository.clearAllCart();
        yield CartAllRemovedState();
      } catch (error) {
        yield CartAllRemovingErrorState(
          error: error.toString(),
        );
      }
    } else if (event is AddRemovedSongCartEvent) {
      ///ADD TO RECENTLY ADDED OR REMOVED CART
      cartRepository.addRecentlyAddedRemovedSong(
        event.song.songId,
        event.appCartAddRemoveEvents,
      );
      yield CartUtilSongAddingState(song: event.song);
      try {
        await cartRepository.addRemoveSong(
          event.song.songId,
          event.appCartAddRemoveEvents,
        );

        ///REMOVE FROM ALTERNATIVE BOXES ADDED OR REMOVED CART
        cartRepository.removeAlternativeAddedRemovedSong(
          event.song.songId,
          event.appCartAddRemoveEvents,
        );
        yield CartUtilSongAddedSuccessState(
          song: event.song,
          appCartAddRemoveEvents: event.appCartAddRemoveEvents,
        );
      } catch (error) {
        ///REMOVE TO RECENTLY ADDED OR REMOVED
        cartRepository.removeRecentlyAddedRemovedSong(
          event.song.songId,
          event.appCartAddRemoveEvents,
        );
        yield CartUtilSongAddingErrorState(
          song: event.song,
          error: error.toString(),
          appCartAddRemoveEvents: event.appCartAddRemoveEvents,
        );
      }
    } else if (event is AddRemoveAlbumCartEvent) {
      ///ADD TO RECENTLY ADDED OR REMOVED CART
      cartRepository.addRecentlyAddedRemovedAlbum(
        event.album.albumId,
        event.appCartAddRemoveEvents,
      );
      yield CartUtilAlbumAddingState(album: event.album);
      try {
        await cartRepository.addRemoveAlbum(
          event.album.albumId,
          event.appCartAddRemoveEvents,
        );

        ///REMOVE FROM ALTERNATIVE BOXES ADDED OR REMOVED CART
        cartRepository.removeAlternativeAddedRemovedAlbum(
          event.album.albumId,
          event.appCartAddRemoveEvents,
        );
        yield CartUtilAlbumAddedSuccessState(
          album: event.album,
          appCartAddRemoveEvents: event.appCartAddRemoveEvents,
        );
      } catch (error) {
        ///REMOVE TO RECENTLY ADDED OR REMOVED
        cartRepository.removeRecentlyAddedRemovedAlbum(
          event.album.albumId,
          event.appCartAddRemoveEvents,
        );
        yield CartUtilAlbumAddingErrorState(
          album: event.album,
          error: error.toString(),
          appCartAddRemoveEvents: event.appCartAddRemoveEvents,
        );
      }
    } else if (event is AddRemovePlaylistCartEvent) {
      ///ADD TO RECENTLY ADDED OR REMOVED CART
      cartRepository.addRecentlyAddedRemovedPlaylist(
        event.playlist.playlistId,
        event.appCartAddRemoveEvents,
      );
      yield CartUtilPlaylistAddingState(playlist: event.playlist);
      try {
        await cartRepository.addRemovePlaylist(
          event.playlist.playlistId,
          event.appCartAddRemoveEvents,
        );

        ///REMOVE FROM ALTERNATIVE BOXES ADDED OR REMOVED CART
        cartRepository.removeAlternativeAddedRemovedPlaylist(
          event.playlist.playlistId,
          event.appCartAddRemoveEvents,
        );
        yield CartUtilPlaylistAddedSuccessState(
          playlist: event.playlist,
          appCartAddRemoveEvents: event.appCartAddRemoveEvents,
        );
      } catch (error) {
        ///REMOVE TO RECENTLY ADDED OR REMOVED
        cartRepository.removeRecentlyAddedRemovedPlaylist(
          event.playlist.playlistId,
          event.appCartAddRemoveEvents,
        );
        yield CartUtilPlaylistAddingErrorState(
          playlist: event.playlist,
          error: error.toString(),
          appCartAddRemoveEvents: event.appCartAddRemoveEvents,
        );
      }
    }
  }
}
