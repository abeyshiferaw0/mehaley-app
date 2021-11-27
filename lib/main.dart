import 'dart:isolate';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mehaley/business_logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:mehaley/business_logic/blocs/downloading_song_bloc/downloading_song_bloc.dart';
import 'package:mehaley/business_logic/blocs/library_bloc/library_bloc.dart';
import 'package:mehaley/business_logic/blocs/song_menu_bloc/song_menu_bloc.dart';
import 'package:mehaley/business_logic/cubits/app_user_widgets_cubit.dart';
import 'package:mehaley/business_logic/cubits/bottom_bar_cubit/bottom_bar_cubit.dart';
import 'package:mehaley/business_logic/cubits/connectivity_cubit.dart';
import 'package:mehaley/config/app_repositories.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/strings.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/app_languages.dart';
import 'package:mehaley/ui/screens/auth/sign_up_page.dart';
import 'package:mehaley/ui/screens/auth/verify_phone/verify_phone_page_one.dart';
import 'package:mehaley/ui/screens/auth/verify_phone/verify_phone_page_two.dart';
import 'package:mehaley/ui/screens/splash_main/main_screen.dart';
import 'package:mehaley/ui/screens/splash_main/splash_page.dart';
import 'package:mehaley/util/app_bloc_deligate.dart';
import 'package:mehaley/util/download_util.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sizer/sizer.dart';

import 'business_logic/blocs/app_start_bloc/app_start_bloc.dart';
import 'business_logic/blocs/cart_page_bloc/cart_util_bloc/cart_util_bloc.dart';
import 'business_logic/blocs/library_page_bloc/my_playlist_bloc/my_playlist_bloc.dart';
import 'business_logic/blocs/one_signal_bloc/one_signal_bloc.dart';
import 'business_logic/blocs/page_dominant_color_bloc/pages_dominant_color_bloc.dart';
import 'business_logic/blocs/payment_blocs/preferred_payment_method_bloc/preferred_payment_method_bloc.dart';
import 'business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'business_logic/blocs/share_bloc/share_bloc.dart';
import 'business_logic/blocs/sync_bloc/song_listen_recorder_bloc/song_listen_recorder_bloc.dart';
import 'business_logic/blocs/sync_bloc/song_sync_bloc/song_sync_bloc.dart';
import 'business_logic/cubits/bottom_bar_cubit/bottom_bar_cart_cubit.dart';
import 'business_logic/cubits/bottom_bar_cubit/bottom_bar_home_cubit.dart';
import 'business_logic/cubits/bottom_bar_cubit/bottom_bar_library_cubit.dart';
import 'business_logic/cubits/bottom_bar_cubit/bottom_bar_search_cubit.dart';
import 'business_logic/cubits/currency_cubit.dart';
import 'business_logic/cubits/localization_cubit.dart';
import 'business_logic/cubits/player_cubits/current_playing_cubit.dart';
import 'business_logic/cubits/player_cubits/loop_cubit.dart';
import 'business_logic/cubits/player_cubits/muted_cubit.dart';
import 'business_logic/cubits/player_cubits/play_pause_cubit.dart';
import 'business_logic/cubits/player_cubits/player_queue_cubit.dart';
import 'business_logic/cubits/player_cubits/player_state_cubit.dart';
import 'business_logic/cubits/player_cubits/shuffle_cubit.dart';
import 'business_logic/cubits/player_cubits/song_buffered_position_cubit.dart';
import 'business_logic/cubits/player_cubits/song_duration_cubit.dart';
import 'business_logic/cubits/player_cubits/song_position_cubit.dart';
import 'business_logic/cubits/player_playing_from_cubit.dart';
import 'config/app_hive_boxes.dart';

