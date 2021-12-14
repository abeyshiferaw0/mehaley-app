import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/app_start_bloc/app_start_bloc.dart';
import 'package:mehaley/business_logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:mehaley/business_logic/blocs/cart_page_bloc/cart_util_bloc/cart_util_bloc.dart';
import 'package:mehaley/business_logic/blocs/downloading_song_bloc/downloading_song_bloc.dart';
import 'package:mehaley/business_logic/blocs/library_bloc/library_bloc.dart';
import 'package:mehaley/business_logic/blocs/one_signal_bloc/one_signal_bloc.dart';
import 'package:mehaley/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:mehaley/business_logic/blocs/share_bloc/deeplink_listner_bloc/deep_link_listener_bloc.dart';
import 'package:mehaley/business_logic/blocs/share_bloc/deeplink_song_bloc/deep_link_song_bloc.dart';
import 'package:mehaley/business_logic/blocs/sync_bloc/song_listen_recorder_bloc/song_listen_recorder_bloc.dart';
import 'package:mehaley/business_logic/blocs/sync_bloc/song_sync_bloc/song_sync_bloc.dart';
import 'package:mehaley/business_logic/blocs/update_bloc/app_min_version_bloc/app_min_version_bloc.dart';
import 'package:mehaley/business_logic/cubits/connectivity_cubit.dart';
import 'package:mehaley/business_logic/cubits/open_profile_page_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/player_state_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/business_logic/cubits/wallet/fresh_wallet_bill_cubit.dart';
import 'package:mehaley/business_logic/cubits/wallet/fresh_wallet_gift_cubit.dart';
import 'package:mehaley/config/app_repositories.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/payment/wallet_gift.dart';
import 'package:mehaley/data/models/payment/webirr_bill.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/common/bottom_bar.dart';
import 'package:mehaley/ui/common/dialog/deeplink_share/dialog_open_deeplink_song.dart';
import 'package:mehaley/ui/common/dialog/dialog_ask_notification_permission.dart';
import 'package:mehaley/ui/common/mini_player.dart';
import 'package:mehaley/ui/common/no_internet_indicator_small.dart';
import 'package:mehaley/ui/common/notifications/fresh_gift_notification_widget.dart';
import 'package:mehaley/ui/screens/wallet/dialogs/dialog_bill_confirmed.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:overlay_support/overlay_support.dart';

//INIT ROUTERS
final AppRouter _appRouter = AppRouter();
final _navigatorKey = GlobalKey<NavigatorState>();
//INIT ROUTERS

