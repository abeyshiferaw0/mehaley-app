import 'dart:io';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:hive/hive.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/app_user.dart';
import 'package:mehaley/data/models/artist.dart';
import 'package:mehaley/data/models/audio_file.dart';
import 'package:mehaley/data/models/bg_video.dart';
import 'package:mehaley/data/models/enums/app_languages.dart';
import 'package:mehaley/data/models/enums/app_payment_methods.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/enums/iap_product_types.dart';
import 'package:mehaley/data/models/enums/playlist_created_by.dart';
import 'package:mehaley/data/models/enums/setting_enums/app_currency.dart';
import 'package:mehaley/data/models/enums/setting_enums/download_song_quality.dart';
import 'package:mehaley/data/models/enums/user_login_type.dart';
import 'package:mehaley/data/models/lyric.dart';
import 'package:mehaley/data/models/payment/iap_product.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/remote_image.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/models/sync/song_sync.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/data/models/text_lan.dart';
import 'package:mehaley/util/hive_duration_adapter.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

import 'constants.dart';

class AppHiveBoxes {
  late Box systemUpdate;
  late Box songSyncBox;
  late Box likedSongsBox;
  late Box userBox;
  late Box appMiscBox;
  late Box settingsBox;
  late Box recentlyLikedSongBox;
  late Box recentlyUnLikedSongBox;
  late Box recentlyLikedAlbumBox;
  late Box recentlyUnLikedAlbumBox;
  late Box recentlyFollowedPlaylistBox;
  late Box recentlyUnFollowedPlaylistBox;
  late Box recentlyFollowedArtistBox;
  late Box recentlyUnFollowedArtistBox;
  late Box recentSearchesBox;
  late Box recentlyPurchasedMadeBox;
  late Box recentlyAdShownBox;
  late Box iapUtilBox;
  late Box subscriptionBox;

  ///RECENTLY PURCHASED ITEMS
  late Box recentlyPurchasedSong;
  late Box recentlyPurchasedAlbum;
  late Box recentlyPurchasedPlaylist;

  AppHiveBoxes._privateConstructor();

  static final AppHiveBoxes _instance = AppHiveBoxes._privateConstructor();

  static AppHiveBoxes get instance => _instance;

  ///OPEN HIVE BOXES
  initHiveBoxes() async {
    ///REGISTER HIVE ADAPTERS
    await initHiveAdapters();

    ///SYSTEM UPDATE BOX
    systemUpdate = await Hive.openBox<dynamic>(
      AppValues.systemUpdateBox,
    );

    ///SONG SYNC OBJECTS
    songSyncBox = await Hive.openBox<SongSync>(
      AppValues.songSyncBox,
    );

    ///RECENTLY LIKED SONG
    recentlyLikedSongBox = await Hive.openBox<dynamic>(
      AppValues.recentlyLikedSongBox,
    );

    ///RECENTLY UNLIKED SONG
    recentlyUnLikedSongBox = await Hive.openBox<dynamic>(
      AppValues.recentlyUnLikedSongBox,
    );

    ///RECENTLY UNLIKED SONG
    settingsBox = await Hive.openBox<dynamic>(
      AppValues.settingsBox,
    );

    ///RECENTLY LIKED ALBUM
    recentlyLikedAlbumBox = await Hive.openBox<dynamic>(
      AppValues.recentlyLikedAlbumBox,
    );

    ///RECENTLY UNLIKED ALBUM
    recentlyUnLikedAlbumBox = await Hive.openBox<dynamic>(
      AppValues.recentlyUnLikedAlbumBox,
    );

    ///RECENTLY FOLLOWED PLAYLIST
    recentlyFollowedPlaylistBox = await Hive.openBox<dynamic>(
      AppValues.recentlyFollowedPlaylistBox,
    );

    ///RECENTLY UN FOLLOWED PLAYLIST
    recentlyUnFollowedPlaylistBox = await Hive.openBox<dynamic>(
      AppValues.recentlyUnFollowedPlaylistBox,
    );

    ///RECENTLY FOLLOWED ARTIST
    recentlyFollowedArtistBox = await Hive.openBox<dynamic>(
      AppValues.recentlyFollowedArtistBox,
    );

    ///RECENTLY UN FOLLOWED ARTIST
    recentlyUnFollowedArtistBox = await Hive.openBox<dynamic>(
      AppValues.recentlyUnFollowedArtistBox,
    );

    ///RECENTLY PURCHASE WAS MADE BOX
    recentlyPurchasedMadeBox = await Hive.openBox<bool>(
      AppValues.recentlyPurchasedMadeBox,
    );

    ///RECENTLY AD WAS SHOWN BOX
    recentlyAdShownBox = await Hive.openBox<dynamic>(
      AppValues.recentlyAdShownBox,
    );

    ///APP SUBSCRIPTION BLOC
    subscriptionBox = await Hive.openBox<dynamic>(
      AppValues.subscriptionBox,
    );

    ///USER DATA BOX
    userBox = await Hive.openBox<dynamic>(
      AppValues.userBox,
    );

    ///APP MISC BOX
    appMiscBox = await Hive.openBox<dynamic>(
      AppValues.AppMiscBox,
    );

    ///RECENT SEARCH BOX
    recentSearchesBox = await Hive.openBox<dynamic>(
      AppValues.recentSearchesBox,
    );

    ///IAP UTIL BOX
    iapUtilBox = await Hive.openBox<dynamic>(
      AppValues.iapUtilBox,
    );

    ///RECENTLY PURCHASED SONGS
    recentlyPurchasedSong = await Hive.openBox<Map<String, dynamic>>(
      AppValues.recentlyPurchasedSongBox,
    );

    ///RECENTLY PURCHASED ALBUMS
    recentlyPurchasedAlbum = await Hive.openBox<Map<String, dynamic>>(
      AppValues.recentlyPurchasedAlbumBox,
    );

    ///RECENTLY PURCHASED PLAYLISTS
    recentlyPurchasedPlaylist = await Hive.openBox<Map<String, dynamic>>(
      AppValues.recentlyPurchasedPlaylistBox,
    );

    ///CLEAR RECENTLY LIKED AND UNLIKED SONGS
    recentlyLikedSongBox.clear();
    recentlyUnLikedSongBox.clear();

    ///CLEAR RECENTLY LIKED AND UNLIKED ALBUMS
    recentlyLikedAlbumBox.clear();
    recentlyUnLikedAlbumBox.clear();

    ///CLEAR RECENTLY FOLLOWED AND UNFOLLOWED PLAYLIST
    recentlyFollowedPlaylistBox.clear();
    recentlyUnFollowedPlaylistBox.clear();

    ///CLEAR RECENTLY FOLLOWED AND UNFOLLOWED ARTIST
    recentlyFollowedArtistBox.clear();
    recentlyUnFollowedArtistBox.clear();

    ///INIT SETTINGS BOX
    initSettingsBox();

    ///todo clear 5 days old recently purchased
  }

