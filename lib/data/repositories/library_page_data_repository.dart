import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mehaley/data/data_providers/library_page_data_provider.dart';
import 'package:mehaley/data/models/api_response/library_page_favorite_data.dart';
import 'package:mehaley/data/models/api_response/library_page_following_data.dart';
import 'package:mehaley/data/models/api_response/library_page_purchased_data.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/library_data/favorite_album.dart';
import 'package:mehaley/data/models/library_data/favorite_song.dart';
import 'package:mehaley/data/models/library_data/followed_artist.dart';
import 'package:mehaley/data/models/library_data/followed_playlist.dart';
import 'package:mehaley/data/models/library_data/purchased_album.dart';
import 'package:mehaley/data/models/library_data/purchased_playlist.dart';
import 'package:mehaley/data/models/library_data/purchased_song.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/util/api_util.dart';
import 'package:mehaley/util/download_util.dart';

class LibraryPageDataRepository {
  //INIT PROVIDER FOR API CALL
  final LibraryPageDataProvider libraryPageDataProvider;

  const LibraryPageDataRepository({required this.libraryPageDataProvider});

  Future<PurchasedItemsData> getPurchasedItems(
    AppCacheStrategy appCacheStrategy,
    AppPurchasedPageItemTypes appPurchasedPageItemTypes,
  ) async {
    List<PurchasedSong>? allPurchasedSong;
    List<PurchasedSong>? purchasedSongs;
    List<PurchasedAlbum>? purchasedAlbums;
    List<PurchasedPlaylist>? purchasedPlaylists;

    var response = await libraryPageDataProvider.getPurchasedItems(
        appCacheStrategy, appPurchasedPageItemTypes);

    if (appPurchasedPageItemTypes == AppPurchasedPageItemTypes.ALL_SONGS) {
      //PARSE ALL PURCHASED SONGS
      allPurchasedSong = (response.data['purchased_songs_all'] as List)
          .map((purchasedSong) => PurchasedSong.fromMap(purchasedSong))
          .toList();
    } else if (appPurchasedPageItemTypes == AppPurchasedPageItemTypes.SONGS) {
      //PARSE PURCHASED SONGS
      purchasedSongs = (response.data['purchased_songs'] as List)
          .map((purchasedSong) => PurchasedSong.fromMap(purchasedSong))
          .toList();
    } else if (appPurchasedPageItemTypes == AppPurchasedPageItemTypes.ALBUMS) {
      //PARSE ALL PURCHASED ALBUMS
      purchasedAlbums = (response.data['purchased_albums'] as List)
          .map((purchasedAlbum) => PurchasedAlbum.fromMap(purchasedAlbum))
          .toList();
    } else if (appPurchasedPageItemTypes ==
        AppPurchasedPageItemTypes.PLAYLISTS) {
      //PARSE ALL PURCHASED PLAYLISTS
      purchasedPlaylists = (response.data['purchased_playlists'] as List)
          .map((purchasedPlaylist) =>
              PurchasedPlaylist.fromMap(purchasedPlaylist))
          .toList();
    } else {
      throw 'AppPurchasedPageItemTypes IS INCORRECT';
    }

    return PurchasedItemsData(
      allPurchasedSong: allPurchasedSong,
      response: response,
      purchasedAlbums: purchasedAlbums,
      purchasedPlaylists: purchasedPlaylists,
      purchasedSongs: purchasedSongs,
    );
  }

  Future<List<PurchasedSong>> getPurchasedPaginatedAllSongs(
      int page, int pageSize) async {
    List<PurchasedSong> purchasedSongs;

    var response = await libraryPageDataProvider.getPurchasedPaginatedAllSongs(
        page, pageSize);

    purchasedSongs = (response.data['songs'] as List)
        .map((purchasedSong) => PurchasedSong.fromMap(purchasedSong))
        .toList();

    return purchasedSongs;
  }

  Future<FavoriteItemsData> getFavoriteItems(
    AppCacheStrategy appCacheStrategy,
    AppFavoritePageItemTypes appFavoritePageItemTypes,
  ) async {
    List<FavoriteSong>? favoriteSongs;
    List<FavoriteAlbum>? favoriteAlbums;

    var response = await libraryPageDataProvider.getFavoriteItems(
        appCacheStrategy, appFavoritePageItemTypes);

    if (appFavoritePageItemTypes == AppFavoritePageItemTypes.SONGS) {
      //PARSE FAVORITE SONGS
      favoriteSongs = (response.data['liked_songs'] as List)
          .map((favoriteSong) => FavoriteSong.fromMap(favoriteSong))
          .toList();
    } else if (appFavoritePageItemTypes == AppFavoritePageItemTypes.ALBUMS) {
      //PARSE FAVORITE ALBUMS
      favoriteAlbums = (response.data['albums_liked'] as List)
          .map((favoriteAlbum) => FavoriteAlbum.fromMap(favoriteAlbum))
          .toList();
    } else {
      throw 'AppFavoritePageItemTypes IS INCORRECT';
    }

    return FavoriteItemsData(
      favoriteAlbums: favoriteAlbums,
      favoriteSongs: favoriteSongs,
      response: response,
    );
  }

  Future<FollowingItemsData> getFollowedItems(
    AppCacheStrategy appCacheStrategy,
    AppFollowedPageItemTypes appFollowedPageItemTypes,
  ) async {
    List<FollowedPlaylist>? followedPlaylists;
    List<FollowedArtist>? followedArtists;

    var response = await libraryPageDataProvider.getFollowingItems(
        appCacheStrategy, appFollowedPageItemTypes);

    if (appFollowedPageItemTypes == AppFollowedPageItemTypes.PLAYLISTS) {
      //PARSE FAVORITE PLAYLISTS
      followedPlaylists = (response.data['followed_playlists'] as List)
          .map((favoritePlaylist) => FollowedPlaylist.fromMap(favoritePlaylist))
          .toList();
    } else if (appFollowedPageItemTypes == AppFollowedPageItemTypes.ARTIST) {
      //PARSE FAVORITE ARTISTS
      followedArtists = (response.data['followed_artists'] as List)
          .map((favoriteArtist) => FollowedArtist.fromMap(favoriteArtist))
          .toList();
    } else {
      throw 'AppFollowedPageItemTypes IS INCORRECT';
    }

    return FollowingItemsData(
      followedPlaylists: followedPlaylists,
      followedArtists: followedArtists,
      response: response,
    );
  }

  Future<List<Song>> getOfflineSongs(
    AppLibrarySortTypes appLibrarySortTypes,
  ) async {
    ///GET FAILED DOWNLOADS
    final List<DownloadTask>? tasks =
        await FlutterDownloader.loadTasksWithRawQuery(
      query:
          'SELECT * FROM task WHERE status=${DownloadTaskStatus.complete.value}',
    );

    List<Song> songs = [];
    List<int> timeDownloaded = [];
    if (tasks != null) {
      print('taskstaskstasks => ${tasks.length}');
      if (tasks.length > 0) {
        tasks.forEach((element) {
          songs.add(Song.fromBase64(DownloadUtil.getSongPortion(element.url)));
          timeDownloaded.add(element.timeCreated);
        });
        return ApiUtil.sortDownloadedSongs(
          songs,
          appLibrarySortTypes,
          timeDownloaded,
        );
      }
    }
    return [];
  }

  cancelDio() {
    libraryPageDataProvider.cancel();
  }
}
