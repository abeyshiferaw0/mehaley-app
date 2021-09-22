import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:elf_play/business_logic/blocs/downloading_song_bloc/downloading_song_bloc.dart';
import 'package:elf_play/business_logic/blocs/library_bloc/library_bloc.dart';
import 'package:elf_play/business_logic/cubits/connectivity_cubit.dart';
import 'package:elf_play/business_logic/cubits/player_cubits/player_state_cubit.dart';
import 'package:elf_play/business_logic/cubits/search_input_is_searching_cubit.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_snack_bar.dart';
import 'package:elf_play/ui/common/bottom_bar.dart';
import 'package:elf_play/ui/common/mini_player.dart';
import 'package:elf_play/ui/common/no_internet_indicator_small.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

//INIT ROUTERS
final AppRouter _appRouter = AppRouter();
final _navigatorKey = GlobalKey<NavigatorState>();
//INIT ROUTERS

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LibraryBloc, LibraryState>(
          listener: (context, state) {
            if (state is SongLikeUnlikeSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.blue,
                  isFloating: true,
                  msg:
                      "Mezmur ${state.appLikeFollowEvents == AppLikeFollowEvents.LIKE ? "added to favorites" : "removed from favorites"}",
                  txtColor: AppColors.white,
                ),
              );
            }
            if (state is SongLikeUnlikeErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.blue,
                  isFloating: false,
                  msg: "Couldn't connect to the internet",
                  txtColor: AppColors.white,
                ),
              );
            }
            if (state is AlbumLikeUnlikeSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.blue,
                  isFloating: true,
                  msg:
                      "Album ${state.appLikeFollowEvents == AppLikeFollowEvents.LIKE ? "added to favorites" : "removed from favorites"}",
                  txtColor: AppColors.white,
                ),
              );
            }
            if (state is AlbumLikeUnlikeErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.blue,
                  isFloating: false,
                  msg: "Couldn't connect to the internet",
                  txtColor: AppColors.white,
                ),
              );
            }
            if (state is PlaylistFollowUnFollowSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.blue,
                  isFloating: true,
                  msg:
                      "Playlist ${state.appLikeFollowEvents == AppLikeFollowEvents.FOLLOW ? "added to followed" : "removed from favorites"}",
                  txtColor: AppColors.white,
                ),
              );
            }
            if (state is PlaylistFollowUnFollowErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.blue,
                  isFloating: false,
                  msg: "Couldn't connect to the internet",
                  txtColor: AppColors.white,
                ),
              );
            }
            if (state is ArtistFollowUnFollowSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.blue,
                  isFloating: true,
                  msg:
                      "Artist ${state.appLikeFollowEvents == AppLikeFollowEvents.FOLLOW ? "added to followed" : "removed from favorites"}",
                  txtColor: AppColors.white,
                ),
              );
            }
            if (state is ArtistFollowUnFollowErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.blue,
                  isFloating: false,
                  msg: "Couldn't connect to the internet",
                  txtColor: AppColors.white,
                ),
              );
            }
          },
        ),
        BlocListener<DownloadingSongBloc, DownloadingSongState>(
          listener: (context, state) {
            if (state is DownloadingSongsCompletedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildDownloadSuccessSnackBar(
                  bgColor: AppColors.white,
                  isFloating: true,
                  msg: "${state.song!.songName.textAm} Download complete",
                  txtColor: AppColors.black,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        // body: Stack(
        //   children: [
        //     //MAIN ROUTEING PART OF APP
        //     Align(
        //       alignment: Alignment.topCenter,
        //       child: buildWillPopScope(),
        //     ),
        //     //MINI PLAYER SHOWN IF MUSIC IS PLAYING
        //     Align(
        //       alignment: Alignment.bottomCenter,
        //       child: BlocBuilder<PlayerStateCubit, PlayerState>(
        //         builder: (context, state) {
        //           if (state.processingState == ProcessingState.ready ||
        //               state.processingState ==
        //                   ProcessingState.buffering ||
        //               state.processingState == ProcessingState.loading) {
        //             return MiniPlayer();
        //           } else {
        //             return SizedBox();
        //           }
        //         },
        //       ),
        //     ),
        //   ],
        // ),
        body: Column(
          children: [
            //MAIN ROUTEING PART OF APP
            Expanded(child: buildWillPopScope()),
            //NO INTERNET INDICATOR
            BlocBuilder<ConnectivityCubit, ConnectivityResult>(
              builder: (context, state) {
                if (state == ConnectivityResult.none) {
                  return NoInternetIndicatorSmall();
                } else {
                  return SizedBox();
                }
              },
            ),
            //MINI PLAYER SHOWN IF MUSIC IS PLAYING
            BlocBuilder<PlayerStateCubit, PlayerState>(
              builder: (context, state) {
                if (state.processingState == ProcessingState.ready ||
                    state.processingState == ProcessingState.buffering ||
                    state.processingState == ProcessingState.loading) {
                  return MiniPlayer();
                } else {
                  return SizedBox();
                }
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomBar(
          navigatorKey: _navigatorKey,
        ),
      ),
    );
  }

  Builder buildWillPopScope() {
    return Builder(
      builder: (context) {
        return WillPopScope(
          key: GlobalKey(),
          onWillPop: () async {
            //SEARCH PAGE IF SEARCHING INPUT REMOVE TEXT FIELD BEFORE POPPING
            if (BlocProvider.of<SearchInputIsSearchingCubit>(context).state) {
              BlocProvider.of<SearchInputIsSearchingCubit>(context)
                  .changeIsSearching(false);
              return Future<bool>.value(false);
            }
            //DEFAULT BEHAVIOUR
            if (_navigatorKey.currentState!.canPop()) {
              // if (BlocProvider.of<BottomBarCubit>(context).state.length > 1) {
              //   BlocProvider.of<BottomBarCubit>(context).navigatorPop();
              // }
              _navigatorKey.currentState!.pop();
              return false;
            }
            return true;
          },
          child: Navigator(
            key: _navigatorKey,
            initialRoute: AppRouterPaths.homeRoute,
            onGenerateRoute: _appRouter.generateRoute,
            observers: <RouteObserver<ModalRoute<void>>>[
              AppRouterPaths.routeObserver
            ],
          ),
        );
      },
    );
  }
}
