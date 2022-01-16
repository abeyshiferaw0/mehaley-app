import 'package:dio/dio.dart';
import 'package:mehaley/data/data_providers/videos_data_provider.dart';
import 'package:mehaley/data/models/api_response/other_videos_page_data.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/song.dart';

class VideosRepository {
  ///INIT PROVIDER FOR API CALL
  final VideosDataProvider videosDataProvider;

  const VideosRepository({required this.videosDataProvider});

  Future<List<Song>> getAllVideos(int page, int pageSize) async {
    final List<Song> videoSongsList;

    Response response = await videosDataProvider.getAllVideos(
      page,
      pageSize,
    );

    //PARSE SONGS IN PLAYLIST
    videoSongsList =
        (response.data as List).map((song) => Song.fromMap(song)).toList();

    return videoSongsList;
  }

  Future<OtherVideosPageData> getOtherVideos(
    AppCacheStrategy appCacheStrategy,
    int id,
  ) async {
    final List<Song> videoSongsList;
    final Response response;

    response = await videosDataProvider.getOtherVideos(
      appCacheStrategy,
      id,
    );

    //PARSE OTHER SONG VIDEOS
    videoSongsList =
        (response.data as List).map((song) => Song.fromMap(song)).toList();

    OtherVideosPageData otherVideosPageData = OtherVideosPageData(
      videoSongsList: videoSongsList,
      response: response,
    );

    return otherVideosPageData;
  }

  cancelDio() {
    videosDataProvider.cancel();
  }
}
