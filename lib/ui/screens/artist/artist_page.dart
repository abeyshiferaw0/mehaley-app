import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
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
import 'package:mehaley/ui/common/like_follow/artist_sliver_follow_button.dart';
import 'package:mehaley/ui/common/play_shuffle_lg_btn_widget.dart';
import 'package:mehaley/ui/common/sliver_small_text_button.dart';
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
  late ScrollController _scrollController;

  @override
  void initState() {
    //FETCH ARTIST PAGE DATA
    BlocProvider.of<ArtistPageBloc>(context).add(
      LoadArtistPageEvent(artistId: widget.artistId),
    );
    _scrollController = ScrollController();
    _scrollController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  Stack buildArtistPageLoaded(ArtistPageData artistPageData) {
    return Stack(
      clipBehavior: Clip.antiAlias,
      children: [
        NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, value) {
            return [
              buildSliverHeader(artistPageData),
            ];
          },
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(
                right: AppPadding.padding_16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: AppMargin.margin_48,
                  ),
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
          ),
        ),
        buildArtistPlayShareFavButtons(artistPageData),
      ],
    );
  }

  SliverPersistentHeader buildSliverHeader(ArtistPageData artistPageData) {
    return SliverPersistentHeader(
      delegate: ArtistPageSliverHeaderDelegate(artistPageData: artistPageData),
      floating: false,
      pinned: true,
    );
  }

  Positioned buildArtistPlayShareFavButtons(ArtistPageData artistPageData) {
    double top =
        AppValues.artistSliverHeaderHeight - (AppIconSizes.icon_size_40 / 2);
    double diff = AppValues.artistSliverHeaderHeight -
        AppValues.artistSliverHeaderMinHeight;
    if (_scrollController.hasClients) {
      if (_scrollController.offset < diff) {
        top -= _scrollController.offset;
      } else {
        top -= diff;
      }
    }
    return Positioned(
      top: top,
      right: AppMargin.margin_16,
      left: AppMargin.margin_16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ///SHARE BUTTON
          SliverSmallTextButton(
            onTap: () {},
            text: AppLocale.of().share.toUpperCase(),
            textColor: AppColors.black,
            icon: FlutterRemix.share_line,
            iconSize: AppIconSizes.icon_size_20,
            iconColor: AppColors.darkOrange,
          ),

          Expanded(child: SizedBox()),
          artistPageData.popularSongs.length > 0
              ? PlayShuffleLgBtnWidget(
                  onTap: () {
                    //OPEN SHUFFLE SONGS
                    PagesUtilFunctions.openSongShuffled(
                      context: context,
                      startPlaying: true,
                      songs: artistPageData.popularSongs,
                      playingFrom: PlayingFrom(
                        from: AppLocale.of().playingFromArtist,
                        title: L10nUtil.translateLocale(
                            artistPageData.artist.artistName, context),
                        songSyncPlayedFrom: SongSyncPlayedFrom.ARTIST_DETAIL,
                        songSyncPlayedFromId: artistPageData.artist.artistId,
                      ),
                      index: PagesUtilFunctions.getRandomIndex(
                        min: 0,
                        max: artistPageData.popularSongs.length,
                      ),
                    );
                  },
                )
              : artistPageData.newSongs.length > 0
                  ? PlayShuffleLgBtnWidget(
                      onTap: () {
                        //OPEN SHUFFLE SONGS
                        PagesUtilFunctions.openSongShuffled(
                          context: context,
                          startPlaying: true,
                          songs: artistPageData.newSongs,
                          playingFrom: PlayingFrom(
                            from: AppLocale.of().playingFromArtist,
                            title: L10nUtil.translateLocale(
                                artistPageData.artist.artistName, context),
                            songSyncPlayedFrom:
                                SongSyncPlayedFrom.ARTIST_DETAIL,
                            songSyncPlayedFromId:
                                artistPageData.artist.artistId,
                          ),
                          index: PagesUtilFunctions.getRandomIndex(
                            min: 0,
                            max: artistPageData.newSongs.length,
                          ),
                        );
                      },
                    )
                  : SizedBox(),
          Expanded(child: SizedBox()),

          ///FAV BUTTON
          ArtistSliverFollowButton(
            iconSize: AppIconSizes.icon_size_16,
            artistId: artistPageData.artist.artistId,
            isFollowing: artistPageData.artist.isFollowed!,
            iconColor: AppColors.darkOrange,
            askDialog: false,
          ),
        ],
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
            mainAxisAlignment: MainAxisAlignment.start,
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
            mainAxisAlignment: MainAxisAlignment.start,
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
                thumbUrl: popularSongs[position].albumArt.imageSmallPath,
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
                thumbUrl: newSongs[position].albumArt.imageSmallPath,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: AppMargin.margin_16,
            ),
            Text(
              AppLocale.of().popularAlbums,
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
          color: AppColors.black,
          fontWeight: FontWeight.w600,
        ),
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
            AppLocale.of().similarArtist,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_14.sp,
              color: AppColors.black,
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
