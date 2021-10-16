// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_sync_played_from.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongSyncPlayedFromAdapter extends TypeAdapter<SongSyncPlayedFrom> {
  @override
  final int typeId = 18;

  @override
  SongSyncPlayedFrom read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SongSyncPlayedFrom.SEARCH;
      case 1:
        return SongSyncPlayedFrom.ARTIST_DETAIL;
      case 2:
        return SongSyncPlayedFrom.ALBUM_DETAIL;
      case 3:
        return SongSyncPlayedFrom.PLAYLIST_DETAIL;
      case 4:
        return SongSyncPlayedFrom.CATEGORY_DETAIL;
      case 5:
        return SongSyncPlayedFrom.FOR_YOU;
      case 6:
        return SongSyncPlayedFrom.SONG_GROUP;
      case 7:
        return SongSyncPlayedFrom.PLAYLIST_GROUP;
      case 8:
        return SongSyncPlayedFrom.ALBUM_GROUP;
      case 9:
        return SongSyncPlayedFrom.ARTIST_GROUP;
      case 10:
        return SongSyncPlayedFrom.RECENTLY_PLAYED;
      case 11:
        return SongSyncPlayedFrom.USER_PLAYLIST;
      case 12:
        return SongSyncPlayedFrom.FAVORITE_SONG;
      case 13:
        return SongSyncPlayedFrom.PURCHASED_SONG;
      case 14:
        return SongSyncPlayedFrom.CART_PAGE;
      case 15:
        return SongSyncPlayedFrom.PROFILE_PAGE;
      case 16:
        return SongSyncPlayedFrom.OFFLINE_PAGE;
      case 17:
        return SongSyncPlayedFrom.UNK;
      default:
        return SongSyncPlayedFrom.SEARCH;
    }
  }

  @override
  void write(BinaryWriter writer, SongSyncPlayedFrom obj) {
    switch (obj) {
      case SongSyncPlayedFrom.SEARCH:
        writer.writeByte(0);
        break;
      case SongSyncPlayedFrom.ARTIST_DETAIL:
        writer.writeByte(1);
        break;
      case SongSyncPlayedFrom.ALBUM_DETAIL:
        writer.writeByte(2);
        break;
      case SongSyncPlayedFrom.PLAYLIST_DETAIL:
        writer.writeByte(3);
        break;
      case SongSyncPlayedFrom.CATEGORY_DETAIL:
        writer.writeByte(4);
        break;
      case SongSyncPlayedFrom.FOR_YOU:
        writer.writeByte(5);
        break;
      case SongSyncPlayedFrom.SONG_GROUP:
        writer.writeByte(6);
        break;
      case SongSyncPlayedFrom.PLAYLIST_GROUP:
        writer.writeByte(7);
        break;
      case SongSyncPlayedFrom.ALBUM_GROUP:
        writer.writeByte(8);
        break;
      case SongSyncPlayedFrom.ARTIST_GROUP:
        writer.writeByte(9);
        break;
      case SongSyncPlayedFrom.RECENTLY_PLAYED:
        writer.writeByte(10);
        break;
      case SongSyncPlayedFrom.USER_PLAYLIST:
        writer.writeByte(11);
        break;
      case SongSyncPlayedFrom.FAVORITE_SONG:
        writer.writeByte(12);
        break;
      case SongSyncPlayedFrom.PURCHASED_SONG:
        writer.writeByte(13);
        break;
      case SongSyncPlayedFrom.CART_PAGE:
        writer.writeByte(14);
        break;
      case SongSyncPlayedFrom.PROFILE_PAGE:
        writer.writeByte(15);
        break;
      case SongSyncPlayedFrom.OFFLINE_PAGE:
        writer.writeByte(16);
        break;
      case SongSyncPlayedFrom.UNK:
        writer.writeByte(17);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongSyncPlayedFromAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
