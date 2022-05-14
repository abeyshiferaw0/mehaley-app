import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/api_response/artist_page_data.dart';
import 'package:mehaley/data/models/artist.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/ui/common/song_item/song_item.dart';
import 'package:mehaley/ui/screens/artist/widgets/item_artist_album.dart';
import 'package:mehaley/ui/screens/artist/widgets/item_artist_featured_playlist.dart';
import 'package:mehaley/ui/screens/artist/widgets/item_similar_artists.dart';
import 'package:mehaley/ui/screens/artist/widgets/view_all_widget.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class ArtistDiscoverTabPage extends StatefulWidget {
  const ArtistDiscoverTabPage(
      {Key? key,
      required this.artistPageData,
      required this.onGotoAllSongs,
      required this.onGotoAllAlbums,
      required this.onGotoAllPlaylists})
      : super(key: key);

  final ArtistPageData artistPageData;
  final VoidCallback onGotoAllSongs;
  final VoidCallback onGotoAllAlbums;
  final VoidCallback onGotoAllPlaylists;

  @override
  State<ArtistDiscoverTabPage> createState() => _ArtistDiscoverTabPageState();
}

class _ArtistDiscoverTabPageState extends State<ArtistDiscoverTabPage>
    with AutomaticKeepAliveClientMixin<ArtistDiscoverTabPage> {
  ///TO PRESERVE PAGES STATE
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return buildArtistPageLoaded(widget.artistPageData);
  }

  Widget buildArtistPageLoaded(ArtistPageData artistPageData) {
    return Padding(
      padding: const EdgeInsets.only(
        right: AppPadding.padding_16,
        top: AppPadding.padding_8,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildArtistPopularSongList(
              artistPageData.popularSongs,
              artistPageData.artist,
            ),
            buildArtistLatestSongList(
              artistPageData.newSongs,
              artistPageData.artist,
            ),
            buildArtistAlbumsList(artistPageData.popularAlbums),
            buildArtistFeaturingPlaylistList(
              artistPageData.playlistsFeaturingArtists,
              artistPageData.artist,
            ),
            buildSimilarArtistList(artistPageData.similarArtists),
            SizedBox(height: AppMargin.margin_16),
          ],
        ),
      ),
    );
  }

  Container buildPopularSongsHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.padding_16,
        vertical: AppPadding.padding_16,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocale.of().popular,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_14.sp,
                  color: ColorMapper.getBlack(),
                  fontWeight: FontWeight.w600,
                ),
              ),
              ViewAllButton(
                onTap: widget.onGotoAllSongs,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container buildLatestSongsHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.padding_16,
        vertical: AppPadding.padding_16,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocale.of().latestReleases,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_14.sp,
                  color: ColorMapper.getBlack(),
                  fontWeight: FontWeight.w600,
                ),
              ),
              ViewAllButton(
                onTap: widget.onGotoAllSongs,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding buildArtistPopularSongList(List<Song> popularSongs, Artist artist) {
    return Padding(
      padding: const EdgeInsets.only(left: AppPadding.padding_16),
      child: ListView.builder(
        itemCount: popularSongs.length,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int position) {
          return Column(
            children: [
              position == 0 ? buildPopularSongsHeader() : SizedBox(),
              SizedBox(height: AppMargin.margin_8),
              SongItem(
                position: position + 1,
                isForMyPlaylist: false,
                song: popularSongs[position],
                onPressed: () {
                  //OPEN SONG
                  PagesUtilFunctions.openSong(
                    context: context,
                    songs: popularSongs,
                    playingFrom: PlayingFrom(
                      from: AppLocale.of().playingFromArtist,
                      title:
                          L10nUtil.translateLocale(artist.artistName, context),
                      songSyncPlayedFrom: SongSyncPlayedFrom.ARTIST_DETAIL,
                      songSyncPlayedFromId: artist.artistId,
                    ),
                    startPlaying: true,
                    index: position,
                  );
                },
                thumbUrl: popularSongs[position].albumArt.imageMediumPath,
                thumbSize: AppValues.artistSongItemSize,
              ),
              SizedBox(height: AppMargin.margin_8),
            ],
          );
        },
      ),
    );
  }

  Padding buildArtistLatestSongList(List<Song> newSongs, Artist artist) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppPadding.padding_16,
        top: AppPadding.padding_16,
      ),
      child: ListView.builder(
        itemCount: newSongs.length,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int position) {
          return Column(
            children: [
              position == 0 ? buildLatestSongsHeader() : SizedBox(),
              SizedBox(height: AppMargin.margin_8),
              SongItem(
                position: position + 1,
                isForMyPlaylist: false,
                song: newSongs[position],
                onPressed: () {
                  //OPEN SONG
                  PagesUtilFunctions.openSong(
                    context: context,
                    songs: newSongs,
                    playingFrom: PlayingFrom(
                      from: AppLocale.of().playingFromArtist,
                      title:
                          L10nUtil.translateLocale(artist.artistName, context),
                      songSyncPlayedFrom: SongSyncPlayedFrom.ARTIST_DETAIL,
                      songSyncPlayedFromId: artist.artistId,
                    ),
                    startPlaying: true,
                    index: position,
                  );
                },
                thumbUrl: newSongs[position].albumArt.imageMediumPath,
                thumbSize: AppValues.artistSongItemSize,
              ),
              SizedBox(height: AppMargin.margin_8),
            ],
          );
        },
      ),
    );
  }

  Column buildAlbumsHeader() {
    return Column(
      children: [
        SizedBox(height: AppMargin.margin_20),
        Padding(
          padding: const EdgeInsets.only(
            top: AppPadding.padding_12,
            bottom: AppPadding.padding_6,
            left: AppPadding.padding_16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocale.of().popularAlbums,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_14.sp,
                  color: ColorMapper.getBlack(),
                  fontWeight: FontWeight.w600,
                ),
              ),
              ViewAllButton(
                onTap: widget.onGotoAllAlbums,
              ),
            ],
          ),
        ),
        SizedBox(
          height: AppMargin.margin_12,
        ),
      ],
    );
  }

  ListView buildArtistAlbumsList(List<Album> popularAlbums) {
    return ListView.builder(
      itemCount: popularAlbums.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int position) {
        return Column(
          children: [
            position == 0 ? buildAlbumsHeader() : SizedBox(),
            //SizedBox(height: AppMargin.margin_4),
            ArtistAlbumItem(position: position, album: popularAlbums[position]),
            //SizedBox(height: AppMargin.margin_4),
          ],
        );
      },
    );
  }

  Padding buildFeaturingArtistPlaylistHeader(Artist artist) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppPadding.padding_32,
        bottom: AppPadding.padding_6,
        left: AppPadding.padding_16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              '${AppLocale.of().featuring(
                artistName: L10nUtil.translateLocale(
                  artist.artistName,
                  context,
                ),
              )}',
              textAlign: TextAlign.start,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_14.sp,
                color: ColorMapper.getBlack(),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ViewAllButton(
            onTap: widget.onGotoAllPlaylists,
          ),
        ],
      ),
    );
  }

  Container buildArtistFeaturingPlaylistList(
    List<Playlist> playlistsFeaturingArtists,
    Artist artist,
  ) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          playlistsFeaturingArtists.length > 0
              ? buildFeaturingArtistPlaylistHeader(artist)
              : SizedBox(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: buildPlaylistsFeaturingArtist(
                playlistsFeaturingArtists,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildPlaylistsFeaturingArtist(List<Playlist> playlists) {
    final items = <Widget>[];

    if (playlists.length > 0) {
      items.add(
        SizedBox(width: AppMargin.margin_16),
      );
      for (int i = 0; i < playlists.length; i++) {
        items.add(ItemArtistFeaturedPlaylist(playlist: playlists[i]));
        items.add(
          SizedBox(width: AppMargin.margin_16),
        );
      }
    }
    return items;
  }

  Padding buildOtherArtistsHeader() {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppPadding.padding_20 * 2,
        bottom: AppPadding.padding_8,
        left: AppPadding.padding_16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            AppLocale.of().otherArtists,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_14.sp,
              color: ColorMapper.getBlack(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Container buildSimilarArtistList(List<Artist> artists) {
    return Container(
      child: Column(
        children: [
          artists.length > 0 ? buildOtherArtistsHeader() : SizedBox(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: buildSimilarArtist(
                artists,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildSimilarArtist(List<Artist> artists) {
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
}
