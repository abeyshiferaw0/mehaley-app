import 'package:mehaley/data/data_providers/home_data_provider.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/api_response/home_page_data.dart';
import 'package:mehaley/data/models/artist.dart';
import 'package:mehaley/data/models/category.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/group.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';

class HomeDataRepository {
  //INIT PROVIDER FOR API CALL
  final HomeDataProvider homeDataProvider;

  const HomeDataRepository({required this.homeDataProvider});

  Future<HomePageData> getHomeData(AppCacheStrategy appCacheStrategy) async {
    final List<Song> recentlyPlayed;
    final List<Category> categories;
    final List<Group> adminGroups;
    final List<Group> autogeneratedGroups;
    final List<Album> featuredAlbums;
    final List<Song> videoSongs;
    final List<Playlist> featuredPlaylist;
    final List<Song> featuredSongs;

    var response = await homeDataProvider.getRawHomeData(appCacheStrategy);

    //GET RECENTLY PLAYED FROM HIVE
    recentlyPlayed = (response.data['recently_played'] as List)
        .map((song) => Song.fromMap(song["song"]))
        .toList();

    //PARSE CATEGORIES
    categories = (response.data['categories'] as List)
        .map((category) => Category.fromMap(category))
        .toList();

    //PARSE GROUPS FROM ADMIN
    adminGroups = (response.data['admin_groups'] as List)
        .map((group) => Group.fromMap(group, true))
        .toList();

    //PARSE VIDEO SONGS
    videoSongs = (response.data['videos'] as List)
        .map((song) => Song.fromMap(song))
        .toList();

    //PARSE AUTO GENERATED GROUPS
    autogeneratedGroups = (response.data['autogenerated_groups'] as List)
        .map((group) => Group.fromMap(group, false))
        .toList();

    //PARSE FEATURED ALBUMS
    featuredAlbums = (response.data['featured_album'] as List)
        .map((album) => Album.fromMap(album))
        .toList();

    //PARSE FEATURED PLAYLISTS
    featuredPlaylist = (response.data['featured_playlist'] as List)
        .map((playlist) => Playlist.fromMap(playlist))
        .toList();

    //PARSE FEATURED SONGS
    featuredSongs = (response.data['featured_songs'] as List)
        .map((song) => Song.fromMap(song))
        .toList();

    HomePageData homePageData = HomePageData(
      recentlyPlayed: recentlyPlayed,
      categories: categories,
      adminGroups: adminGroups,
      response: response,
      videoSongs: videoSongs,
      featuredAlbums: featuredAlbums,
      featuredPlaylist: featuredPlaylist,
      autogeneratedGroups: autogeneratedGroups,
      featuredSongs: featuredSongs,
    );

    return homePageData;
  }

  Future<List<Song>> getPaginatedAllSongs(int page, int pageSize) async {
    List<Song> paginatedSongs;

    var response = await homeDataProvider.getPaginatedAllSongs(page, pageSize);

    paginatedSongs =
        (response.data as List).map((song) => Song.fromMap(song)).toList();

    return paginatedSongs;
  }

  Future<List<Album>> getPaginatedAllAlbums(int page, int pageSize) async {
    List<Album> paginatedAlbums;

    var response = await homeDataProvider.getPaginatedAllAlbums(page, pageSize);

    paginatedAlbums =
        (response.data as List).map((album) => Album.fromMap(album)).toList();

    return paginatedAlbums;
  }

  Future<List<Artist>> getPaginatedAllArtists(int page, int pageSize) async {
    List<Artist> paginatedArtists;

    var response =
        await homeDataProvider.getPaginatedAllArtists(page, pageSize);

    paginatedArtists = (response.data as List)
        .map((artist) => Artist.fromMap(artist))
        .toList();

    return paginatedArtists;
  }

  Future<List<Playlist>> getPaginatedAllPlaylists(
      int page, int pageSize) async {
    List<Playlist> paginatedPlaylists;

    var response =
        await homeDataProvider.getPaginatedAllPlaylists(page, pageSize);

    paginatedPlaylists = (response.data as List)
        .map((playlist) => Playlist.fromMap(playlist))
        .toList();

    return paginatedPlaylists;
  }

  cancelDio() {
    homeDataProvider.cancel();
  }
}
