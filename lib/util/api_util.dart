import 'package:dio/dio.dart';
import 'package:elf_play/config/app_hive_boxes.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/models/library_data/purchased_playlist.dart';
import 'package:elf_play/data/models/library_data/purchased_song.dart';
import 'package:elf_play/data/models/song.dart';

class ApiUtil {
  static Future<Response> get({
    required Dio dio,
    required String url,
    Map<String, dynamic>? queryParameters,
  }) async {
    ///GET USER TOKE
    String token =
        AppHiveBoxes.instance.userBox.get(AppValues.userAccessTokenKey);

    ///CONFIG HEADER
    Options options = Options(headers: {"Authorization": "Token $token"});

    var response = await dio.get(
      url,
      queryParameters: queryParameters,
      options: options,
    );

    return response;
  }

  static Future<Response> post({
    required Dio dio,
    required String url,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    required bool useToken,
  }) async {
    ///INIT OPTIONS
    Options? options;

    if (useToken) {
      ///GET USER TOKEN AND CSRF TOKEN
      String token =
          AppHiveBoxes.instance.userBox.get(AppValues.userAccessTokenKey);

      ///CONFIG HEADER TOKEN
      options = Options(
        headers: {
          "Authorization": "Token $token",
          "content-type": "application/x-www-form-urlencoded"
        },
      );
    }
    var response = await dio.post(
      url,
      data: data,
      options: useToken ? options : null,
      queryParameters: queryParameters,
    );

    return response;
  }

  static List<PurchasedSong> sortPurchasedSongs(
      List<PurchasedSong> items, appLibrarySortTypes) {
    if (appLibrarySortTypes == AppLibrarySortTypes.NEWEST) {
      items.sort((a, b) => a.paymentDate.compareTo(b.paymentDate));
      return items;
    } else if (appLibrarySortTypes == AppLibrarySortTypes.OLDEST) {
      items.sort((a, b) => a.paymentDate.compareTo(b.paymentDate));
      return items;
    } else if (appLibrarySortTypes == AppLibrarySortTypes.TITLE_A_Z) {
      items.sort(
        (a, b) => a.song.songName.textAm.compareTo(b.song.songName.textAm),
      );
      return items;
    } else if (appLibrarySortTypes == AppLibrarySortTypes.ARTIST_A_Z) {
      items.sort(
        (a, b) => a.song.artistsName[0].textAm
            .compareTo(b.song.artistsName[0].textAm),
      );
      return items;
    } else {
      throw "SORT TYPE NOT CORRECT";
    }
  }

  static List<Song> sortDownloadedSongs(
      List<Song> items, appLibrarySortTypes, List<int> timeDownloaded) {
    if (appLibrarySortTypes == AppLibrarySortTypes.NEWEST) {
      items.sort((b, a) => a.releasedDate.compareTo(b.releasedDate));
      return items;
    } else if (appLibrarySortTypes == AppLibrarySortTypes.OLDEST) {
      items.sort((a, b) => a.releasedDate.compareTo(b.releasedDate));
      return items;
    } else if (appLibrarySortTypes == AppLibrarySortTypes.TITLE_A_Z) {
      items.sort(
        (a, b) => a.songName.textAm.compareTo(b.songName.textAm),
      );
      return items;
    } else if (appLibrarySortTypes == AppLibrarySortTypes.ARTIST_A_Z) {
      items.sort(
        (a, b) => a.artistsName[0].textAm.compareTo(b.artistsName[0].textAm),
      );
      return items;
    } else if (appLibrarySortTypes == AppLibrarySortTypes.LATEST_DOWNLOAD) {
      List<SongDownloaded> songDownloads = [];

      ///COMBINE SONG WITH DOWNLOADED TIME
      for (var i = 0; i < items.length; i++) {
        songDownloads.add(
          SongDownloaded(
            downloadedTime: timeDownloaded.elementAt(i),
            song: items.elementAt(i),
          ),
        );
      }

      songDownloads.sort(
        (b, a) => a.downloadedTime.compareTo(b.downloadedTime),
      );
      return songDownloads.map((e) => e.song).toList();
    }

    {
      throw "SORT TYPE NOT CORRECT";
    }
  }

  static List<PurchasedPlaylist> sortPurchasedPlaylists(
      List<PurchasedPlaylist> items, appLibrarySortTypes) {
    if (appLibrarySortTypes == AppLibrarySortTypes.NEWEST) {
      items.sort((a, b) => a.paymentDate.compareTo(b.paymentDate));
      return items;
    } else if (appLibrarySortTypes == AppLibrarySortTypes.OLDEST) {
      items.sort((a, b) => a.paymentDate.compareTo(b.paymentDate));
      return items;
    } else if (appLibrarySortTypes == AppLibrarySortTypes.TITLE_A_Z) {
      items.sort(
        (a, b) => a.playlist.playlistNameText.textAm
            .compareTo(b.playlist.playlistNameText.textAm),
      );
      return items;
    } else if (appLibrarySortTypes == AppLibrarySortTypes.ARTIST_A_Z) {
      items.sort(
        (a, b) => a.playlist.playlistNameText.textAm
            .compareTo(b.playlist.playlistNameText.textAm),
      );
      return items;
    } else {
      throw "SORT TYPE NOT CORRECT";
    }
  }
}

class SongDownloaded {
  final Song song;
  final int downloadedTime;

  SongDownloaded({required this.song, required this.downloadedTime});
}
