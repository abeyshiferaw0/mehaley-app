import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/artist.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

part 'share_buttons_event.dart';
part 'share_buttons_state.dart';

class ShareButtonsBloc extends Bloc<ShareButtonsEvent, ShareButtonsState> {
  ShareButtonsBloc() : super(ShareInitial());

  @override
  Stream<ShareButtonsState> mapEventToState(
    ShareButtonsEvent event,
  ) async* {
    if (event is ShareLyricEvent) {
      yield SharingState();
      if (event.lyricScreenShotFile != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath =
            await File('${directory.path}/lyric_shared.jpeg').create();
        await imagePath.writeAsBytes(event.lyricScreenShotFile!);

        /// Share LYRIC IMAGE AND SONG LINK
        String id = AppApi.toBase64Str(event.song.songId.toString());
        String shareUrl = '${AppApi.sharingBaseUrl}?type=mezmur&id=$id';
        await Share.shareFiles(
          [imagePath.path],
          subject: 'Ethiopian Orthodox Mezmurs On Mehaleye',
          text: shareUrl,
        );
        yield LyricSharedDoneState();
      } else {
        yield SharingErrorState(
            error: 'Something went wrong, un able to save image');
      }
    } else if (event is SharePlaylistEvent) {
      String id = AppApi.toBase64Str(event.playlist.playlistId.toString());
      String shareUrl = '${AppApi.sharingBaseUrl}?type=playlist&id=$id';
      Share.share(
        'Check out this orthodox mezmur playlist from mehaleye $shareUrl',
        subject: 'Ethiopian Orthodox Mezmurs On Mehaleye',
      );
    } else if (event is ShareAlbumEvent) {
      String id = AppApi.toBase64Str(event.album.albumId.toString());
      String shareUrl = '${AppApi.sharingBaseUrl}?type=album&id=$id';
      Share.share(
        'Check out this orthodox mezmur album from mehaleye $shareUrl',
        subject: 'Ethiopian Orthodox Mezmurs On Mehaleye',
      );
    } else if (event is ShareArtistEvent) {
      String id = AppApi.toBase64Str(event.artist.artistId.toString());
      String shareUrl = '${AppApi.sharingBaseUrl}?type=zemari&id=$id';
      Share.share(
        'Check out zemari ${event.artist.artistName.textEn} from mehaleye $shareUrl',
        subject: 'Ethiopian Orthodox Mezmurs On Mehaleye',
      );
    } else if (event is ShareSongEvent) {
      String id = AppApi.toBase64Str(event.song.songId.toString());
      String shareUrl = '${AppApi.sharingBaseUrl}?type=mezmur&id=$id';
      Share.share(
        'Check out this orthodox mezmur from mehaleye $shareUrl',
        subject: 'Ethiopian Orthodox Mezmurs On Mehaleye',
      );
    }
  }
}
