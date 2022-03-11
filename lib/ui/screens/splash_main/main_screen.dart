import 'package:app_settings/app_settings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/app_ad_bloc/app_ad_bloc.dart';
import 'package:mehaley/business_logic/blocs/app_start_bloc/app_start_bloc.dart';
import 'package:mehaley/business_logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:mehaley/business_logic/blocs/downloading_song_bloc/downloading_song_bloc.dart';
import 'package:mehaley/business_logic/blocs/library_bloc/library_bloc.dart';
import 'package:mehaley/business_logic/blocs/one_signal_bloc/one_signal_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/in_app_purchases/iap_available_bloc/iap_available_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/in_app_purchases/iap_consumable_purchase_bloc/iap_consumable_purchase_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/in_app_purchases/iap_purchase_action_bloc/iap_purchase_action_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/in_app_purchases/iap_purchase_verification_bloc/iap_purchase_verification_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/in_app_purchases/iap_subscription_purchase_bloc/iap_subscription_purchase_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/in_app_purchases/iap_subscription_restore_bloc/iap_subscription_restore_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/in_app_purchases/iap_subscription_status_bloc/iap_subscription_status_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/yenepay/yenepay_payment_launcher_listener_bloc/yenepay_payment_launcher_listener_bloc.dart';
import 'package:mehaley/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:mehaley/business_logic/blocs/share_bloc/deeplink_listner_bloc/deep_link_listener_bloc.dart';
import 'package:mehaley/business_logic/blocs/share_bloc/deeplink_song_bloc/deep_link_song_bloc.dart';
import 'package:mehaley/business_logic/blocs/sync_bloc/song_listen_recorder_bloc/song_listen_recorder_bloc.dart';
import 'package:mehaley/business_logic/blocs/sync_bloc/song_sync_bloc/song_sync_bloc.dart';
import 'package:mehaley/business_logic/blocs/update_bloc/app_min_version_bloc/app_min_version_bloc.dart';
import 'package:mehaley/business_logic/blocs/update_bloc/newer_version_bloc/newer_version_bloc.dart';
import 'package:mehaley/business_logic/cubits/connectivity_cubit.dart';
import 'package:mehaley/business_logic/cubits/open_profile_page_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/player_state_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/business_logic/cubits/today_holiday_toast_cubit.dart';
import 'package:mehaley/config/app_repositories.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/common/bottom_bar.dart';
import 'package:mehaley/ui/common/dialog/deeplink_share/dialog_open_deeplink_song.dart';
import 'package:mehaley/ui/common/dialog/dialog_ask_notification_permission.dart';
import 'package:mehaley/ui/common/dialog/dialog_new_app_version.dart';
import 'package:mehaley/ui/common/dialog/dialog_subscibe_notification.dart';
import 'package:mehaley/ui/common/dialog/payment/dialog_iap_verfication.dart';
import 'package:mehaley/ui/common/dialog/payment/dialog_purchase_success_transparent.dart';
import 'package:mehaley/ui/common/dialog/payment/dialog_subscription_end.dart';
import 'package:mehaley/ui/common/dialog/payment/dialog_subscription_succes.dart';
import 'package:mehaley/ui/common/mini_player.dart';
import 'package:mehaley/ui/common/no_internet_indicator_small.dart';
import 'package:mehaley/ui/common/today_holiday_toast_widget.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/payment_utils/yenepay_purchase_util.dart';
import 'package:overlay_support/overlay_support.dart';

