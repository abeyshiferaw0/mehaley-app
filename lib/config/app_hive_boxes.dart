import 'dart:io';

import 'package:hive/hive.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/app_user.dart';
import 'package:mehaley/data/models/artist.dart';
import 'package:mehaley/data/models/audio_file.dart';
import 'package:mehaley/data/models/bg_video.dart';
import 'package:mehaley/data/models/enums/app_languages.dart';
import 'package:mehaley/data/models/enums/app_payment_methods.dart';
import 'package:mehaley/data/models/enums/playlist_created_by.dart';
import 'package:mehaley/data/models/enums/setting_enums/app_currency.dart';
import 'package:mehaley/data/models/enums/setting_enums/download_song_quality.dart';
import 'package:mehaley/data/models/enums/user_login_type.dart';
import 'package:mehaley/data/models/lyric.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/remote_image.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/models/sync/song_sync.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/data/models/text_lan.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

import 'constants.dart';

class AppHiveBoxes {
  late Box systemUpdate;
  late Box songSyncBox;
  late Box likedSongsBox;
  late Box userBox;
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
  late Box recentlyCartAddedAlbumBox;
  late Box recentlyCartRemovedAlbumBox;
  late Box recentlyCartAddedSongBox;
  late Box recentlyCartRemovedSongBox;
  late Box recentlyCartAddedPlaylistBox;
  late Box recentlyCartRemovedPlaylistBox;

  AppHiveBoxes._privateConstructor();

  static final AppHiveBoxes _instance = AppHiveBoxes._privateConstructor();

  static AppHiveBoxes get instance => _instance;

  ///OPEN HIVE BOXES
  initHiveBoxes() async {
    ///REGISTER HIVE ADAPTERS
    await initHiveAdapters();

    ///SYSTEM UPDATE BOX
    systemUpdate = await Hive.openBox<String>(
      AppValues.systemUpdateBox,
    );

    ///SONG SYNC OBJECTS
    songSyncBox = await Hive.openBox<SongSync>(
      AppValues.songSyncBox,
    );

    ///RECENTLY CART ADDED ALBUM
    recentlyCartAddedAlbumBox = await Hive.openBox<dynamic>(
      AppValues.recentlyCartAddedAlbumBox,
    );

    ///RECENTLY CART REMOVED ALBUM
    recentlyCartRemovedAlbumBox = await Hive.openBox<dynamic>(
      AppValues.recentlyCartRemovedAlbumBox,
    );

    ///RECENTLY CART ADDED SONG
    recentlyCartAddedSongBox = await Hive.openBox<dynamic>(
      AppValues.recentlyCartAddedSongBox,
    );

    ///RECENTLY CART REMOVED SONG
    recentlyCartRemovedSongBox = await Hive.openBox<dynamic>(
      AppValues.recentlyCartRemovedSongBox,
    );

    ///RECENTLY CART ADDED PLAYLIST
    recentlyCartAddedPlaylistBox = await Hive.openBox<dynamic>(
      AppValues.recentlyCartAddedPlaylistBox,
    );

    ///RECENTLY CART REMOVED PLAYLIST
    recentlyCartRemovedPlaylistBox = await Hive.openBox<dynamic>(
      AppValues.recentlyCartRemovedPlaylistBox,
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

    ///USER DATA BOX
    userBox = await Hive.openBox<dynamic>(
      AppValues.userBox,
    );

    ///RECENT SEARCH BOX
    recentSearchesBox = await Hive.openBox<dynamic>(
      AppValues.recentSearchesBox,
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

    ///CLEAR RECENTLY CART ADDED AND REMOVED ALBUMS
    recentlyCartAddedAlbumBox.clear();
    recentlyCartRemovedAlbumBox.clear();

    ///CLEAR RECENTLY CART ADDED AND REMOVED SONGS
    recentlyCartAddedSongBox.clear();
    recentlyCartRemovedSongBox.clear();

    ///CLEAR RECENTLY CART ADDED AND REMOVED PLAYLISTS
    recentlyCartAddedPlaylistBox.clear();
    recentlyCartRemovedPlaylistBox.clear();

    ///INIT SETTINGS BOX
    initSettingsBox();
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
  }

  Future<void> initHiveAdapters() async {
    //INIT HIVE
    Directory directory = await pathProvider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(SongAdapter());
    Hive.registerAdapter(PlaylistAdapter());
    Hive.registerAdapter(AlbumAdapter());
    Hive.registerAdapter(ArtistAdapter());
    Hive.registerAdapter(AudioFileAdapter());
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
  }
}
