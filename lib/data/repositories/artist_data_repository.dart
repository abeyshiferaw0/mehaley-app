import 'package:mehaley/data/data_providers/artist_data_provider.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/api_response/artist_page_data.dart';
import 'package:mehaley/data/models/artist.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';

class ArtistDataRepository {
  //INIT PROVIDER FOR API CALL
  final ArtistDataProvider artistDataProvider;

  const ArtistDataRepository({required this.artistDataProvider});

  Future<ArtistPageData> getArtistData(
      int artistId, AppCacheStrategy appCacheStrategy) async {
    final Artist artist;
    final int noOfSong;
    final int noOfAlbum;
    final List<Song> popularSongs;
    final List<Song> newSongs;
    final List<Album> topAlbums;
    final List<Playlist> playlistsFeaturingArtists;
    final List<Artist> similarArtists;

    var response = await artistDataProvider.getRawArtistData(
      artistId,
      appCacheStrategy,
    );

    //PARSE ARTIST
    artist = Artist.fromMap(response.data['artist_data']);

    //PARSE noOfSong
    noOfSong = response.data['no_of_song'];

    //PARSE noOfAlbum
    noOfAlbum = response.data['no_of_album'];

    //PARSE POPULAR SONGS FOR ARTIST
    popularSongs = (response.data['popular_songs'] as List)
        .map((song) => Song.fromMap(song))
        .toList();

    //PARSE ALBUM FOR ARTIST
    topAlbums = (response.data['top_albums'] as List)
        .map((album) => Album.fromMap(album))
        .toList();

    //PARSE PLAYLISTS FOR ARTIST
    playlistsFeaturingArtists =
        (response.data['playlists_featuring_artists'] as List)
            .map((playlistsFeaturingArtists) =>
                Playlist.fromMap(playlistsFeaturingArtists))
            .toList();

    //PARSE ARTISTS FOR ARTIST
    similarArtists = (response.data['similar_artists'] as List)
        .map((artist) => Artist.fromMap(artist))
        .toList();

    //PARSE ARTISTS FOR ARTIST
    newSongs = (response.data['new_songs'] as List)
        .map((song) => Song.fromMap(song))
        .toList();

    ArtistPageData artistPageData = ArtistPageData(
      response: response,
      similarArtists: similarArtists,
      topAlbums: topAlbums,
      popularSongs: popularSongs,
      playlistsFeaturingArtists: playlistsFeaturingArtists,
      artist: artist,
      noOfSong: noOfSong,
      noOfAlbum: noOfAlbum,
      newSongs: newSongs,
    );

    return artistPageData;
  }

  cancelDio() {
    artistDataProvider.cancel();
  }
}