void main() async {
  //BLOC TRANSITION OBSERVER AND LOGGER
  Bloc.observer = AppBlocDelegate();
  //JUST AUDIO BACKGROUND INIT
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Mehaleye',
    androidNotificationOngoing: false,
    notificationColor: AppColors.darkOrange,
  );

  ///INIT HIVE BOXES
  await AppHiveBoxes.instance.initHiveBoxes();

  ///INITIALIZE FIREBASE APP
  await Firebase.initializeApp();

  ///INITIALIZE DOWNLOADER
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );

  ///INIT ONE SIGNAl
  OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.none);
  OneSignal.shared.setAppId(AppStrings.oneSignalId);
  // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });

  ///RUN APP
  // runApp(
  //   Sizer(
  //     builder: (context, orientation, deviceType) {
  //       return TestWidget();
  //     },
  //   ),
  // );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiBlocProvider(
          providers: [
            //ALL BLOC AND CUBIT PROVIDER
            BlocProvider<AppStartBloc>(
              create: (context) => AppStartBloc(),
            ),
            BlocProvider<AppUserWidgetsCubit>(
              create: (context) => AppUserWidgetsCubit(),
            ),
            BlocProvider<AuthBloc>(
              create: (context) => AuthBloc(
                firebaseAuth: FirebaseAuth.instance,
                authRepository: AppRepositories.authRepository,
              ),
            ),
            BlocProvider<ConnectivityCubit>(
              create: (context) => ConnectivityCubit(
                connectivity: Connectivity(),
              ),
            ),
            BlocProvider<AudioPlayerBloc>(
              create: (context) => AudioPlayerBloc(
                audioPlayer: AudioPlayer(),
              ),
            ),
            BlocProvider<PlayerPagePlayingFromCubit>(
              create: (context) => PlayerPagePlayingFromCubit(),
            ),
            BlocProvider<IsMutedCubit>(
              create: (context) => IsMutedCubit(
                audioPlayerBloc: BlocProvider.of<AudioPlayerBloc>(context),
              ),
            ),
            BlocProvider<PlayPauseCubit>(
              create: (context) => PlayPauseCubit(
                audioPlayerBloc: BlocProvider.of<AudioPlayerBloc>(context),
              ),
            ),
            BlocProvider<PlayerStateCubit>(
              create: (context) => PlayerStateCubit(
                audioPlayerBloc: BlocProvider.of<AudioPlayerBloc>(context),
              ),
            ),
            BlocProvider<ShuffleCubit>(
              create: (context) => ShuffleCubit(
                audioPlayerBloc: BlocProvider.of<AudioPlayerBloc>(context),
              ),
            ),
            BlocProvider<LoopCubit>(
              create: (context) => LoopCubit(
                audioPlayerBloc: BlocProvider.of<AudioPlayerBloc>(context),
              ),
            ),
            BlocProvider<SongPositionCubit>(
              create: (context) => SongPositionCubit(
                audioPlayerBloc: BlocProvider.of<AudioPlayerBloc>(context),
              ),
            ),
            BlocProvider<SongBufferedCubit>(
              create: (context) => SongBufferedCubit(
                audioPlayerBloc: BlocProvider.of<AudioPlayerBloc>(context),
              ),
            ),
            BlocProvider<SongDurationCubit>(
              create: (context) => SongDurationCubit(
                audioPlayerBloc: BlocProvider.of<AudioPlayerBloc>(context),
              ),
            ),
            BlocProvider<PreferredPaymentMethodBloc>(
              create: (context) => PreferredPaymentMethodBloc(
                paymentRepository: AppRepositories.paymentRepository,
              ),
            ),
            BlocProvider(
              create: (context) => OneSignalBloc(),
            ),
            BlocProvider(
              create: (context) => CartUtilBloc(
                cartRepository: AppRepositories.cartRepository,
              ),
            ),
            // BlocProvider<PlayerVideoModeCubit>(
            //   create: (context) => PlayerVideoModeCubit(
            //     audioPlayerBloc: BlocProvider.of<AudioPlayerBloc>(context),
            //   ),
            // ),
            // BlocProvider<PlayerVideoModeRemoveControlsCubit>(
            //   create: (context) => PlayerVideoModeRemoveControlsCubit(),
            // ),
            BlocProvider<PlayerQueueCubit>(
              create: (context) => PlayerQueueCubit(
                audioPlayerBloc: BlocProvider.of<AudioPlayerBloc>(context),
              ),
            ),
            BlocProvider<CurrentPlayingCubit>(
              create: (context) => CurrentPlayingCubit(
                audioPlayerBloc: BlocProvider.of<AudioPlayerBloc>(context),
              ),
            ),
            BlocProvider<PagesDominantColorBloc>(
              create: (context) => PagesDominantColorBloc(
                audioPlayerBloc: BlocProvider.of<AudioPlayerBloc>(context),
              ),
            ),
            BlocProvider<SongListenRecorderBloc>(
              create: (context) => SongListenRecorderBloc(
                songPositionCubit: BlocProvider.of<SongPositionCubit>(context),
                syncRepository: AppRepositories.syncSongRepository,
              ),
            ),
            BlocProvider<SongSyncBloc>(
              create: (context) => SongSyncBloc(
                syncRepository: AppRepositories.syncSongRepository,
              ),
            ),
            BlocProvider<BottomBarCubit>(
              create: (context) => BottomBarCubit(),
            ),
            BlocProvider<BottomBarHomeCubit>(
              create: (context) => BottomBarHomeCubit(),
            ),
            BlocProvider<BottomBarCartCubit>(
              create: (context) => BottomBarCartCubit(),
            ),
            BlocProvider<BottomBarLibraryCubit>(
              create: (context) => BottomBarLibraryCubit(),
            ),
            BlocProvider<BottomBarSearchCubit>(
              create: (context) => BottomBarSearchCubit(),
            ),

            BlocProvider(
              create: (context) => SongMenuBloc(
                songMenuRepository: AppRepositories.songMenuRepository,
                downloadUtil: DownloadUtil(),
              ),
            ),
            BlocProvider(
              create: (context) => LibraryBloc(
                libraryDataRepository: AppRepositories.libraryDataRepository,
              ),
            ),
            BlocProvider(
              create: (context) => DownloadingSongBloc(
                downloadUtil: DownloadUtil(),
                receivePort: ReceivePort(),
                settingDataRepository: AppRepositories.settingDataRepository,
              ),
            ),
            BlocProvider(
              create: (context) => MyPlaylistBloc(
                myPlaylistRepository: AppRepositories.myPlayListRepository,
              ),
            ),
            BlocProvider(
              create: (context) => LocalizationCubit(),
            ),
            BlocProvider(
              create: (context) => CurrencyCubit(),
            ),
            BlocProvider(
              create: (context) => ShareBloc(),
            ),
          ],
          child: Builder(
            builder: (context) {
              return BlocBuilder<LocalizationCubit, AppLanguage>(
                builder: (context, state) {
                  print("LocalizationCubit=> ${state}");
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    builder: (BuildContext context, Widget? child) {
                      final MediaQueryData data = MediaQuery.of(context);
                      return MediaQuery(
                        data: data.copyWith(textScaleFactor: 1.0),
                        child: child!,
                      );
                    },
                    theme: App.theme,
                    initialRoute: AppRouterPaths.splashRoute,
                    routes: {
                      AppRouterPaths.splashRoute: (context) =>
                          const SplashPage(),
                      AppRouterPaths.signUp: (context) => const SignUpPage(),
                      AppRouterPaths.mainScreen: (context) =>
                          const MainScreen(),
                      AppRouterPaths.verifyPhonePageOne: (context) =>
                          const VerifyPhonePageOne(),
                      AppRouterPaths.verifyPhonePageTwo: (context) =>
                          const VerifyPhonePageTwo(),
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
