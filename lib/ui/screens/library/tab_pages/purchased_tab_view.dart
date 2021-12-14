import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/library_page_bloc/purchased_albums_bloc/purchased_albums_bloc.dart';
import 'package:mehaley/business_logic/blocs/library_page_bloc/purchased_all_songs_bloc/purchased_all_songs_bloc.dart';
import 'package:mehaley/business_logic/blocs/library_page_bloc/purchased_playlist_bloc/purchased_playlist_bloc.dart';
import 'package:mehaley/business_logic/blocs/library_page_bloc/purchased_songs_bloc/purchased_songs_bloc.dart';
import 'package:mehaley/business_logic/cubits/library/library_tab_pages_cubit.dart';
import 'package:mehaley/business_logic/cubits/library/purchased_tab_pages_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/config/app_repositories.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/screens/library/tab_pages/tab_pages/purchased_albums_page.dart';
import 'package:mehaley/ui/screens/library/tab_pages/tab_pages/purchased_all_songs_page.dart';
import 'package:mehaley/ui/screens/library/tab_pages/tab_pages/purchased_playlists_page.dart';
import 'package:mehaley/ui/screens/library/tab_pages/tab_pages/purchased_songs_page.dart';
import 'package:mehaley/ui/screens/library/widgets/library_icon_button.dart';
import 'package:mehaley/util/pages_util_functions.dart';

import '../widgets/library_sub_tab_button.dart';

class PurchasedTabView extends StatefulWidget {
  const PurchasedTabView({Key? key}) : super(key: key);

  @override
  _PurchasedTabViewState createState() => _PurchasedTabViewState();
}