// GlobalKey<FormState> globalKey = GlobalKey<FormState>();

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    ///START LISTING SYNC RECORDING
    BlocProvider.of<SongListenRecorderBloc>(context).add(StartRecordEvent());
    BlocProvider.of<SongSyncBloc>(context).add(StartSongSyncEvent());
    BlocProvider.of<DeepLinkListenerBloc>(context).add(
      StartDeepLinkListenerEvent(),
    );
    BlocProvider.of<AppStartBloc>(context).add(
      ShouldShowNotificationPermissionEvent(),
    );
    BlocProvider.of<AppMinVersionBloc>(context).add(
      CheckAppMinVersionEvent(),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppMinVersionBloc, AppMinVersionState>(
          listener: (context, state) {
            if (state is CheckAppMinVersionLoadedState) {
              if (state.isAppBelowMinVersion) {
                Navigator.pushNamed(
                  context,
                  AppRouterPaths.forceUpdate,
                  arguments: ScreenArguments(
                    args: {
                      'newVersion': state.newVersion,
                      'currentVersion': state.currentVersion,
                    },
                  ),
                );
              } else {
                Navigator.pushNamed(
                  context,
                  AppRouterPaths.splashRoute,
                );
              }
            }
          },
        ),
        BlocListener<DeepLinkListenerBloc, DeepLinkListenerState>(
          listener: (context, state) {
            if (state is DeepLinkErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.black.withOpacity(0.9),
                  isFloating: true,
                  msg: 'invalid url used!!',
                  txtColor: AppColors.white,
                ),
              );
            }
            if (state is DeepLinkOpenState) {
              if (state.appShareTypes == AppShareTypes.SONG) {
                ///OPEN SONG FROM DEEPLINK
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return BlocProvider(
                      create: (context) => DeepLinkSongBloc(
                        deeplinkSongRepository:
                            AppRepositories.deeplinkSongRepository,
                      ),
                      child: DialogDeeplinkSong(
                        songId: state.itemId,
                        onSongFetched: (Song song) {
                          PagesUtilFunctions.openSong(
                            context: context,
                            songs: [song],
                            startPlaying: true,
                            playingFrom: PlayingFrom(
                              songSyncPlayedFrom:
                                  SongSyncPlayedFrom.SHARED_SONG,
                              songSyncPlayedFromId: -1,
                              from: AppLocale.of().sharedMezmur,
                              title: L10nUtil.translateLocale(
                                song.songName,
                                context,
                              ),
                            ),
                            index: 0,
                          );
                        },
                      ),
                    );
                  },
                );
              }
              if (state.appShareTypes == AppShareTypes.PLAYLIST) {
                ///OPEN PLAYLIST FROM DEEPLINK
                _navigatorKey.currentState!.pushNamed(
                  AppRouterPaths.playlistRoute,
                  arguments: ScreenArguments(
                    args: {'playlistId': state.itemId},
                  ),
                );
              }
              if (state.appShareTypes == AppShareTypes.ALBUM) {
                ///OPEN ALBUM FROM DEEPLINK
                _navigatorKey.currentState!.pushNamed(
                  AppRouterPaths.albumRoute,
                  arguments: ScreenArguments(
                    args: {'albumId': state.itemId},
                  ),
                );
              }
              if (state.appShareTypes == AppShareTypes.ARTIST) {
                ///OPEN ARTIST FROM DEEPLINK
                _navigatorKey.currentState!.pushNamed(
                  AppRouterPaths.artistRoute,
                  arguments: ScreenArguments(
                    args: {'artistId': state.itemId},
                  ),
                );
              }
            }
          },
        ),
        BlocListener<OpenProfilePageCubit, bool>(
          listener: (context, state) {
            if (state) {
              _navigatorKey.currentState!.pushNamed(
                AppRouterPaths.profileRoute,
              );
            }
          },
        ),
        BlocListener<FreshWalletBillCubit, WebirrBill?>(
          listener: (context, state) {
            if (state != null) {
              ///SHOW FRESH BILL DIALOG
              showDialog(
                context: context,
                builder: (context) {
                  return DialogBillConfirmed(
                    freshBill: state,
                  );
                },
              );
            }
          },
        ),
        BlocListener<FreshWalletGiftCubit, List<WalletGift>?>(
          listener: (context, state) async {
            if (state != null) {
              ///SHOW FRESH GIFT NOTIFICATIONS
              if (state.length > 0) {
                final random = Random();
                for (var i = 0; i < state.length; i++) {
                  await Future.delayed(
                    Duration(milliseconds: 300 + random.nextInt(300)),
                  );
                  showSimpleNotification(
                    FreshGiftNotificationWidget(
                      freshWalletGift: state[i],
                    ),
                    background: AppColors.pagesBgColor,
                    duration: Duration(
                      seconds: 4 * (state.length - i),
                    ),
                  );
                }
              }
            }
          },
        ),
        BlocListener<LibraryBloc, LibraryState>(
          listener: (context, state) {
            ///SONG LIKE UNLIKE SUCCESS
            if (state is SongLikeUnlikeSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.black.withOpacity(0.9),
                  isFloating: true,
                  msg: state.appLikeFollowEvents == AppLikeFollowEvents.LIKE
                      ? AppLocale.of().songAddedToFavorites
                      : AppLocale.of().songRemovedToFavorites,
                  txtColor: AppColors.white,
                ),
              );
            }

            ///SONG LIKE UNLIKE ERROR
            if (state is SongLikeUnlikeErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.black.withOpacity(0.9),
                  isFloating: false,
                  msg: AppLocale.of().couldntConnect,
                  txtColor: AppColors.white,
                ),
              );
            }

            ///ALBUM LIKE UNLIKE SUCCESS
            if (state is AlbumLikeUnlikeSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.black.withOpacity(0.9),
                  isFloating: true,
                  msg: state.appLikeFollowEvents == AppLikeFollowEvents.LIKE
                      ? AppLocale.of().albumAddedToFavorites
                      : AppLocale.of().albumRemovedToFavorites,
                  txtColor: AppColors.white,
                ),
              );
            }

            ///ALBUM LIKE UNLIKE ERROR
            if (state is AlbumLikeUnlikeErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.black.withOpacity(0.9),
                  isFloating: false,
                  msg: AppLocale.of().couldntConnect,
                  txtColor: AppColors.white,
                ),
              );
            }

            ///PLAYLIST FOLLOW UNFOLLOW SUCCESS
            if (state is PlaylistFollowUnFollowSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.black.withOpacity(0.9),
                  isFloating: true,
                  msg: state.appLikeFollowEvents == AppLikeFollowEvents.FOLLOW
                      ? AppLocale.of().playlistAddedToFavorites
                      : AppLocale.of().playlistRemovedToFavorites,
                  txtColor: AppColors.white,
                ),
              );
            }

            ///PLAYLIST FOLLOW UNFOLLOW ERROR
            if (state is PlaylistFollowUnFollowErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.black.withOpacity(0.9),
                  isFloating: false,
                  msg: AppLocale.of().couldntConnect,
                  txtColor: AppColors.white,
                ),
              );
            }

            ///ARTISTS FOLLOW UNFOLLOW SUCCESS
            if (state is ArtistFollowUnFollowSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.black.withOpacity(0.9),
                  isFloating: true,
                  msg: state.appLikeFollowEvents == AppLikeFollowEvents.FOLLOW
                      ? AppLocale.of().artistsAddedToFavorites
                      : AppLocale.of().artistsRemovedToFavorites,
                  txtColor: AppColors.white,
                ),
              );
            }

            ///ARTISTS FOLLOW UNFOLLOW ERROR
            if (state is ArtistFollowUnFollowErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.black.withOpacity(0.9),
                  isFloating: false,
                  msg: AppLocale.of().couldntConnect,
                  txtColor: AppColors.white,
                ),
              );
            }
          },
        ),
        BlocListener<CartUtilBloc, CartUtilState>(
          listener: (context, state) {
            ///ALBUM CART ADD REMOVE SUCCESS
            if (state is CartUtilAlbumAddedSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.black.withOpacity(0.9),
                  isFloating: true,
                  msg:
                      state.appCartAddRemoveEvents == AppCartAddRemoveEvents.ADD
                          ? AppLocale.of().albumAddedToCart
                          : AppLocale.of().albumRemovedToCart,
                  txtColor: AppColors.white,
                ),
              );
            }

            ///ALBUM CART ADD REMOVE ERROR
            if (state is CartUtilAlbumAddingErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.black.withOpacity(0.9),
                  isFloating: false,
                  msg: AppLocale.of().couldntConnect,
                  txtColor: AppColors.white,
                ),
              );
            }

            ///SONG CART ADD REMOVE SUCCESS
            if (state is CartUtilSongAddedSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.black.withOpacity(0.9),
                  isFloating: true,
                  msg:
                      state.appCartAddRemoveEvents == AppCartAddRemoveEvents.ADD
                          ? AppLocale.of().songAddedToCart
                          : AppLocale.of().songRemovedToCart,
                  txtColor: AppColors.white,
                ),
              );
            }

            ///SONG CART ADD REMOVE ERROR
            if (state is CartUtilSongAddingErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.black.withOpacity(0.9),
                  isFloating: false,
                  msg: AppLocale.of().couldntConnect,
                  txtColor: AppColors.white,
                ),
              );
            }

            ///PLAYLIST CART ADD REMOVE SUCCESS
            if (state is CartUtilPlaylistAddedSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.black.withOpacity(0.9),
                  isFloating: true,
                  msg:
                      state.appCartAddRemoveEvents == AppCartAddRemoveEvents.ADD
                          ? AppLocale.of().playlistAddedToCart
                          : AppLocale.of().playlistRemovedToCart,
                  txtColor: AppColors.white,
                ),
              );
            }

            ///PLAYLIST CART ADD REMOVE ERROR
            if (state is CartUtilPlaylistAddingErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.black.withOpacity(0.9),
                  isFloating: false,
                  msg: AppLocale.of().couldntConnect,
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
                buildDownloadMsgSnackBar(
                    bgColor: AppColors.blue,
                    isFloating: true,
                    msg: AppLocale.of().downloadComplete(
                      songName: L10nUtil.translateLocale(
                        state.song!.songName,
                        context,
                      ),
                    ),
                    txtColor: AppColors.white,
                    icon: FlutterRemix.checkbox_circle_fill,
                    iconColor: AppColors.white),
              );
            }
            if (state is SongDownloadedNetworkNotAvailableState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildDownloadMsgSnackBar(
                  bgColor: AppColors.darkGrey,
                  isFloating: false,
                  msg: AppLocale.of().yourNotConnected,
                  txtColor: AppColors.white,
                  icon: FlutterRemix.wifi_off_line,
                  iconColor: AppColors.errorRed,
                ),
              );
            }
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (BuildContext context, state) {
            if (state is AuthLoggedOutState) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRouterPaths.signUp,
                (Route<dynamic> route) => false,
              );
            }
          },
        ),
        BlocListener<OneSignalBloc, OneSignalState>(
          listener: (BuildContext context, state) {
            if (state is NotificationClickedState) {
              if (state.itemType == AppItemsType.PLAYLIST) {
                _navigatorKey.currentState!.pushNamed(
                  AppRouterPaths.playlistRoute,
                  arguments: ScreenArguments(
                    args: {
                      'playlistId': state.itemId,
                    },
                  ),
                );
              }
              if (state.itemType == AppItemsType.ALBUM) {
                _navigatorKey.currentState!.pushNamed(
                  AppRouterPaths.albumRoute,
                  arguments: ScreenArguments(
                    args: {'albumId': state.itemId},
                  ),
                );
              }
            }
          },
        ),
        BlocListener<AudioPlayerBloc, AudioPlayerState>(
          listener: (BuildContext context, state) {
            if (state is AudioPlayerErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.black.withOpacity(0.9),
                  txtColor: AppColors.white,
                  msg: state.msg,
                  isFloating: false,
                ),
              );
            }
          },
        ),
        BlocListener<AppStartBloc, AppStartState>(
          listener: (BuildContext context, state) {
            if (state is ShowNotificationPermissionState) {
              if (state.shouldShow) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return DialogAskNotificationPermission(
                      onGoToSetting: () {
                        ///GO TO APP SETTINGS TO ALLOW PERMISSIONS
                        AppSettings.openAppSettings();
                      },
                    );
                  },
                );
              }
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.pagesBgColor,
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
        //               state.processingState == ProcessingState.buffering ||
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

            ///MINI PLAYER SHOWN IF MUSIC IS PLAYING
            BlocBuilder<PlayerStateCubit, PlayerState>(
              builder: (context, state) {
                if (state.processingState == ProcessingState.ready ||
                    state.processingState == ProcessingState.buffering ||
                    state.processingState == ProcessingState.loading) {
                  return MiniPlayer(
                    navigatorKey: _navigatorKey,
                  );
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
          onWillPop: () async {
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
