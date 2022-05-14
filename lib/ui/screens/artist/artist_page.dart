import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/artist_page/artist_all_albums_bloc/artist_all_albums_bloc.dart';
import 'package:mehaley/business_logic/blocs/artist_page/artist_all_playlist_bloc/artist_all_playlists_bloc.dart';
import 'package:mehaley/business_logic/blocs/artist_page/artist_all_songs_bloc/artist_all_songs_bloc.dart';
import 'package:mehaley/business_logic/blocs/artist_page/artist_page_bloc/artist_page_bloc.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/config/app_repositories.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/api_response/artist_page_data.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/ui/common/app_error.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/like_follow/artist_sliver_follow_button.dart';
import 'package:mehaley/ui/common/play_shuffle_lg_btn_widget.dart';
import 'package:mehaley/ui/common/sliver_small_text_button.dart';
import 'package:mehaley/ui/screens/artist/tab_pages/artist_all_albums_tab_page.dart';
import 'package:mehaley/ui/screens/artist/tab_pages/artist_all_playlists_tab_page.dart';
import 'package:mehaley/ui/screens/artist/tab_pages/artist_all_songs_tab_page.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

import 'tab_pages/artist_discover_tab_page.dart';
import 'widgets/artist_sliver_deligates.dart';

class ArtistPage extends StatefulWidget {
  const ArtistPage({Key? key, required this.artistId}) : super(key: key);

  final int artistId;

  @override
  _ArtistPageState createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage>
    with TickerProviderStateMixin, RouteAware {
  ///SCROLL CONTROLLER
  late ScrollController _scrollController;

  ///TAB CONTROLLER
  late TabController _tabController;

  @override
  void initState() {
    ///FETCH ARTIST PAGE DATA
    BlocProvider.of<ArtistPageBloc>(context).add(
      LoadArtistPageEvent(artistId: widget.artistId),
    );
    _scrollController = ScrollController();
    _scrollController.addListener(() => setState(() {}));

    ///INIT TAB CONTROLLER
    _tabController = new TabController(length: 4, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorMapper.getPagesBgColor(),
      body: BlocBuilder<ArtistPageBloc, ArtistPageState>(
        builder: (context, state) {
          if (state is ArtistPageLoadingState) {
            return AppLoading(size: AppValues.loadingWidgetSize);
          }
          if (state is ArtistPageLoadedState) {
            return Scaffold(
              backgroundColor: ColorMapper.getPagesBgColor(),
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
          body: Column(
            children: [
              ///build ARTIST PAGE TABS
              buildTabsContainer(artistPageData),

              ///build ARTIST PAGE TAB BAR VIEW
              Expanded(
                child: buildTabBarView(artistPageData),
              ),
            ],
          ),
        ),
        buildArtistPlayShareFavButtons(artistPageData),
      ],
    );
  }

  TabBarView buildTabBarView(ArtistPageData artistPageData) {
    return TabBarView(
      controller: _tabController,
      children: [
        ///ARTIST DISCOVER TAB PAGE
        ArtistDiscoverTabPage(
          artistPageData: artistPageData,
          onGotoAllSongs: () {
            _tabController.animateTo(1);
          },
          onGotoAllAlbums: () {
            _tabController.animateTo(2);
          },
          onGotoAllPlaylists: () {
            _tabController.animateTo(3);
          },
        ),

        ///ARTIST ALL SONGS TAB PAGE
        BlocProvider(
          create: (context) => ArtistAllSongsBloc(
            artistDataRepository: AppRepositories.artistDataRepository,
          ),
          child: ArtistAllSongsTabPage(
            artist: artistPageData.artist,
          ),
        ),

        ///ARTIST ALL ALBUMS TAB PAGE
        BlocProvider(
          create: (context) => ArtistAllAlbumsBloc(
            artistDataRepository: AppRepositories.artistDataRepository,
          ),
          child: ArtistAllAlbumsTabPage(
            artist: artistPageData.artist,
          ),
        ),

        ///ARTIST ALL PLAYLISTS TAB PAGE
        BlocProvider(
          create: (context) => ArtistAllPlaylistsBloc(
            artistDataRepository: AppRepositories.artistDataRepository,
          ),
          child: ArtistAllPlaylistsTabPage(
            artist: artistPageData.artist,
          ),
        ),
      ],
    );
  }

  Container buildTabsContainer(ArtistPageData artistPageData) {
    return Container(
      padding: EdgeInsets.only(top: AppPadding.padding_14 * 3),
      decoration: BoxDecoration(
        color: ColorMapper.getWhite(),
        boxShadow: [
          BoxShadow(
            color: AppColors.completelyBlack.withOpacity(0.1),
            offset: Offset(0, 3),
            blurRadius: 2,
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        padding: EdgeInsets.only(
          left: AppPadding.padding_16,
        ),
        labelPadding: EdgeInsets.symmetric(
            horizontal: AppPadding.padding_16, vertical: AppPadding.padding_20),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            width: 3.0,
            color: ColorMapper.getDarkOrange(),
          ),
          insets: EdgeInsets.symmetric(horizontal: 0.0),
        ),
        unselectedLabelColor: ColorMapper.getGrey(),
        labelColor: ColorMapper.getBlack(),
        labelStyle: TextStyle(
          fontSize: AppFontSizes.font_size_12.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
        tabs: [
          buildTabItem(
            L10nUtil.translateLocale(artistPageData.artist.artistName, context)
                .toUpperCase(),
          ),
          buildTabItem(
            AppLocale.of().allSongs.toUpperCase(),
          ),
          buildTabItem(
            AppLocale.of().allAlbums.toUpperCase(),
          ),
          buildTabItem(
            AppLocale.of().allPlaylists.toUpperCase(),
          ),
        ],
      ),
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
            textColor: ColorMapper.getBlack(),
            icon: FlutterRemix.share_line,
            iconSize: AppIconSizes.icon_size_20,
            iconColor: ColorMapper.getDarkOrange(),
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
            iconColor: ColorMapper.getDarkOrange(),
            askDialog: false,
          ),
        ],
      ),
    );
  }

  buildTabItem(String text) {
    return Center(
      child: Text(
        text,
      ),
    );
  }
}