  void initSettingsBox() async {
    ///DOWNLOAD SONG QUALITY
    if (!settingsBox.containsKey(AppValues.downloadSongQualityKey)) {
      await settingsBox.put(
        AppValues.downloadSongQualityKey,
        DownloadSongQuality.MEDIUM_QUALITY,
      );
    }

    ///PREFERRED CURRENCY
    if (!settingsBox.containsKey(AppValues.preferredCurrencyKey)) {
      await settingsBox.put(
        AppValues.preferredCurrencyKey,
        AppCurrency.ETB,
      );
    }

    ///PREFERRED PAYMENT METHOD
    if (!settingsBox.containsKey(AppValues.preferredPaymentMethodKey)) {
      await settingsBox.put(
        AppValues.preferredPaymentMethodKey,
        AppPaymentMethods.METHOD_UNK,
      );
    }

    ///DATA SAVER
    if (!settingsBox.containsKey(AppValues.isDataSaverTurnedOnKey)) {
      await settingsBox.put(
        AppValues.isDataSaverTurnedOnKey,
        false,
      );
    }

    ///APP LANGUAGE
    if (!settingsBox.containsKey(AppValues.appLanguageKey)) {
      await settingsBox.put(
        AppValues.appLanguageKey,
        AppLanguage.AMHARIC,
      );
    }

    ///LOCAL SUBSCRIPTION SET TO DEACTIVATED INITIALLY
    if (!subscriptionBox
        .containsKey(AppValues.localSubscriptionUserStatusKey)) {
      await subscriptionBox.put(
        AppValues.localSubscriptionUserStatusKey,
        EnumToString.convertToString(LocalUserSubscriptionStatus.DEACTIVATED),
      );
    }

    ///BOTTOM BAR ITEMS CLICK COUNT
    if (!settingsBox.containsKey(AppValues.bottomBarClickedCountKey)) {
      await settingsBox.put(
        AppValues.bottomBarClickedCountKey,
        0,
      );
    }
  }

  Future<void> initHiveAdapters() async {
    //INIT HIVE
    Directory directory = await pathProvider.getApplicationSupportDirectory();
    Hive.init(directory.path);

    Hive.registerAdapter(SongAdapter());
    Hive.registerAdapter(PlaylistAdapter());
    Hive.registerAdapter(AlbumAdapter());
    Hive.registerAdapter(ArtistAdapter());
    Hive.registerAdapter(BgVideoAdapter());
    Hive.registerAdapter(LyricAdapter());
    Hive.registerAdapter(RemoteImageAdapter());
    Hive.registerAdapter(TextLanAdapter());
    Hive.registerAdapter(PlaylistCreatedByAdapter());
    Hive.registerAdapter(AppUserAdapter());
    Hive.registerAdapter(UserLoginTypeAdapter());
    Hive.registerAdapter(DownloadSongQualityAdapter());
    Hive.registerAdapter(SongSyncAdapter());
    Hive.registerAdapter(SongSyncPlayedFromAdapter());
    Hive.registerAdapter(AppPaymentMethodsAdapter());
    Hive.registerAdapter(AppCurrencyAdapter());
    Hive.registerAdapter(AppLanguageAdapter());
    Hive.registerAdapter(AudioFileAdapter());
    Hive.registerAdapter(IapProductAdapter());
    Hive.registerAdapter(IapProductTypesAdapter());
    Hive.registerAdapter(HiveDurationAdapter());
  }
}
