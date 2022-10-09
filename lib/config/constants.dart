import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:path_provider/path_provider.dart';

class AppApi {
  static String mainUrl = "https://api.mehaleye.com";

  ///BASED ON BUILD TYPE
  static String baseUrl = "https://api.mehaleye.com";

  //static String baseUrl = 'http://192.168.0.15:8000';
  static String musicBaseUrl = '$baseUrl/music';
  static String userBaseUrl = '$baseUrl/user';
  static String paymentBaseUrl = '$baseUrl/payment';
  static String cartBaseUrl = '$baseUrl/subscription';
  static String adBaseUrl = '$baseUrl/ad';
  static const String cyberSourceFormPaymentUrl =
      'https://cyberSource.payment.mehaleye.com';
  static const String sharingBaseUrl = 'https://mehaleye.com/deeplink/share';

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
      maxStale: const Duration(days: 5),
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

  static String toBase64Str(String str) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(str);
    return encoded;
  }

  static String fromBase64(String str) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String decode = stringToBase64.decode(str);
    return decode;
  }
}

class WebPaymentValues {
  static String cancelUrl =
      AppApi.paymentBaseUrl + '/purchase/web_payment/cancel/';
  static String failureUrl =
      AppApi.paymentBaseUrl + '/purchase/web_payment/fail/';
  static String completedUrl =
      AppApi.paymentBaseUrl + '/purchase/web_payment/completed/';
  static String alreadyPurchasedUrl =
      AppApi.paymentBaseUrl + '/purchase/web_payment/exists/';
  static String isFreeUrl =
      AppApi.paymentBaseUrl + '/purchase/web_payment/free/';
}

class AppValues {
  ///
  static const bool kisDebug = false;

  ///
  static const String appStoreId = "1616875830";

  //AUTH PAGES
  static const double signUpAppIconSize = 130;

  //HOM PAGE ITEMS
  static const double recentlyPlayedItemSize = 120;
  static const double customGroupItemSize = 170;
  static const double homeUserLibImageItemSize = 50;
  static const double homeCategoriesItemHeight = 70;
  static const double homeCategoriesItemWidth = 155;
  static const double customGroupHeaderImageSize = 50;
  static const double featuredSongsPagerHeight = 80;
  static const double homeHeaderGradientColor = 400;
  static const double homePageHeaderTabsHeight = 60;

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
  static const double queueSongItemSize = 60;
  static const double menuBottomSheetRadius = 16.0;
  static const double playlistHeaderSliverSize = 370;
  static const double playlistHeaderAppBarSliverSize = 60;

  //USER PLAYLIST PAGE
  static const double userPlaylistHeaderSliverHeight = 350;
  static const double userPlaylistHeaderAppBarSliverHeight = 100;

  //ALBUM PAGE
  static const double albumPageImageSize = 170;

  //PLAYLIST PAGE
  static const double playlistPageOneImageSize = 160;
  static const double playlistPageTwoImageSize = 40;
  static const double playlistSongItemSize = 60;
  static const double userPlaylistImageSize = 50;

  //ARTIST PAGE
  static const double artistSongItemSize = 60;
  static const double artistAlbumItemSize = 70;
  static const double featuringArtistItemImageSize = 130;
  static const double similarItemImageSize = 130;
  static const double artistSliverHeaderHeight = 360;
  static const double artistSliverHeaderMinHeight = 120;

  //LIBRARY PAGE
  static const double librarySmallTabsHeight = 35;
  static const double libraryMusicItemSize = 60;
  static const double followedArtistImageSize = 80;
  static const double offlineSongsSize = 65;
  static const String isLibraryForOffline = 'IS_LIBRARY_FOR_OFFLINE';
  static const String isLibraryForOtherPage = 'IS_LIBRARY_FOR_OTHER_PAGE';
  static const String libraryFromOtherPageTypes =
      'LIBRARY_FROM_OTHER_PAGE_TYPES';

  //CATEGORY PAGE
  static const double categoryHeaderHeight = 250;
  static const double categoryPopularItemsSize = 120;
  static const double categorySongItemSize = 60;

  //SEARCH PAGE
  static const double searchPersistentSliverHeaderHeight = 80;
  static const double searchPersistentSliverInputHeaderHeight = 90;
  static const double searchFrontPageItemsImageSize = 80;
  static const double searchResultMicButtonSize = 60;
  static const double searchBarHeight = 58.0;
  static const double searchTopArtistSongsWidth = 110;

