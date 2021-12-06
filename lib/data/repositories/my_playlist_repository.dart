import 'package:dio/dio.dart';
import 'package:mehaley/data/data_providers/my_playlist_data_provider.dart';
import 'package:mehaley/data/models/api_response/my_playlist_page_data.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/my_playlist.dart';

class MyPLayListRepository {
  ///INIT PROVIDER FOR API CALL
  final MyPlaylistDataProvider myPLayListDataProvider;

  const MyPLayListRepository({required this.myPLayListDataProvider});

  Future<MyPlaylistPageData> getMyPlaylistData(
      AppCacheStrategy appCacheStrategy) async {
    final List<MyPlaylist> myPlaylists;
    final Response response;

    response =
        await myPLayListDataProvider.getRawMyPlaylistData(appCacheStrategy);

    //PARSE CATEGORIES
    myPlaylists = (response.data['result'] as List)
        .map((myPlaylist) => MyPlaylist.fromMap(myPlaylist))
        .toList();

    MyPlaylistPageData myPlaylistPageData = MyPlaylistPageData(
      myPlaylists: myPlaylists,
      response: response,
    );

    return myPlaylistPageData;
  }

  cancelDio() {
    myPLayListDataProvider.cancel();
  }
}
