import 'dart:io';

import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/app_user.dart';
import 'package:elf_play/data/models/artist.dart';
import 'package:elf_play/data/models/audio_file.dart';
import 'package:elf_play/data/models/bg_video.dart';
import 'package:elf_play/data/models/enums/playlist_created_by.dart';
import 'package:elf_play/data/models/enums/setting_enums/download_song_quality.dart';
import 'package:elf_play/data/models/enums/user_login_type.dart';
import 'package:elf_play/data/models/lyric.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/data/models/remote_image.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/data/models/sync/song_sync.dart';
import 'package:elf_play/data/models/sync/song_sync_played_from.dart';
import 'package:elf_play/data/models/text_lan.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

import 'constants.dart';

class AppHiveBoxes {
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
  }
}
