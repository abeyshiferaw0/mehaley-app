import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/api_response/profile_page_data.dart';
import 'package:mehaley/data/models/artist.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/ui/common/song_item/song_item.dart';
import 'package:mehaley/ui/screens/artist/widgets/item_similar_artists.dart';
import 'package:mehaley/ui/screens/category/widgets/item_popular_album.dart';
import 'package:mehaley/ui/screens/category/widgets/item_popular_playlist.dart';
import 'package:mehaley/util/pages_util_functions.dart';

class ProfileLists extends StatelessWidget {
  const ProfileLists(
      {Key? key, required this.profileListTypes, required this.profilePageData})
      : super(key: key);

  final ProfileListTypes profileListTypes;
  final ProfilePageData profilePageData;

  @override
  Widget build(BuildContext context) {
    if (profileListTypes == ProfileListTypes.PURCHASED_SONGS) {
      return buildPurchasedSongsList(profilePageData);
    } else if (profileListTypes == ProfileListTypes.PURCHASED_ALBUMS) {
      return buildPurchasedAlbumsList(profilePageData);
    } else if (profileListTypes == ProfileListTypes.PURCHASED_PLAYLISTS) {
      return buildPurchasedPlaylistsList(profilePageData);
    } else if (profileListTypes == ProfileListTypes.FOLLOWED_ARTISTS) {
      return buildFollowedArtistList(profilePageData);
    } else if (profileListTypes == ProfileListTypes.FOLLOWED_PLAYLISTS) {
      return buildFollowedPlaylistsList(profilePageData);
    } else {
      return SizedBox();
    }
  }

  ListView buildPurchasedSongsList(ProfilePageData profilePageData) {
    return ListView.builder(
      itemCount: profilePageData.boughtSongs.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, position) {
        return Column(
          children: [
            SizedBox(height: AppMargin.margin_8),
            SongItem(
              position: position + 1,
              song: profilePageData.boughtSongs[position],
              isForMyPlaylist: false,
              onPressed: () {
                //OPEN SONG
                PagesUtilFunctions.openSong(
                  context: context,
                  songs: profilePageData.boughtSongs,
                  playingFrom: PlayingFrom(
                    from: AppLocale.of().playingFrom,
                    title: AppLocale.of().purchasedMezmurs,
                    songSyncPlayedFrom: SongSyncPlayedFrom.PROFILE_PAGE,
                    songSyncPlayedFromId: -1,
                  ),
                  startPlaying: true,
                  index: position,
                );
              },
              thumbUrl: AppApi.baseUrl +
                  profilePageData.boughtSongs[position].albumArt.imageSmallPath,
              thumbSize: AppValues.artistSongItemSize,
            ),
            SizedBox(height: AppMargin.margin_8),
          ],
        );
      },
    );
  }

  SingleChildScrollView buildPurchasedAlbumsList(
      ProfilePageData profilePageData) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buildPurchasedAlbumsHorizontal(profilePageData.boughtAlbums),
      ),
    );
  }

  SingleChildScrollView buildPurchasedPlaylistsList(
      ProfilePageData profilePageData) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buildPurchasedPlaylistsHorizontal(
          profilePageData.boughtPlaylists,
        ),
      ),
    );
  }

  SingleChildScrollView buildFollowedArtistList(
      ProfilePageData profilePageData) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buildFollowedArtistHorizontal(
          profilePageData.followedArtists,
        ),
      ),
    );
  }

  SingleChildScrollView buildFollowedPlaylistsList(
      ProfilePageData profilePageData) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: buildPurchasedPlaylistsHorizontal(
            profilePageData.followedPlaylists),
      ),
    );
  }

  List<Widget> buildFollowedArtistHorizontal(List<Artist> artists) {
    final items = <Widget>[];

    if (artists.length > 0) {
      items.add(
        SizedBox(width: AppMargin.margin_16),
      );
      for (int i = 0; i < artists.length; i++) {
        items.add(ItemSimilarArtistsPlaylist(artist: artists[i]));
        items.add(
          SizedBox(width: AppMargin.margin_16),
        );
      }
    }
    return items;
  }

  List<Widget> buildPurchasedPlaylistsHorizontal(List<Playlist> playlists) {
    final items = <Widget>[];

    if (playlists.length > 0) {
      items.add(
        SizedBox(
          width: AppMargin.margin_16,
        ),
      );
      for (int i = 0; i < playlists.length; i++) {
        items.add(
          ItemPopularPlaylist(
            playlist: playlists[i],
          ),
        );
        items.add(
          SizedBox(
            width: AppMargin.margin_16,
          ),
        );
      }
    }

    return items;
  }

  List<Widget> buildPurchasedAlbumsHorizontal(List<Album> albums) {
    final items = <Widget>[];

    if (albums.length > 0) {
      items.add(
        SizedBox(
          width: AppMargin.margin_16,
        ),
      );
      for (int i = 0; i < albums.length; i++) {
        items.add(
          ItemPopularAlbum(
            album: albums[i],
          ),
        );
        items.add(
          SizedBox(
            width: AppMargin.margin_16,
          ),
        );
      }
    }

    return items;
  }
}
