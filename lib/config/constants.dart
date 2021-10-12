import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:path_provider/path_provider.dart';

class AppApi {
  static const String musicBaseUrl = "http://192.168.135.202:8181/music";
  static const String userBaseUrl = "http://192.168.135.202:8181/user";
  static const String baseFileUrl = "http://192.168.135.202:8181";
  //3.128.186.103:8000

  static Future<CacheOptions> getDioCacheOptions() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    final options = CacheOptions(
      // A default store is required for interceptor.
      store: HiveCacheStore(appDocPath),
      // Default.
      policy: CachePolicy.refresh,
      // Optional. Returns a cached response on error but for statuses 401 & 403.
      // hitCacheOnErrorExcept: [401, 403],
      // Optional. Overrides any HTTP directive to delete entry past this duration.
      maxStale: const Duration(days: 7),
      // Default. Allows 3 cache sets and ease cleanup.
      priority: CachePriority.high,
      // Default. Body and headers encryption with your own algorithm.
      cipher: null,
      // Default. Key builder to retrieve requests.
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      // Default. Allows to cache POST requests.
      // Overriding [keyBuilder] is strongly recommended.
      allowPostMethod: false,
    );
    return options;
  }
}

class AppValues {
  //HOM PAGE ITEMS
  static const double recentlyPlayedItemSize = 120;
  static const double customGroupItemSize = 170;
  static const double homeUserLibImageItemSize = 50;
  static const double homeCategoriesItemHeight = 70;
  static const double homeCategoriesItemWidth = 155;
  static const double customGroupHeaderImageSize = 45;

  //BOTTOM BAR
  static const double bottomBarActiveIconSize = 28;
  static const double bottomBarIconSize = 24;

  //MINI PLAYER
  static const double miniPlayerAlbumArtSize = 45;
  static const double miniPlayerHeight = miniPlayerAlbumArtSize + 30;
  static const double miniPlayerTrackHeight = 2;
  static const double playerTrackHeight = 3;
  static const double playerTrackHeightThin = 2;

  //PLAYER PAGE
  static const double lyricPlayerHeight = 380;
  static const double queueSongItemSize = 50;
  static const int playerPreviewStartSecond = 5;

  //ALBUM PAGE
  static const double albumPageImageSize = 170;

  //PLAYLIST PAGE
  static const double playlistPageOneImageSize = 200;
  static const double playlistPageTwoImageSize = 40;
  static const double playlistSongItemSize = 50;
  static const double userPlaylistImageSize = 70;

  //ARTIST PAGE
  static const double artistSongItemSize = 50;
  static const double artistAlbumItemSize = 70;
  static const double featuringArtistItemImageSize = 130;
  static const double similarItemImageSize = 130;

  //LIBRARY PAGE
  static const double librarySmallTabsHeight = 35;
  static const double libraryMusicItemSize = 60;
  static const double followedArtistImageSize = 80;
  static const double offlineSongsSize = 65;
  static const String isLibraryForOffline = "IS_LIBRARY_FOR_OFFLINE";
  static const String isLibraryForProfile = "IS_LIBRARY_FOR_PROFILE";
  static const String profileListTypes = "PROFILE_LIST_TYPES";

  //CATEGORY PAGE
  static const double categoryHeaderHeight = 250;
  static const double categoryPopularItemsSize = 120;
  static const double categorySongItemSize = 50;

  //SEARCH PAGE
  static const double searchPersistentSliverHeaderHeight = 60;
  static const double searchFrontPageItemsImageSize = 80;
  static const double searchResultMicButtonSize = 60;
  static const double searchBarHeight = 58.0;
  static const double searchTopArtistSongsWidth = 110;

  //PROFILE PAGE
  static const double profilePagePicSize = 90;
  static const double editProfileImageSize = 160;

  //CART PAGE
  static const double cartItemsSize = 120;

