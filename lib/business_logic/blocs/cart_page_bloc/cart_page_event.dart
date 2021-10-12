part of 'cart_page_bloc.dart';

abstract class CartPageEvent extends Equatable {
  const CartPageEvent();
}

class LoadCartPageEvent extends CartPageEvent {
  LoadCartPageEvent({this.song, this.album, this.playlist, this.isForRemoved});

  final bool? isForRemoved;
  final Song? song;
  final Album? album;
  final Playlist? playlist;

  @override
  List<Object?> get props => [];
}