class _PurchasedTabViewState extends State<PurchasedTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  ///
  late List<Song> allPurchasedSongs = [];
  late List<Song> purchasedSongs = [];
  late List<Album> purchaseAlbums = [];
  late List<Playlist> purchasePlaylists = [];
  late PagingController<int, Song>? allSongsPagingController;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PurchasedAllSongsBloc(
            libraryPageDataRepository:
                AppRepositories.libraryPageDataRepository,
          ),
        ),
        BlocProvider(
          create: (context) => PurchasedSongsBloc(
            libraryPageDataRepository:
                AppRepositories.libraryPageDataRepository,
          ),
        ),
        BlocProvider(
          create: (context) => PurchasedAlbumsBloc(
            libraryPageDataRepository:
                AppRepositories.libraryPageDataRepository,
          ),
        ),
        BlocProvider(
          create: (context) => PurchasedPlaylistBloc(
            libraryPageDataRepository:
                AppRepositories.libraryPageDataRepository,
          ),
        )
      ],
      child: Builder(
        builder: (context) {
          return RefreshIndicator(
            onRefresh: () async {
              if (BlocProvider.of<LibraryTabPagesCubit>(context).state == 0) {
                refreshPage(context);
              }
            },
            color: AppColors.darkOrange,
            child: Container(
              height: double.infinity,
              padding: EdgeInsets.only(left: AppPadding.padding_16),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: AppMargin.margin_8),
                    buildSubTabs(),
                    BlocBuilder<PurchasedTabPagesCubit,
                        AppPurchasedPageItemTypes>(
                      builder: (context, state) {
                        if (state == AppPurchasedPageItemTypes.ALL_SONGS) {
                          return PurchasedAllSongsPage(
                            onSongsLoaded: (songs) {
                              allPurchasedSongs.clear();
                              allPurchasedSongs.addAll(songs);
                            },
                            onPagingController:
                                (PagingController<int, Song> controller) {
                              allSongsPagingController = controller;
                            },
                          );
                        } else if (state == AppPurchasedPageItemTypes.SONGS) {
                          return PurchasedSongsPage(
                            onSongsLoaded: (songs) {
                              purchasedSongs.clear();
                              purchasedSongs.addAll(songs);
                            },
                          );
                        } else if (state == AppPurchasedPageItemTypes.ALBUMS) {
                          return PurchasedAlbumsPage(
                            onAlbumsLoaded: (albums) {
                              purchaseAlbums.clear();
                              purchaseAlbums.addAll(albums);
                            },
                          );
                        } else if (state ==
                            AppPurchasedPageItemTypes.PLAYLISTS) {
                          return PurchasedPlaylistsPage(
                            onPlaylistsLoaded: (playlists) {
                              purchasePlaylists.clear();
                              purchasePlaylists.addAll(playlists);
                            },
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  BlocBuilder buildSubTabs() {
    return BlocBuilder<PurchasedTabPagesCubit, AppPurchasedPageItemTypes>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: Row(
                  children: [
                    LibraryPageSubTabButton(
                      text: AppLocale.of().all.toUpperCase(),
                      isSelected: state == AppPurchasedPageItemTypes.ALL_SONGS,
                      onTap: () {
                        if (!(state == AppPurchasedPageItemTypes.ALL_SONGS))
                          BlocProvider.of<PurchasedTabPagesCubit>(context)
                              .changePage(
                            AppPurchasedPageItemTypes.ALL_SONGS,
                          );
                      },
                      hasLeftMargin: false,
                    ),
                    LibraryPageSubTabButton(
                      text: AppLocale.of().mezmurs.toUpperCase(),
                      isSelected: state == AppPurchasedPageItemTypes.SONGS,
                      onTap: () {
                        if (!(state == AppPurchasedPageItemTypes.SONGS))
                          BlocProvider.of<PurchasedTabPagesCubit>(context)
                              .changePage(
                            AppPurchasedPageItemTypes.SONGS,
                          );
                      },
                      hasLeftMargin: true,
                    ),
                    LibraryPageSubTabButton(
                      text: AppLocale.of().albums.toUpperCase(),
                      isSelected: state == AppPurchasedPageItemTypes.ALBUMS,
                      onTap: () {
                        if (!(state == AppPurchasedPageItemTypes.ALBUMS))
                          BlocProvider.of<PurchasedTabPagesCubit>(context)
                              .changePage(
                            AppPurchasedPageItemTypes.ALBUMS,
                          );
                      },
                      hasLeftMargin: true,
                    ),
                    LibraryPageSubTabButton(
                      text: AppLocale.of().playlists.toUpperCase(),
                      isSelected: state == AppPurchasedPageItemTypes.PLAYLISTS,
                      onTap: () {
                        if (!(state == AppPurchasedPageItemTypes.PLAYLISTS))
                          BlocProvider.of<PurchasedTabPagesCubit>(context)
                              .changePage(
                            AppPurchasedPageItemTypes.PLAYLISTS,
                          );
                      },
                      hasLeftMargin: true,
                    )
                  ],
                ),
              ),
            ),
            buildShuffleButton(state),
          ],
        );
      },
    );
  }

  LibraryIconButton buildShuffleButton(
      AppPurchasedPageItemTypes appPurchasedPageItemTypes) {
    return LibraryIconButton(
      onTap: () {
        if (appPurchasedPageItemTypes == AppPurchasedPageItemTypes.ALL_SONGS) {
          if (allPurchasedSongs.length > 0) {
            PagesUtilFunctions.openSongShuffled(
              context: context,
              songs: allPurchasedSongs,
              startPlaying: true,
              playingFrom: PlayingFrom(
                from: AppLocale.of().playingFrom,
                title: AppLocale.of().purchasedMezmurs,
                songSyncPlayedFrom: SongSyncPlayedFrom.PURCHASED_SONG,
                songSyncPlayedFromId: -1,
              ),
              index: PagesUtilFunctions.getRandomIndex(
                min: 0,
                max: allPurchasedSongs.length,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              buildAppSnackBar(
                bgColor: AppColors.black.withOpacity(0.9),
                isFloating: true,
                msg: AppLocale.of().noMezmursToPlay,
                txtColor: AppColors.white,
              ),
            );
          }
        } else if (appPurchasedPageItemTypes ==
            AppPurchasedPageItemTypes.SONGS) {
          if (purchasedSongs.length > 0) {
            PagesUtilFunctions.openSongShuffled(
              context: context,
              songs: purchasedSongs,
              startPlaying: true,
              playingFrom: PlayingFrom(
                from: AppLocale.of().playingFrom,
                title: AppLocale.of().purchasedMezmurs,
                songSyncPlayedFrom: SongSyncPlayedFrom.PURCHASED_SONG,
                songSyncPlayedFromId: -1,
              ),
              index: PagesUtilFunctions.getRandomIndex(
                min: 0,
                max: purchasedSongs.length,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              buildAppSnackBar(
                bgColor: AppColors.black.withOpacity(0.9),
                isFloating: true,
                msg: AppLocale.of().noMezmursToPlay,
                txtColor: AppColors.white,
              ),
            );
          }
        } else if (appPurchasedPageItemTypes ==
            AppPurchasedPageItemTypes.ALBUMS) {
          if (purchaseAlbums.length > 0) {
            int rand = PagesUtilFunctions.getRandomIndex(
              min: 0,
              max: purchaseAlbums.length,
            );
            Navigator.pushNamed(
              context,
              AppRouterPaths.albumRoute,
              arguments: ScreenArguments(
                args: {'albumId': (purchaseAlbums.elementAt(rand)).albumId},
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              buildAppSnackBar(
                bgColor: AppColors.black.withOpacity(0.9),
                isFloating: true,
                msg: AppLocale.of().noAlbumsToSelect,
                txtColor: AppColors.white,
              ),
            );
          }
        } else if (appPurchasedPageItemTypes ==
            AppPurchasedPageItemTypes.PLAYLISTS) {
          if (purchasePlaylists.length > 0) {
            int rand = PagesUtilFunctions.getRandomIndex(
              min: 0,
              max: purchasePlaylists.length,
            );
            Navigator.pushNamed(
              context,
              AppRouterPaths.playlistRoute,
              arguments: ScreenArguments(
                args: {
                  'playlistId': purchasePlaylists.elementAt(rand).playlistId
                },
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              buildAppSnackBar(
                bgColor: AppColors.black.withOpacity(0.9),
                isFloating: true,
                msg: AppLocale.of().noPlaylistToSelect,
                txtColor: AppColors.white,
              ),
            );
          }
        }
      },
      iconColor: AppColors.black,
      icon: FlutterRemix.shuffle_line,
    );
  }

  Future<void> refreshPage(BuildContext builderContext) async {
    AppPurchasedPageItemTypes appPurchasedPageItemTypes =
        BlocProvider.of<PurchasedTabPagesCubit>(builderContext).state;
    if (appPurchasedPageItemTypes == AppPurchasedPageItemTypes.SONGS) {
      BlocProvider.of<PurchasedSongsBloc>(builderContext).add(
        RefreshPurchasedSongsEvent(),
      );
      await BlocProvider.of<PurchasedSongsBloc>(builderContext).stream.first;
    }
    if (appPurchasedPageItemTypes == AppPurchasedPageItemTypes.ALBUMS) {
      BlocProvider.of<PurchasedAlbumsBloc>(builderContext).add(
        RefreshPurchasedAlbumsEvent(),
      );
      await BlocProvider.of<PurchasedAlbumsBloc>(builderContext).stream.first;
    }
    if (appPurchasedPageItemTypes == AppPurchasedPageItemTypes.ALL_SONGS) {
      if (allSongsPagingController != null) {
        allSongsPagingController!.refresh();
      }
    }
    if (appPurchasedPageItemTypes == AppPurchasedPageItemTypes.PLAYLISTS) {
      BlocProvider.of<PurchasedPlaylistBloc>(builderContext).add(
        RefreshPurchasedPlaylistsEvent(),
      );
      await BlocProvider.of<PurchasedPlaylistBloc>(builderContext).stream.first;
    }
    return;
  }
}
