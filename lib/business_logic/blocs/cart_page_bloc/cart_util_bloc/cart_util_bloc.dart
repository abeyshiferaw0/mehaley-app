import 'dart:async';

import 'package:bloc/bloc.dart';
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
    if (event is RemoveSongFromCartEvent) {
      yield CartUtilLoadingState();
      try {
        await cartRepository.removeSongFromCart(event.song);
        yield CartUtilSongRemovedState(song: event.song);
      } catch (error) {
        yield CartUtilSongRemoveErrorState(
          error: error.toString(),
          song: event.song,
        );
      }
    } else if (event is RemoveAlbumFromCartEvent) {
      yield CartUtilLoadingState();
      try {
        await cartRepository.removeAlbumFromCart(event.album);
        yield CartUtilAlbumRemovedState(album: event.album);
      } catch (error) {
        yield CartUtilAlbumRemoveErrorState(
          error: error.toString(),
          album: event.album,
        );
      }
    } else if (event is RemovePlaylistFromCartEvent) {
      yield CartUtilLoadingState();
      try {
        await cartRepository.removePlaylistFromCart(event.playlist);
        yield CartUtilPlaylistRemovedState(playlist: event.playlist);
      } catch (error) {
        yield CartUtilPlaylistRemoveErrorState(
          error: error.toString(),
          playlist: event.playlist,
        );
      }
    }
  }
}
