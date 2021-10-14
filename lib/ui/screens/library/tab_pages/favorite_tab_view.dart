import 'package:elf_play/business_logic/blocs/library_page_bloc/favorite_album_bloc/favorite_albums_bloc.dart';
import 'package:elf_play/business_logic/blocs/library_page_bloc/favorite_songs_bloc/favorite_songs_bloc.dart';
import 'package:elf_play/business_logic/cubits/library/favorite_tab_pages_cubit.dart';
import 'package:elf_play/business_logic/cubits/library/library_tab_pages_cubit.dart';
import 'package:elf_play/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:elf_play/config/app_repositories.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/data/models/sync/song_sync_played_from.dart';
import 'package:elf_play/ui/common/app_snack_bar.dart';
import 'package:elf_play/ui/screens/library/tab_pages/tab_pages/favorite_albums_page.dart';
import 'package:elf_play/ui/screens/library/tab_pages/tab_pages/favorite_songs_page.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

import '../widgets/library_icon_button.dart';
import '../widgets/library_sub_tab_button.dart';

class FavoriteTabView extends StatefulWidget {
  const FavoriteTabView({Key? key}) : super(key: key);

  @override
  _FavoriteTabViewState createState() => _FavoriteTabViewState();
}

class _FavoriteTabViewState extends State<FavoriteTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  ///
  late List<Song> favoriteSongs = [];
  late List<Album> favoriteAlbums = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FavoriteTabPagesCubit(),
        ),
        BlocProvider(
          create: (context) => FavoriteSongsBloc(
            libraryPageDataRepository:
                AppRepositories.libraryPageDataRepository,
          ),
        ),
        BlocProvider(
          create: (context) => FavoriteAlbumsBloc(
            libraryPageDataRepository:
                AppRepositories.libraryPageDataRepository,
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          return RefreshIndicator(
            onRefresh: () async {
              if (BlocProvider.of<LibraryTabPagesCubit>(context).state == 4) {
                refreshPage(context);
              }
            },
            color: AppColors.darkGreen,
            edgeOffset: AppMargin.margin_16,
            child: Container(
              color: AppColors.black,
              height: double.infinity,
              padding: EdgeInsets.only(left: AppPadding.padding_16),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: AppMargin.margin_8),
                    buildSubTabs(),
                    BlocBuilder<FavoriteTabPagesCubit,
                        AppFavoritePageItemTypes>(
                      builder: (context, state) {
                        if (state == AppFavoritePageItemTypes.SONGS) {
                          return FavoriteSongsPage(
                            onSongsLoaded: (songs) {
                              favoriteSongs.clear();
                              favoriteSongs.addAll(songs);
                            },
                          );
                        } else if (state == AppFavoritePageItemTypes.ALBUMS) {
                          return FavoriteAlbumsPage(
                            onAlbumsLoaded: (albums) {
                              favoriteAlbums.clear();
                              favoriteAlbums.addAll(albums);
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
    return BlocBuilder<FavoriteTabPagesCubit, AppFavoritePageItemTypes>(
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
                      text: "MEZMURS",
                      isSelected: state == AppFavoritePageItemTypes.SONGS,
                      onTap: () {
                        if (!(state == AppFavoritePageItemTypes.SONGS))
                          BlocProvider.of<FavoriteTabPagesCubit>(context)
                              .changePage(
                            AppFavoritePageItemTypes.SONGS,
                          );
                      },
                      hasLeftMargin: false,
                    ),
                    LibraryPageSubTabButton(
                      text: "ALBUMS",
                      isSelected: state == AppFavoritePageItemTypes.ALBUMS,
                      onTap: () {
                        if (!(state == AppFavoritePageItemTypes.ALBUMS))
                          BlocProvider.of<FavoriteTabPagesCubit>(context)
                              .changePage(
                            AppFavoritePageItemTypes.ALBUMS,
                          );
                      },
                      hasLeftMargin: true,
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<FavoriteTabPagesCubit, AppFavoritePageItemTypes>(
              builder: (context, state) {
                return buildShuffleButton(state);
              },
            ),
          ],
        );
      },
    );
  }

  LibraryIconButton buildShuffleButton(
      AppFavoritePageItemTypes appFavoritePageItemTypes) {
    return LibraryIconButton(
      onTap: () {
        if (appFavoritePageItemTypes == AppFavoritePageItemTypes.SONGS) {
          if (favoriteSongs.length > 0) {
            PagesUtilFunctions.openSongShuffled(
              context: context,
              songs: favoriteSongs,
              startPlaying: true,
              playingFrom: PlayingFrom(
                from: "playing from",
                title: "favorite mezmurs",
                songSyncPlayedFrom: SongSyncPlayedFrom.FAVORITE_SONG,
                songSyncPlayedFromId: -1,
              ),
              index: PagesUtilFunctions.getRandomIndex(
                min: 0,
                max: favoriteSongs.length,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              buildAppSnackBar(
                bgColor: AppColors.blue,
                isFloating: true,
                msg: "no mezmurs to play",
                txtColor: AppColors.white,
              ),
            );
          }
        } else if (appFavoritePageItemTypes ==
            AppFavoritePageItemTypes.ALBUMS) {
          if (favoriteAlbums.length > 0) {
            int rand = PagesUtilFunctions.getRandomIndex(
              min: 0,
              max: favoriteAlbums.length,
            );
            Navigator.pushNamed(
              context,
              AppRouterPaths.albumRoute,
              arguments: ScreenArguments(
                args: {'albumId': (favoriteAlbums.elementAt(rand)).albumId},
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              buildAppSnackBar(
                bgColor: AppColors.blue,
                isFloating: true,
                msg: "no albums to select",
                txtColor: AppColors.white,
              ),
            );
          }
        }
      },
      iconColor: AppColors.white,
      icon: PhosphorIcons.shuffle_light,
    );
  }

  Future<void> refreshPage(BuildContext builderContext) async {
    AppFavoritePageItemTypes appFollowedPageItemTypes =
        BlocProvider.of<FavoriteTabPagesCubit>(builderContext).state;
    if (appFollowedPageItemTypes == AppFavoritePageItemTypes.ALBUMS) {
      BlocProvider.of<FavoriteAlbumsBloc>(builderContext).add(
        RefreshFavoriteAlbumsEvent(),
      );
      await BlocProvider.of<FavoriteAlbumsBloc>(context).stream.first;
    }
    if (appFollowedPageItemTypes == AppFavoritePageItemTypes.SONGS) {
      BlocProvider.of<FavoriteSongsBloc>(builderContext).add(
        RefreshFavoriteSongsEvent(),
      );
      await BlocProvider.of<FavoriteSongsBloc>(context).stream.first;
    }
    return;
  }
}
