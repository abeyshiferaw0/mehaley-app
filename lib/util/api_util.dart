import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/ethio_telecom_related/ethio_telecom_subscription_callback/ethio_telecom_subscription_callback_bloc.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/library_data/purchased_playlist.dart';
import 'package:mehaley/data/models/library_data/purchased_song.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:path_provider/path_provider.dart';

class ApiUtil {
  static Future<Response> get({
    required Dio dio,
    required String url,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    ///GET USER TOKE
    String token =
        AppHiveBoxes.instance.userBox.get(AppValues.userAccessTokenKey);

    ///CONFIG HEADER
    Options options = Options(headers: {'Authorization': 'Token $token'});

    var response = await dio.get(
      url,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
    print(
        "HEADERS ////// ////// ////// ////// HEADERS ${isFromCatch(response)} ${response.headers}");

    print(
        "HEADERS ////// ////// ////// ////// HEADERS ${isFromCatch(response)} ${response.extra['@fromNetwork@']}");

    ///CHECK IF REQUEST IS FROM CATCH
    ///ONLY CHECK HEADER FOR SUB STATUS IF NOT FROM CATCH
    if (!isFromCatch(response)) {
      print("HEADERS ////// ////// ////// ////// HEADERS");
      print("HEADERS ////// ////// GET  ////// ////// HEADERS");
      print("HEADERS => ${response.headers}");
      print("HEADERS ////// ////// ////// ////// HEADERS");

      ///CHECK HEADER FOR LOCAL ETHIO TELECOM SUBSCRIPTION
      BlocProvider.of<EthioTelecomSubscriptionCallbackBloc>(
              App.navigationKey.currentContext!)
          .add(
        EthioTeleSubCallbackEvent(headers: response.headers),
      );

      //print("headers: ${response.headers}");
    }

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
          'Authorization': 'Token $token',
          'content-type': 'application/x-www-form-urlencoded'
        },
      );
    }
    var response = await dio.post(
      url,
      data: data,
      options: useToken ? options : null,
      queryParameters: queryParameters,
    );

    print("HEADERS ////// ////// ////// ////// HEADERS");
    print("HEADERS ////// ////// POST ////// ////// HEADERS");
    print("HEADERS => ${response.headers}");
    print("HEADERS ////// ////// ////// ////// HEADERS");

    ///CHECK HEADER FOR LOCAL ETHIO TELECOM SUBSCRIPTION
    BlocProvider.of<EthioTelecomSubscriptionCallbackBloc>(
      App.navigationKey.currentContext!,
    ).add(
      EthioTeleSubCallbackEvent(headers: response.headers),
    );

    return response;
  }

  static Future<void> deleteAllCache() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    HiveCacheStore hiveCacheStore = HiveCacheStore(appDocPath);
    await hiveCacheStore.clean();
    return;
  }

  static Future<void> deleteFromCache(String urlKey, isUrl) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    HiveCacheStore hiveCacheStore = HiveCacheStore(appDocPath);
    if (isUrl) {
      final key = CacheOptions.defaultCacheKeyBuilder(
        RequestOptions(path: urlKey),
      );
      await hiveCacheStore.delete(key);
    } else {
      await hiveCacheStore.delete(urlKey);
    }
    return;
  }

  static bool isFromCatch(Response response) {
    if (response.extra['@fromNetwork@'] == null) return false;
    return !response.extra['@fromNetwork@'];
  }

  static List<PurchasedSong> sortPurchasedSongs(
      List<PurchasedSong> items, appLibrarySortTypes, context) {
    if (appLibrarySortTypes == AppLibrarySortTypes.NEWEST) {
      items.sort((a, b) => a.paymentDate.compareTo(b.paymentDate));
      return items;
    } else if (appLibrarySortTypes == AppLibrarySortTypes.OLDEST) {
      items.sort((a, b) => a.paymentDate.compareTo(b.paymentDate));
      return items;
    } else if (appLibrarySortTypes == AppLibrarySortTypes.TITLE_A_Z) {
      items.sort(
        (a, b) => L10nUtil.translateLocale(a.song.songName, context)
            .compareTo(L10nUtil.translateLocale(b.song.songName, context)),
      );
      return items;
    } else if (appLibrarySortTypes == AppLibrarySortTypes.ARTIST_A_Z) {
      items.sort(
        (a, b) => L10nUtil.translateLocale(a.song.artistsName[0], context)
            .compareTo(
                L10nUtil.translateLocale(b.song.artistsName[0], context)),
      );
      return items;
    } else {
      throw 'SORT TYPE NOT CORRECT';
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
        (a, b) => L10nUtil.translateLocale(a.songName, null)
            .compareTo(L10nUtil.translateLocale(b.songName, null)),
      );
      return items;
    } else if (appLibrarySortTypes == AppLibrarySortTypes.ARTIST_A_Z) {
      items.sort(
        (a, b) => L10nUtil.translateLocale(a.artistsName[0], null)
            .compareTo(L10nUtil.translateLocale(b.artistsName[0], null)),
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
      throw 'SORT TYPE NOT CORRECT';
    }
  }

  static List<PurchasedPlaylist> sortPurchasedPlaylists(
      List<PurchasedPlaylist> items, appLibrarySortTypes, context) {
    if (appLibrarySortTypes == AppLibrarySortTypes.NEWEST) {
      items.sort((a, b) => a.paymentDate.compareTo(b.paymentDate));
      return items;
    } else if (appLibrarySortTypes == AppLibrarySortTypes.OLDEST) {
      items.sort((a, b) => a.paymentDate.compareTo(b.paymentDate));
      return items;
    } else if (appLibrarySortTypes == AppLibrarySortTypes.TITLE_A_Z) {
      items.sort(
        (a, b) => L10nUtil.translateLocale(a.playlist.playlistNameText, context)
            .compareTo(
                L10nUtil.translateLocale(b.playlist.playlistNameText, context)),
      );
      return items;
    } else if (appLibrarySortTypes == AppLibrarySortTypes.ARTIST_A_Z) {
      items.sort(
        (a, b) => L10nUtil.translateLocale(a.playlist.playlistNameText, context)
            .compareTo(
                L10nUtil.translateLocale(b.playlist.playlistNameText, context)),
      );
      return items;
    } else {
      throw 'SORT TYPE NOT CORRECT';
    }
  }

  static setRecentlyPurchased(bool bool) async {
    await AppHiveBoxes.instance.recentlyPurchasedMadeBox
        .put(AppValues.recentlyPurchasedMadeKey, bool);
  }

  static isRecentlyPurchasedWasMade() {
    if (AppHiveBoxes.instance.recentlyPurchasedMadeBox
        .containsKey(AppValues.recentlyPurchasedMadeKey)) {
      return AppHiveBoxes.instance.recentlyPurchasedMadeBox
          .get(AppValues.recentlyPurchasedMadeKey);
    }

    return false;
  }
}

class SongDownloaded {
  final Song song;
  final int downloadedTime;

  SongDownloaded({required this.song, required this.downloadedTime});
}
