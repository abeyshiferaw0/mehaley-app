import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/song.dart';

class OtherVideosPageData extends Equatable {
  final List<Song> videoSongsList;
  final Response? response;

  const OtherVideosPageData({
    required this.videoSongsList,
    required this.response,
  });

  @override
  List<Object?> get props => [
        videoSongsList,
        response,
      ];
}
