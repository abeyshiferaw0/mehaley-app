import 'dart:io';
import 'dart:isolate';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:elf_play/business_logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:elf_play/business_logic/blocs/downloading_song_bloc/downloading_song_bloc.dart';
import 'package:elf_play/business_logic/blocs/library_bloc/library_bloc.dart';
import 'package:elf_play/business_logic/blocs/song_menu_bloc/song_menu_bloc.dart';
import 'package:elf_play/business_logic/cubits/app_user_widgets_cubit.dart';
import 'package:elf_play/business_logic/cubits/bottom_bar_cubit/bottom_bar_cubit.dart';
import 'package:elf_play/business_logic/cubits/connectivity_cubit.dart';
import 'package:elf_play/config/app_repositories.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/audio_file.dart';
import 'package:elf_play/data/models/bg_video.dart';
import 'package:elf_play/data/models/enums/playlist_created_by.dart';
import 'package:elf_play/data/models/enums/setting_enums/download_song_quality.dart';
import 'package:elf_play/data/models/enums/user_login_type.dart';
import 'package:elf_play/data/models/lyric.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/data/models/text_lan.dart';
import 'package:elf_play/ui/screens/auth/sign_up_page.dart';
import 'package:elf_play/ui/screens/auth/verify_phone/verify_phone_page_one.dart';
import 'package:elf_play/ui/screens/auth/verify_phone/verify_phone_page_two.dart';
import 'package:elf_play/ui/screens/splash_main/main_screen.dart';
import 'package:elf_play/ui/screens/splash_main/splash_page.dart';
import 'package:elf_play/util/app_bloc_deligate.dart';
import 'package:elf_play/util/download_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:sizer/sizer.dart';

import 'business_logic/blocs/library_page_bloc/my_playlist_bloc/my_playlist_bloc.dart';
import 'business_logic/blocs/page_dominant_color_bloc/pages_dominant_color_bloc.dart';
import 'business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'business_logic/cubits/player_cubits/Muted_cubit.dart';
import 'business_logic/cubits/player_cubits/current_playing_cubit.dart';
import 'business_logic/cubits/player_cubits/loop_cubit.dart';
import 'business_logic/cubits/player_cubits/play_pause_cubit.dart';
import 'business_logic/cubits/player_cubits/player_queue_cubit.dart';
import 'business_logic/cubits/player_cubits/player_state_cubit.dart';
import 'business_logic/cubits/player_cubits/shuffle_cubit.dart';
import 'business_logic/cubits/player_cubits/song_buffered_position_cubit.dart';
import 'business_logic/cubits/player_cubits/song_duration_cubit.dart';
import 'business_logic/cubits/player_cubits/song_position_cubit.dart';
import 'business_logic/cubits/player_playing_from_cubit.dart';
import 'business_logic/cubits/search_input_is_searching_cubit.dart';
import 'config/app_hive_boxes.dart';
import 'data/models/app_user.dart';
import 'data/models/artist.dart';
import 'data/models/audio_file.dart';
import 'data/models/lyric.dart';
import 'data/models/playlist.dart';
import 'data/models/remote_image.dart';

void main() async {
  //BLOC TRANSITION OBSERVER AND LOGGER
  Bloc.observer = AppBlocDelegate();
  //JUST AUDIO BACKGROUND INIT
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Elf play',
    androidNotificationOngoing: true,
    //notificationColor: AppColors.appGradientDefaultColor,
  );
  //INIT HIVE
  Directory directory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(SongAdapter());
  Hive.registerAdapter(PlaylistAdapter());
  Hive.registerAdapter(AlbumAdapter());
  Hive.registerAdapter(ArtistAdapter());
  Hive.registerAdapter(AudioFileAdapter());
  Hive.registerAdapter(BgVideoAdapter());
  Hive.registerAdapter(LyricAdapter());
  Hive.registerAdapter(RemoteImageAdapter());
  Hive.registerAdapter(TextLanAdapter());
  Hive.registerAdapter(PlaylistCreatedByAdapter());
  Hive.registerAdapter(AppUserAdapter());
  Hive.registerAdapter(UserLoginTypeAdapter());
  Hive.registerAdapter(DownloadSongQualityAdapter());

  ///INIT HIVE BOXES
  await AppHiveBoxes.instance.initHiveBoxes();

  ///INITIALIZE FIREBASE APP
  await Firebase.initializeApp();

  ///INITIALIZE DOWNLOADER
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );

  ///INIT LOCAL NOTIFICATIONS
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      //'resource://drawable/res_app_icon',
      null,
      [
        NotificationChannel(
            icon: 'resource://drawable/res_download_icon',
            channelKey: 'progress_bar',
            channelName: 'Progress bar notifications',
            channelDescription: 'Notifications with a progress bar layout',
            defaultColor: Colors.deepPurple,
            ledColor: Colors.deepPurple,
            vibrationPattern: lowVibrationPattern,
            onlyAlertOnce: true),
      ]);

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
                playerDataRepository: AppRepositories.playerDataRepository,
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
            BlocProvider<BottomBarCubit>(
              create: (context) => BottomBarCubit(),
            ),
            BlocProvider(
              create: (context) => SearchInputIsSearchingCubit(),
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
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            builder: (BuildContext context, Widget? child) {
              final MediaQueryData data = MediaQuery.of(context);
              return MediaQuery(
                data: data.copyWith(textScaleFactor: 1),
                child: child!,
              );
            },
            theme: App.theme,
            initialRoute: AppRouterPaths.splashRoute,
            routes: {
              AppRouterPaths.splashRoute: (context) => const SplashPage(),
              AppRouterPaths.signUp: (context) => const SignUpPage(),
              AppRouterPaths.mainScreen: (context) => const MainScreen(),
              AppRouterPaths.verifyPhonePageOne: (context) =>
                  const VerifyPhonePageOne(),
              AppRouterPaths.verifyPhonePageTwo: (context) =>
                  const VerifyPhonePageTwo(),
            },
          ),
        );
      },
    );
  }
}
