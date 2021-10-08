import 'package:dio/dio.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/data_providers/profile_data_provider.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/api_response/profile_page_data.dart';
import 'package:elf_play/data/models/artist.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/data/models/song.dart';

class ProfileDataRepository {
  //INIT PROVIDER FOR API CALL
  final ProfileDataProvider profileDataProvider;

  const ProfileDataRepository({required this.profileDataProvider});

  Future<ProfilePageData> getProfileData(
      AppCacheStrategy appCacheStrategy) async {
    final int numberOfBoughtItems;
    final int numberOfFollowedItems;
    final int numberOfUserPlaylists;
    final List<Album> boughtAlbums;
    final List<Playlist> boughtPlaylists;
    final List<Song> boughtSongs;

    final List<Artist> followedArtists;
    final List<Playlist> followedPlaylists;

    Response response =
        await profileDataProvider.getRawProfileData(appCacheStrategy);

    //PARSE NUMBER OF
    numberOfBoughtItems = response.data['number_of_bought_items'];
    numberOfFollowedItems = response.data['number_of_followed_items'];
    numberOfUserPlaylists = response.data['number_of_user_playlists'];

    //PARSE PURCHASED ALBUMS
    boughtAlbums = (response.data['bought_albums'] as List)
        .map((album) => Album.fromMap(album['album']))
        .toList();

    //PARSE PURCHASED PLAYLIST
    boughtPlaylists = (response.data['bought_playlists'] as List)
        .map((playlist) => Playlist.fromMap(playlist['playlist']))
        .toList();

    //PARSE PURCHASED SONGS
    boughtSongs = (response.data['bought_songs'] as List)
        .map((song) => Song.fromMap(song['song']))
        .toList();

    //PARSE FOLLOWED ARTISTS
    followedArtists = (response.data['followed_artists'] as List)
        .map((artist) => Artist.fromMap(artist['artist']))
        .toList();

    //PARSE PURCHASED PLAYLIST
    followedPlaylists = (response.data['followed_playlists'] as List)
        .map((playlist) => Playlist.fromMap(playlist['playlist']))
        .toList();

    ProfilePageData profilePageData = ProfilePageData(
      numberOfBoughtItems: numberOfBoughtItems,
      numberOfFollowedItems: numberOfFollowedItems,
      numberOfUserPlaylists: numberOfUserPlaylists,
      boughtAlbums: boughtAlbums,
      boughtPlaylists: boughtPlaylists,
      boughtSongs: boughtSongs,
      followedArtists: followedArtists,
      followedPlaylists: followedPlaylists,
      response: response,
    );

    return profilePageData;
  }

  cancelDio() {
    profileDataProvider.cancel();
  }
}