//INIT ROUTERS
final AppRouter _appRouter = AppRouter();
GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
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
    BlocProvider.of<AppStartBloc>(context).add(
      ShouldShowSubscribeDialogEvent(),
    );
    BlocProvider.of<AppMinVersionBloc>(context).add(
      CheckAppMinVersionEvent(),
    );
    BlocProvider.of<NewerVersionBloc>(context).add(
      ShouldShowNewVersionDialogEvent(),
    );
    BlocProvider.of<IapSubscriptionStatusBloc>(context).add(
      CheckIapSubscriptionEvent(),
    );
    BlocProvider.of<IapAvailableBloc>(context).add(
      CheckIapAvailabilityEvent(),
    );
    BlocProvider.of<AppAdBloc>(context).add(
      LoadAppAdEvent(),
    );
    BlocProvider.of<YenepayPaymentLauncherListenerBloc>(context).add(
      StartYenepayPaymentListenerEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<YenepayPaymentLauncherListenerBloc,
            YenepayPaymentLauncherListenerState>(
          listener: (context, state) {
            if (state is YenepayPaymentLaunchErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.errorRed,
                  isFloating: true,
                  msg: AppLocale.of().purchaseNetworkError,
                  txtColor: AppColors.white,
                ),
              );
            }
            if (state is YenepayPaymentParseErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.blue.withOpacity(0.9),
                  isFloating: true,
                  msg: 'something went wrong!!\ntry refreshing purchased page',
                  txtColor: AppColors.white,
                ),
              );
            }
            if (state is YenepayPaymentStatusState) {
              ///HANDLE YENEPAY PAYMENT COMPLETED SUCCESS
              if (state.yenepayPaymentStatus.yenepayPaymentReturnType ==
                      YenepayPaymentReturnType.COMPLETED ||
                  state.yenepayPaymentStatus.yenepayPaymentReturnType ==
                      YenepayPaymentReturnType.EXISTS ||
                  state.yenepayPaymentStatus.yenepayPaymentReturnType ==
                      YenepayPaymentReturnType.IS_FREE) {
                ///CALL UTIL FUNCTION
                YenepayPurchaseUtil.onSuccess(
                  state.yenepayPaymentStatus,
                  context,
                );
              }

              ///HANDLE YENEPAY PAYMENT CANCELED SUCCESS
              if (state.yenepayPaymentStatus.yenepayPaymentReturnType ==
                  YenepayPaymentReturnType.CANCEL) {
                ///CALL UTIL FUNCTION
                YenepayPurchaseUtil.onCancled(
                  state.yenepayPaymentStatus,
                  context,
                );
              }

              ///HANDLE YENEPAY PAYMENT FAILURE SUCCESS
              if (state.yenepayPaymentStatus.yenepayPaymentReturnType ==
                  YenepayPaymentReturnType.FAILURE) {
                ///CALL UTIL FUNCTION
                YenepayPurchaseUtil.onFailed(
                  state.yenepayPaymentStatus,
                  context,
                );
              }
            }
          },
        ),
        BlocListener<NewerVersionBloc, NewerVersionState>(
          listener: (context, state) {
            if (state is ShouldShowNewVersionLoadedState) {
              if (state.shouldShow) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return DialogNewAppVersion(
                      onUpdateClicked: () {
                        InAppReview.instance.openStoreListing(
                          appStoreId: AppValues.appStoreId,
                        );
                      },
                    );
                  },
                );
              }
            }
          },
        ),
        BlocListener<AppMinVersionBloc, AppMinVersionState>(
          listener: (context, state) {
            if (state is CheckAppMinVersionLoadedState) {
              if (state.isAppBelowMinVersion) {
                Navigator.popAndPushNamed(
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
                if (state.shouldGoToHomePage) {
                  _navigatorKey.currentState!.popAndPushNamed(
                    AppRouterPaths.homeRoute,
                  );
                }
              }
            }
          },
        ),
        BlocListener<DeepLinkListenerBloc, DeepLinkListenerState>(
          listener: (context, state) {
            if (state is DeepLinkErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: ColorMapper.getBlack().withOpacity(0.9),
                  isFloating: true,
                  msg: 'invalid url used!!',
                  txtColor: ColorMapper.getWhite(),
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
        BlocListener<OpenProfilePageCubit, int>(
          listener: (context, state) {
            _navigatorKey.currentState!.pushNamed(
              AppRouterPaths.profileRoute,
            );
          },
        ),
        BlocListener<IapConsumablePurchaseBloc, IapConsumablePurchaseState>(
          listener: (context, state) {
            if (state is IapPurchaseSuccessVerifyState) {
              ///VERIFY IAP PURCHASE DIALOG
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return WillPopScope(
                    onWillPop: () async => false,
                    child: BlocProvider(
                      create: (context) => IapPurchaseVerificationBloc(
                        iapPurchaseRepository:
                            AppRepositories.iapPurchaseRepository,
                      ),
                      child: DialogIapVerification(
                        appPurchasedItemType: state.appPurchasedItemType,
                        itemId: state.itemId,
                        purchasedItem: state.purchasedItem,
                        isFromSelfPage: state.isFromSelfPage,
                        appPurchasedSources: state.appPurchasedSources,
                        purchaseToken: state.purchaseToken,
                      ),
                    ),
                  );
                },
              );
            }
            if (state is IapConsumablePurchaseErrorState) {
              ///SHOW IAP PURCHASE ERROR MESSAGE
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.errorRed,
                  isFloating: false,
                  msg:
                      '${AppLocale.of().somethingWentWrong}\n${AppLocale.of().purchaseCouldNotBeCompleted}',
                  txtColor: ColorMapper.getWhite(),
                ),
              );
            }
            if (state is IapConsumablePurchaseNoInternetState) {
              ///SHOW NO INTERNET MESSAGE
              ScaffoldMessenger.of(context).showSnackBar(
                buildDownloadMsgSnackBar(
                  bgColor: ColorMapper.getWhite(),
                  isFloating: true,
                  msg: AppLocale.of().noInternetMsg,
                  txtColor: AppColors.errorRed,
                  icon: FlutterRemix.wifi_off_line,
                  iconColor: AppColors.errorRed,
                ),
              );
            }
            if (state is IapNotAvailableState) {
              ///SHOW NO INTERNET MESSAGE
              ScaffoldMessenger.of(context).showSnackBar(
                buildDownloadMsgSnackBar(
                  bgColor: AppColors.blue,
                  isFloating: true,
                  msg: AppLocale.of().inAppNotAvlable,
                  txtColor: ColorMapper.getWhite(),
                  icon: FlutterRemix.secure_payment_line,
                  iconColor: ColorMapper.getWhite(),
                ),
              );
            }
          },
        ),
        BlocListener<IapPurchaseActionBloc, IapPurchaseActionState>(
          listener: (context, state) {
            if (state is IapSongPurchaseActionState) {
              if (state.appPurchasedSources ==
                  AppPurchasedSources.MINI_PLAYER_BUY_BUTTON_ON_CLICK) {
                ///STOP PLAYER
                BlocProvider.of<AudioPlayerBloc>(context).add(
                  StopPlayerEvent(),
                );
              }

              ///GO TO ALL PURCHASED SONGS LIBRARY PAGE
              goToLibraryPageWithNavigatorKey(
                _navigatorKey,
                LibraryFromOtherPageTypes.PURCHASED_ALL_SONGS,
              );

              ///SHOW SUCCESS SNACK BAR
              showPurchasedSuccessSnack(
                context,
                AppPurchasedItemType.SONG_PAYMENT,
              );
            }
            if (state is IapAlbumPurchaseActionState) {
              if (state.isFromSelfPage) {
                ///IF FROM SELF(BOUGHT FROM ALBUM PAGE) PAGE
                ///OPEN PURCHASED ALBUM PAGE
                goToAlbumPage(
                  _navigatorKey,
                  state.itemId,
                );
              } else {
                ///IF NOR FROM SELF PAGE
                ///GO TO PURCHASED PLAYLIST PAGE
                goToLibraryPageWithNavigatorKey(
                  _navigatorKey,
                  LibraryFromOtherPageTypes.PURCHASED_ALBUMS,
                );
              }

              ///SHOW SUCCESS SNACK BAR
              showPurchasedSuccessSnack(
                context,
                AppPurchasedItemType.ALBUM_PAYMENT,
              );
            }
            if (state is IapPlaylistPurchaseActionState) {
              if (state.isFromSelfPage) {
                ///IF FROM SELF(BOUGHT FROM PLAYLIST PAGE) PAGE
                ///OPEN PURCHASED PLAYLIST PAGE
                goToPlaylistPage(
                  _navigatorKey,
                  state.itemId,
                );
              } else {
                ///IF NOR FROM SELF PAGE
                ///GO TO PURCHASED PLAYLIST PAGE
                goToLibraryPageWithNavigatorKey(
                  _navigatorKey,
                  LibraryFromOtherPageTypes.PURCHASED_PLAYLISTS,
                );
              }

              ///SHOW SUCCESS SNACK BAR
              showPurchasedSuccessSnack(
                context,
                AppPurchasedItemType.PLAYLIST_PAYMENT,
              );
            }
          },
        ),
        BlocListener<LibraryBloc, LibraryState>(
          listener: (context, state) {
            ///SONG LIKE UNLIKE SUCCESS
            if (state is SongLikeUnlikeSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: ColorMapper.getBlack().withOpacity(0.9),
                  isFloating: true,
                  msg: state.appLikeFollowEvents == AppLikeFollowEvents.LIKE
                      ? AppLocale.of().songAddedToFavorites
                      : AppLocale.of().songRemovedToFavorites,
                  txtColor: ColorMapper.getWhite(),
                ),
              );
            }

            ///SONG LIKE UNLIKE ERROR
            if (state is SongLikeUnlikeErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: ColorMapper.getBlack().withOpacity(0.9),
                  isFloating: false,
                  msg: AppLocale.of().couldntConnect,
                  txtColor: ColorMapper.getWhite(),
                ),
              );
            }

            ///ALBUM LIKE UNLIKE SUCCESS
            if (state is AlbumLikeUnlikeSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: ColorMapper.getBlack().withOpacity(0.9),
                  isFloating: true,
                  msg: state.appLikeFollowEvents == AppLikeFollowEvents.LIKE
                      ? AppLocale.of().albumAddedToFavorites
                      : AppLocale.of().albumRemovedToFavorites,
                  txtColor: ColorMapper.getWhite(),
                ),
              );
            }

            ///ALBUM LIKE UNLIKE ERROR
            if (state is AlbumLikeUnlikeErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: ColorMapper.getBlack().withOpacity(0.9),
                  isFloating: false,
                  msg: AppLocale.of().couldntConnect,
                  txtColor: ColorMapper.getWhite(),
                ),
              );
            }

            ///PLAYLIST FOLLOW UNFOLLOW SUCCESS
            if (state is PlaylistFollowUnFollowSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: ColorMapper.getBlack().withOpacity(0.9),
                  isFloating: true,
                  msg: state.appLikeFollowEvents == AppLikeFollowEvents.FOLLOW
                      ? AppLocale.of().playlistAddedToFavorites
                      : AppLocale.of().playlistRemovedToFavorites,
                  txtColor: ColorMapper.getWhite(),
                ),
              );
            }

            ///PLAYLIST FOLLOW UNFOLLOW ERROR
            if (state is PlaylistFollowUnFollowErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: ColorMapper.getBlack().withOpacity(0.9),
                  isFloating: false,
                  msg: AppLocale.of().couldntConnect,
                  txtColor: ColorMapper.getWhite(),
                ),
              );
            }

            ///ARTISTS FOLLOW UNFOLLOW SUCCESS
            if (state is ArtistFollowUnFollowSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: ColorMapper.getBlack().withOpacity(0.9),
                  isFloating: true,
                  msg: state.appLikeFollowEvents == AppLikeFollowEvents.FOLLOW
                      ? AppLocale.of().artistsAddedToFavorites
                      : AppLocale.of().artistsRemovedToFavorites,
                  txtColor: ColorMapper.getWhite(),
                ),
              );
            }

            ///ARTISTS FOLLOW UNFOLLOW ERROR
            if (state is ArtistFollowUnFollowErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: ColorMapper.getBlack().withOpacity(0.9),
                  isFloating: false,
                  msg: AppLocale.of().couldntConnect,
                  txtColor: ColorMapper.getWhite(),
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
                  txtColor: ColorMapper.getWhite(),
                  icon: FlutterRemix.checkbox_circle_fill,
                  iconColor: ColorMapper.getWhite(),
                ),
              );
            }
            if (state is SongDownloadedNetworkNotAvailableState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildDownloadMsgSnackBar(
                  bgColor: ColorMapper.getWhite(),
                  isFloating: false,
                  msg: AppLocale.of().yourNotConnected,
                  txtColor: AppColors.errorRed,
                  icon: FlutterRemix.wifi_off_line,
                  iconColor: AppColors.errorRed,
                ),
              );
            }
            if (state is SongDownloadedPhoneRootedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildDownloadMsgSnackBar(
                  bgColor: ColorMapper.getWhite(),
                  isFloating: false,
                  msg: 'Download not available for rooted phones',
                  txtColor: AppColors.errorRed,
                  icon: FlutterRemix.lock_2_line,
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
        BlocListener<IapSubscriptionPurchaseBloc, IapSubscriptionPurchaseState>(
          listener: (BuildContext context, state) {
            if (state is IapSubscriptionPurchasedState) {
              if (state.isSubscribed) {
                ///STOP PLAYER
                BlocProvider.of<AudioPlayerBloc>(context).add(
                  StopPlayerEvent(),
                );

                ///SHOW SUBSCRIPTION SUCCESS DIALOG
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return DialogSubscriptionSuccess();
                  },
                );

                ///GO BACK TO HOME PAGE
                _navigatorKey.currentState!.popAndPushNamed(
                  AppRouterPaths.homeRoute,
                );
              }
            }
          },
        ),
        BlocListener<IapSubscriptionRestoreBloc, IapSubscriptionRestoreState>(
          listener: (BuildContext context, state) {
            if (state is IapSubscriptionRestoredState) {
              if (state.isSubscribed) {
                ///STOP PLAYER
                BlocProvider.of<AudioPlayerBloc>(context).add(
                  StopPlayerEvent(),
                );

                ///SHOW SUBSCRIPTION SUCCESS DIALOG
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return DialogSubscriptionSuccess();
                  },
                );

                ///GO BACK TO HOME PAGE
                _navigatorKey.currentState!.popAndPushNamed(
                  AppRouterPaths.homeRoute,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  buildAppSnackBar(
                    bgColor: AppColors.blue,
                    txtColor: ColorMapper.getWhite(),
                    msg: 'No purchases to restore!!',
                    isFloating: true,
                  ),
                );
              }
            }
          },
        ),
        BlocListener<IapSubscriptionStatusBloc, IapSubscriptionStatusState>(
          listener: (BuildContext context, state) {
            if (state is IapSubscriptionStatusCheckedState) {
              if (state.isSubscribedEnded) {
                ///STOP PLAYER
                BlocProvider.of<AudioPlayerBloc>(context).add(
                  StopPlayerEvent(),
                );

                ///SHOW SUBSCRIPTION SUCCESS DIALOG
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return DialogSubscriptionEnd(
                      onGoToSubscriptionPage: () {
                        _navigatorKey.currentState!.pushNamed(
                          AppRouterPaths.subscriptionRoute,
                        );
                      },
                    );
                  },
                );

                ///GO BACK TO HOME PAGE
                _navigatorKey.currentState!.popAndPushNamed(
                  AppRouterPaths.homeRoute,
                );
              }
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
              if (state.itemType == AppItemsType.ARTIST) {
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
        BlocListener<AudioPlayerBloc, AudioPlayerState>(
          listener: (BuildContext context, state) {
            if (state is AudioPlayerErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: ColorMapper.getBlack().withOpacity(0.9),
                  txtColor: ColorMapper.getWhite(),
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

            if (state is ShowSubscribeDialogState) {
              if (state.shouldShow) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return DialogSubscribeNotification(
                      onSubscribeButtonClicked: () {
                        ///OPEN SUBSCRIPTION PAGE
                        _navigatorKey.currentState!.pushNamed(
                          AppRouterPaths.subscriptionRoute,
                        );
                      },
                    );
                  },
                );
              }
            }
          },
        ),
        BlocListener<TodayHolidayToastCubit, bool>(
          listener: (BuildContext context, state) {
            if (state) {
              showSimpleNotification(
                TodayHolidayToastWidget(),
                background: AppColors.transparent,
                contentPadding: EdgeInsets.all(16),
                duration: Duration(seconds: 15),
                elevation: 0,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: ColorMapper.getPagesBgColor(),
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
        body: Stack(
          children: [
            Column(
              children: [
                //MAIN ROUTEING PART OF APP
                Expanded(
                  child: buildWillPopScope(),
                ),

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
            BlocBuilder<IapConsumablePurchaseBloc, IapConsumablePurchaseState>(
              builder: (context, state) {
                if (state is IapConsumablePurchaseStartedState) {
                  return Container(
                    color: ColorMapper.getCompletelyBlack().withOpacity(0.5),
                    child: AppLoading(
                      size: AppValues.loadingWidgetSize,
                    ),
                  );
                }
                return Container();
              },
            )
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

  ///GO TO PURCHASED LIBRARY PAGE
  static void goToLibraryPageWithNavigatorKey(
      GlobalKey<NavigatorState> navigatorKey,
      LibraryFromOtherPageTypes libraryFromOtherPageTypes) {
    ///GO TO LIBRARY PAGE BASED ON => libraryFromOtherPageTypes
    navigatorKey.currentState!.pushNamedAndRemoveUntil(
      AppRouterPaths.libraryRoute,
      ModalRoute.withName(
        AppRouterPaths.homeRoute,
      ),
      arguments: ScreenArguments(
        args: {
          AppValues.isLibraryForOffline: false,
          AppValues.isLibraryForOtherPage: true,
          AppValues.libraryFromOtherPageTypes: libraryFromOtherPageTypes,
        },
      ),
    );
  }

  static void showPurchasedSuccessSnack(
      context, AppPurchasedItemType appPurchasedItemType) {
    String msg = '';
    if (appPurchasedItemType == AppPurchasedItemType.SONG_PAYMENT) {
      msg = AppLocale.of().songPurchased;
    }
    if (appPurchasedItemType == AppPurchasedItemType.ALBUM_PAYMENT) {
      msg = AppLocale.of().albumPurchased;
    }
    if (appPurchasedItemType == AppPurchasedItemType.PLAYLIST_PAYMENT) {
      msg = AppLocale.of().playlistPurchased;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      buildDownloadMsgSnackBar(
        bgColor: AppColors.blue,
        isFloating: true,
        msg: msg,
        txtColor: ColorMapper.getWhite(),
        icon: FlutterRemix.check_fill,
        iconColor: ColorMapper.getWhite(),
      ),
    );
  }

  ///GO TO PURCHASED PLAYLIST PAGE
  static void goToPlaylistPage(GlobalKey<NavigatorState> navigatorKey, itemId) {
    ///GO TO PURCHASED PLAYLIST PAGE
    navigatorKey.currentState!.pushNamedAndRemoveUntil(
      AppRouterPaths.playlistRoute,
      ModalRoute.withName(
        AppRouterPaths.homeRoute,
      ),
      arguments: ScreenArguments(
        args: {'playlistId': itemId},
      ),
    );
  }

  ///GO TO PURCHASED ALBUM PAGE
  static void goToAlbumPage(GlobalKey<NavigatorState> navigatorKey, itemId) {
    ///GO TO PURCHASED PLAYLIST PAGE
    navigatorKey.currentState!.pushNamedAndRemoveUntil(
      AppRouterPaths.albumRoute,
      ModalRoute.withName(
        AppRouterPaths.homeRoute,
      ),
      arguments: ScreenArguments(
        args: {'albumId': itemId},
      ),
    );
  }

  ///SHOW ALBUM PURCHASED SUCCESS TRANSPARENT DIALOG
  static void showAlbumSuccessTransparentDialog(context, Album album) {
    showDialog(
      context: context,
      builder: (context) {
        return DialogPurchaseSuccess(
          title: AppLocale.of().albumPurchased,
          subTitle: L10nUtil.translateLocale(
            album.albumTitle,
            context,
          ),
        );
      },
    );
  }

  ///SHOW PLAYLIST PURCHASED SUCCESS TRANSPARENT DIALOG
  static void showPlaylistSuccessTransparentDialog(context, Playlist playlist) {
    showDialog(
      context: context,
      builder: (context) {
        return DialogPurchaseSuccess(
          title: AppLocale.of().playlistPurchased,
          subTitle: L10nUtil.translateLocale(
            playlist.playlistNameText,
            context,
          ),
        );
      },
    );
  }
}
