part of 'share_bloc.dart';

abstract class ShareEvent extends Equatable {
  const ShareEvent();
}

class ShareLyricEvent extends ShareEvent {
  ShareLyricEvent({
    required this.subject,
    required this.lyricScreenShotFile,
    required this.song,
  });

  final Uint8List? lyricScreenShotFile;
  final Song song;
  final String subject;

  @override
  List<Object?> get props => [lyricScreenShotFile, song, subject];
}