  //PROFILE PAGE
  static const double profilePagePicSize = 90;
  static const double editProfileImageSize = 160;
  static const double profilePageSliverHeaderHeight = 320;
  static const double profilePageSliverHeaderAppBarHeight = 80;
  static const double userProfileButtonImageSize = 65;

  //CART PAGE
  static const double cartItemsSize = 120;
  static const double cartClearAndCheckoutHeaderHeight = 100;

  //HIVE BOXES
  static const String songSyncBox = 'SONG_SYNC';
  static const String systemUpdateBox = 'SYSTEM_UPDATE_BOX';
  static const String recentSearchesBox = 'RECENT_SEARCHES';
  static const String userBox = 'USER_BOX_KEY';
  static const String AppMiscBox = 'APP_MISC_BOX';
  static const String minAppVersionKey = 'MIN_APP_VERSION_KEY';
  static const String likedSongsBox = 'LIKED_SONGS_BOX_KEY';
  static const String recentlyUnLikedSongBox = 'RECENTLY_LIKED_SONG_BOX';
  static const String recentlyLikedSongBox = 'RECENTLY_UNLIKED_SONG_BOX';
  static const String recentlyLikedAlbumBox = 'RECENTLY_LIKED_ALBUM_BOX';
  static const String recentlyUnLikedAlbumBox = 'RECENTLY_UNLIKED_ALBUM_BOX';
  static const String isSubscribedKey = 'IS_SUBSCRIBED_KEY';
  static const String isIapAvailableKey = 'IS_IAP_AVAILABLE_KEY';
  static const String recentlyPurchasedMadeKey =
      'RECENTLY_PURCHASE_WAS_MADE_KEY';
  static const String recentlyPlayerAdShownTimeKey = "RECENTLY_AD_SHOWN_KEY";
  static const String iapUtilBox = "IAP_UTIL_BOX";
  static const String recentlyFollowedPlaylistBox =
      'RECENTLY_FOLLOWED_PLAYLIST_BOX';
  static const String recentlyUnFollowedPlaylistBox =
      'RECENTLY_UNFOLLOWED_PLAYLIST_BOX';
  static const String recentlyFollowedArtistBox =
      'RECENTLY_FOLLOWED_ARTIST_BOX';
  static const String recentlyUnFollowedArtistBox =
      'RECENTLY_UNFOLLOWED_ARTIST_BOX';
  static const String recentlyCartAddedAlbumBox =
      'RECENTLY_CART_ADDED_ALBUM_BOX';
  static const String recentlyCartRemovedAlbumBox =
      'RECENTLY_CART_REMOVED_ALBUM_BOX';
  static const String recentlyCartAddedSongBox = 'RECENTLY_CART_ADDED_SONG_BOX';
  static const String recentlyCartRemovedSongBox =
      'RECENTLY_CART_REMOVED_SONG_BOX';
  static const String recentlyCartAddedPlaylistBox =
      'RECENTLY_CART_ADDED_PLAYLIST_BOX';
  static const String recentlyCartRemovedPlaylistBox =
      'RECENTLY_CART_REMOVED_PLAYLIST_BOX';
  static const String recentlyPurchasedMadeBox = 'RECENTLY_PURCHASE_MADE_BOX';
  static const String settingsBox = 'SETTINGS_BOX';
  static const String subscriptionBox = 'SUBSCRIPTION_BOX';
  static const String recentlyPurchasedSongBox = 'RECENTLY_PURCHASED_SONGS_BOX';
  static const String recentlyPurchasedAlbumBox =
      'RECENTLY_PURCHASED_ALBUMS_BOX';
  static const String recentlyPurchasedPlaylistBox =
      'RECENTLY_PURCHASED_PLAYLISTS_BOX';
  static const String recentlyAdShownBox = 'RECENTLY_AD_SHOWN_BOX';

