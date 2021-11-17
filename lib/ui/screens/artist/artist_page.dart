import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/artist_page_bloc/artist_page_bloc.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/api_response/artist_page_data.dart';
import 'package:mehaley/data/models/artist.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/ui/common/app_error.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/song_item/song_item.dart';
import 'package:mehaley/ui/screens/artist/widgets/item_artist_album.dart';
import 'package:mehaley/ui/screens/artist/widgets/item_artist_featured_playlist.dart';
import 'package:mehaley/ui/screens/artist/widgets/item_similar_artists.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

import 'widgets/artist_sliver_deligates.dart';

class ArtistPage extends StatefulWidget {
  const ArtistPage({Key? key, required this.artistId}) : super(key: key);

  final int artistId;

  @override
  _ArtistPageState createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  @override
  void initState() {
    //FETCH ARTIST PAGE DATA
    BlocProvider.of<ArtistPageBloc>(context).add(
      LoadArtistPageEvent(artistId: widget.artistId),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pagesBgColor,
      body: BlocBuilder<ArtistPageBloc, ArtistPageState>(
        builder: (context, state) {
          if (state is ArtistPageLoadingState) {
            return AppLoading(size: AppValues.loadingWidgetSize);
          }
          if (state is ArtistPageLoadedState) {
            return Scaffold(
              backgroundColor: AppColors.pagesBgColor,
              body: buildArtistPageLoaded(state.artistPageData),
            );
          }
          if (state is ArtistPageLoadingErrorState) {
            return AppError(
              bgWidget: AppLoading(size: AppValues.loadingWidgetSize),
              onRetry: () {
                BlocProvider.of<ArtistPageBloc>(context).add(
                  LoadArtistPageEvent(artistId: widget.artistId),
                );
              },
            );
          }
          return AppLoading(size: AppValues.loadingWidgetSize);
        },
      ),
    );
  }

  NestedScrollView buildArtistPageLoaded(ArtistPageData artistPageData) {
    return NestedScrollView(
      headerSliverBuilder: (context, value) {
        return [
          buildSliverHeader(artistPageData),
          buildSliverPlayShuffleButton(
            artistPageData.popularSongs,
            artistPageData.artist,
          ),
        ];
      },
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: AppMargin.margin_32,
            ),
            buildArtistPopularSongList(
              artistPageData.popularSongs,
              artistPageData.artist,
            ),
            SizedBox(height: AppMargin.margin_16),
            buildArtistLatestSongList(
              artistPageData.newSongs,
              artistPageData.artist,
            ),
            SizedBox(height: AppMargin.margin_38),
            buildArtistAlbumsList(artistPageData.topAlbums),
            SizedBox(height: AppMargin.margin_38),
            buildArtistFeaturingPlaylistList(
              artistPageData.playlistsFeaturingArtists,
              artistPageData.artist,
            ),
            SizedBox(height: AppMargin.margin_38),
            buildSimilarArtistList(artistPageData.similarArtists),
            SizedBox(height: AppMargin.margin_16),
          ],
        ),
      ),
    );
  }

  SliverPersistentHeader buildSliverHeader(ArtistPageData artistPageData) {
    return SliverPersistentHeader(
      delegate: ArtistPageSliverHeaderDelegate(artistPageData: artistPageData),
      floating: true,
      pinned: true,
    );
  }

  SliverPersistentHeader buildSliverPlayShuffleButton(
      List<Song> popularSongs, Artist artist) {
    return SliverPersistentHeader(
      pinned: true,
      delegate:
          ArtistPlayShuffleDelegate(popularSongs: popularSongs, artist: artist),
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocale.of().popular,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_14.sp,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(top: 2),
              //   child: Icon(
              //     Icons.navigate_next,
              //     color: AppColors.lightGrey,
              //     size: AppIconSizes.icon_size_24,
              //   ),
              // )
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocale.of().latestReleases,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_14.sp,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(top: 2),
              //   child: Icon(
              //     Icons.navigate_next,
              //     color: AppColors.lightGrey,
              //     size: AppIconSizes.icon_size_24,
              //   ),
              // )
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
                thumbUrl: AppApi.baseUrl +
                    popularSongs[position].albumArt.imageSmallPath,
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
      padding: const EdgeInsets.only(left: AppPadding.padding_16),
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
                thumbUrl:
                    AppApi.baseUrl + newSongs[position].albumArt.imageSmallPath,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocale.of().topAlbums,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_14.sp,
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(top: 2),
            //   child: Icon(
            //     Icons.navigate_next,
            //     color: AppColors.lightGrey,
            //     size: AppIconSizes.icon_size_24,
            //   ),
            // )
          ],
        ),
        SizedBox(
          height: AppMargin.margin_12,
        ),
      ],
    );
  }

  ListView buildArtistAlbumsList(List<Album> topAlbums) {
    return ListView.builder(
      itemCount: topAlbums.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int position) {
        return Column(
          children: [
            position == 0 ? buildAlbumsHeader() : SizedBox(),
            //SizedBox(height: AppMargin.margin_4),
            ArtistAlbumItem(position: position, album: topAlbums[position]),
            //SizedBox(height: AppMargin.margin_4),
          ],
        );
      },
    );
  }

  Text buildFeaturingArtistPlaylistHeader(Artist artist) {
    return Text(
      '${AppLocale.of().featuring} ${L10nUtil.translateLocale(artist.artistName, context)}',
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: AppFontSizes.font_size_14.sp,
        color: AppColors.black,
        letterSpacing: 0.4,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Container buildArtistFeaturingPlaylistList(
    List<Playlist> playlistsFeaturingArtists,
    Artist artist,
  ) {
    return Container(
      child: Column(
        children: [
          playlistsFeaturingArtists.length > 0
              ? buildFeaturingArtistPlaylistHeader(artist)
              : SizedBox(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  buildPlaylistsFeaturingArtist(playlistsFeaturingArtists),
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

  Center buildOtherArtistsHeader() {
    return Center(
      child: Text(
        AppLocale.of().similarArtist,
        style: TextStyle(
          fontSize: AppFontSizes.font_size_14.sp,
          color: AppColors.black,
          letterSpacing: 0.4,
          fontWeight: FontWeight.w500,
        ),
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