  //HIVE BOXES
  static const String recentSearchesBox = "RECENT_SEARCHES";
  static const String userBox = "USER_BOX_KEY";
  static const String likedSongsBox = "LIKED_SONGS_BOX_KEY";
  static const String recentlyPlayedBox = "RECENTLY_PLAYED_BOX";
  static const String recentlyUnLikedSongBox = "RECENTLY_LIKED_SONG_BOX";
  static const String recentlyLikedSongBox = "RECENTLY_UNLIKED_SONG_BOX";
  static const String recentlyLikedAlbumBox = "RECENTLY_LIKED_ALBUM_BOX";
  static const String recentlyUnLikedAlbumBox = "RECENTLY_UNLIKED_ALBUM_BOX";
  static const String recentlyFollowedPlaylistBox =
      "RECENTLY_FOLLOWED_PLAYLIST_BOX";
  static const String recentlyUnFollowedPlaylistBox =
      "RECENTLY_UNFOLLOWED_PLAYLIST_BOX";
  static const String recentlyFollowedArtistBox =
      "RECENTLY_FOLLOWED_ARTIST_BOX";
  static const String recentlyUnFollowedArtistBox =
      "RECENTLY_UNFOLLOWED_ARTIST_BOX";
  static const String settingsBox = "SETTINGS_BOX";

  //HIVE BOX KEYS
  static const String lastPhoneAuthSentTimeKey = "LAST_PHONE_AUTH_SENT";
  static const String lastPhoneVerificationSentTimeKey = "LAST_PHONE_AUTH_TIME";
  static const String loggedInUserKey = "LOGGED_IN_USER";
  static const String userAccessTokenKey = "USER_ACCESS_TOKEN";
  static const String userTemporaryNameKey = "USER_TEMP_NAME";
  static const String userTemporaryColorKey = "USER_TEMP_COLOR";
  static const String downloadSongQualityKey = "DOWNLOAD_SONG_QUALITY";

  //system folders
  static const String folderSongs = "FOLDER_SONGS";
  static const String folderMedia = "MEDIA_SONGS";

  //OTHER
  static const double previewModeDialogAppIconSize = 40;
  static const double loadingWidgetSize = 160;
  static const int pageSize = 25;
  static const int colorChangeAnimationDuration = 500;
  static const int buttonBouncingDurationInMili = 200;
  static const int buttonBouncingDurationInMili2 = 50;
  static const double buttonBouncingScaleFactor = 1.5;
  static const double buttonBouncingScaleFactor2 = 1.5;
  static const double buttonBouncingScaleFactor3 = 1.1;
  static const double lyricFullPageSongItemSize = 75;
  static const double lyricPageCloseButtonSize = 16;
  static const double buttonBouncingScaleFactor4 = 0.2;
  static const String menuBarrierLabel = "MENU_DIALOG";
  static const double menuHeaderImageSize = 150;
  static String searchPageDebouncer = "SEARCH_PAGE_DEBOUNCER";
  static const double createPlaylistImageSize = 180;
  static const String downloaderSendPort = "downloader_send_port";
  static const String songExtraStr = "SONG_EXTRA";
  static const double previewDialogSongItemSize = 60;

  //static const String languageRadioGroupValue = "LANGUAGE_RADIO";
}

class AppIconSizes {
  static const double icon_size_12 = 12;
  static const double icon_size_20 = 20;
  static const double icon_size_24 = 24;
  static const double icon_size_32 = 32;
  static const double icon_size_48 = 48;
  static const double icon_size_52 = 52;
  static const double icon_size_64 = 64;
  static const double icon_size_28 = 28;
  static const double icon_size_72 = 72;
  static const double icon_size_36 = 36;
  static const double icon_size_16 = 16;
  static const double icon_size_4 = 4;
  static const double icon_size_30 = 30;
  static const double icon_size_8 = 8;
}

class AppDio {
  static Future<Dio> getDio() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    final options = CacheOptions(
      // A default store is required for interceptor.
      store: HiveCacheStore(appDocPath),
      // Default.
      policy: CachePolicy.refresh,
      // Optional. Returns a cached response on error but for statuses 401 & 403.
      // hitCacheOnErrorExcept: [401, 403],
      // Optional. Overrides any HTTP directive to delete entry past this duration.
      maxStale: const Duration(days: 7),
      // Default. Allows 3 cache sets and ease cleanup.
      priority: CachePriority.high,
      // Default. Body and headers encryption with your own algorithm.
      cipher: null,
      // Default. Key builder to retrieve requests.
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      // Default. Allows to cache POST requests.
      // Overriding [keyBuilder] is strongly recommended.
      allowPostMethod: false,
    );
    final dio = Dio()..interceptors.add(DioCacheInterceptor(options: options));
    return dio;
  }
}