  //HIVE BOX KEYS
  static const String lastPhoneAuthSentTimeKey = 'LAST_PHONE_AUTH_SENT';
  static const String lastPhoneVerificationSentTimeKey = 'LAST_PHONE_AUTH_TIME';
  static const String loggedInUserKey = 'LOGGED_IN_USER';
  static const String userAccessTokenKey = 'USER_ACCESS_TOKEN';
  static const String userTemporaryNameKey = 'USER_TEMP_NAME';
  static const String userTemporaryColorKey = 'USER_TEMP_COLOR';
  static const String downloadSongQualityKey = 'DOWNLOAD_SONG_QUALITY';
  static const String preferredPaymentMethodKey =
      'PREFERRED_PAYMENT_METHOD_KEY';
  static const String isDataSaverTurnedOnKey = 'DATA_SAVER_KEY';
  static const String preferredCurrencyKey = 'PREFERRED_CURRENCY_KEY';
  static const String appLanguageKey = 'APP_LANGUAGE_KEY';
  static const String isFirstTimeKey = "IS_FIRST_TIME_KEY";
  static const String notificationPermissionShownDateKey =
      "NOTIFICATION_PERMISSION_SHOWN_KEY";
  static const String dialogSubscribeShownDateKey =
      "DIALOG_SUBSCRIPTION_SHOWN_DATE_KEY";
  static const String lastNewVersionShownDateKey =
      "LAST_NEW_VERSION_SHOWN_DATE_KEY";
  static const String lastNewVersionShownVersionKey =
      "LAST_NEW_VERSION_SHOWN_VERSION_KEY";
  static const String newVersionDontAskAgainKey =
      "NEW_VERSION_DONT_ASK_AGAIN_KEY";
  static const String lastToBePurchasedItemTypeKey =
      "LAST_TO_BE_PURCHASED_ITEM_TYPE_KEY";
  static const String lastToBePurchasedIapPurchasedSourcesKey =
      "LAST_TO_BE_PURCHASED_IAP_PURCHASED_SOURCES_KEY";
  static const String lastToBePurchasedItemIdKey =
      "LAST_TO_BE_PURCHASED_ITE_ID_KEY";
  static const String lastToBePurchasedIsFromSelfPageKey =
      "LAST_TO_BE_PURCHASED_IS_FROM_SELF_PAGE_KEY";
  static const String localSubscriptionUserStatusKey =
      "LOCAL_SUBSCRIPTION_USER_STATUS_KEY";
  static const String bottomBarClickedCountKey = "BOTTOM_BAR_CLICKED_COUNT_KEY";

  //system folders
  static const String folderSongs = 'FOLDER_SONGS';
  static const String folderMedia = 'MEDIA_SONGS';

  //OTHER
  static const double previewModeDialogAppIconSize = 40;
  static const double loadingWidgetSize = 100;
  static const int pageSize = 25;
  static const int allAlbumsPageSize = 13;
  static const int allArtistsPageSize = 13;
  static const int allPlaylistsPageSize = 13;
  static const int allSongsPageSize = 15;
  static const int colorChangeAnimationDuration = 600;
  static const int buttonBouncingDurationInMili = 200;
  static const int buttonBouncingDurationInMili2 = 50;
  static const double buttonBouncingScaleFactor = 1.5;
  static const double buttonBouncingScaleFactor2 = 1.5;
  static const double buttonBouncingScaleFactor3 = 1.1;
  static const double lyricFullPageSongItemSize = 75;
  static const double lyricPageCloseButtonSize = 16;
  static const double buttonBouncingScaleFactor4 = 0.2;
  static const String menuBarrierLabel = 'MENU_DIALOG';
  static const double menuHeaderImageSize = 100;
  static const String searchPageDebouncer = 'SEARCH_PAGE_DEBOUNCER';
  static const String bouncingButtonDebouncer = 'BOUNCING_BUTTON_DEBOUNCER';
  static const double createPlaylistImageSize = 180;
  static const String downloaderSendPort = 'downloader_send_port';
  static const String songExtraStr = 'SONG_EXTRA';
  static const String songSyncExtraStr = 'SONG_SYNC_EXTRA';
  static const String userLocalSubscriptionStatusHeader =
      'USER_LOCAL_SUBSCRIPTION_STATUS';
  static const double previewDialogSongItemSize = 60;
  static const int songSyncTimerGapInSeconds = 120;
  static const double appSplashIconSize = 150;
  static const double songVideoItemHeight = 100;
  static const double appAdPreferredMaxHeight = 150;
  static const double appAdPreferredDefaultHeight = 100;
  static const double appAdMaxLength = 10;

//static const String languageRadioGroupValue = 'LANGUAGE_RADIO';
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
  static const double icon_size_40 = 40;
  static const double icon_size_30 = 30;
  static const double icon_size_10 = 10;
  static const double icon_size_6 = 6;
  static const double icon_size_8 = 8;
  static const double icon_size_18 = 18;
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

class AppEnv {
  static const AppType appType = AppType.MEHALEYE;

  static bool isMehaleye() {
    return appType == AppType.MEHALEYE;
  }
}
