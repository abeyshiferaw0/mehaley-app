import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

part 'share_event.dart';
part 'share_state.dart';

class ShareBloc extends Bloc<ShareEvent, ShareState> {
  ShareBloc() : super(ShareInitial());

  @override
  Stream<ShareState> mapEventToState(
    ShareEvent event,
  ) async* {
    if (event is ShareLyricEvent) {
      yield SharingState();
      if (event.lyricScreenShotFile != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath =
            await File('${directory.path}/lyric_shared.jpeg').create();
        await imagePath.writeAsBytes(event.lyricScreenShotFile!);

        /// Share LYRIC IMAGE AND SONG LINK
        await Share.shareFiles(
          [imagePath.path],
          subject: event.subject,
          text: "http://3.16.157.74:8000/share/artist/?id=2232",
        );
        yield LyricSharedDoneState();
      } else {
        yield SharingErrorState(
            error: 'Something went wrong, un able to save image');
      }
    }
  }
}
