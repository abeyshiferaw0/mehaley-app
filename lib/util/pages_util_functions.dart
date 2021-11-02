import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/business_logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:elf_play/business_logic/blocs/library_page_bloc/my_playlist_bloc/my_playlist_bloc.dart';
import 'package:elf_play/business_logic/blocs/page_dominant_color_bloc/pages_dominant_color_bloc.dart';
import 'package:elf_play/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:elf_play/business_logic/blocs/user_playlist_bloc/user_playlist_bloc.dart';
import 'package:elf_play/business_logic/cubits/app_user_widgets_cubit.dart';
import 'package:elf_play/business_logic/cubits/image_picker_cubit.dart';
import 'package:elf_play/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:elf_play/config/app_repositories.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/app_user.dart';
import 'package:elf_play/data/models/artist.dart';
import 'package:elf_play/data/models/category.dart';
import 'package:elf_play/data/models/enums/playlist_created_by.dart';
import 'package:elf_play/data/models/home_shortcut/album_shortcut.dart';
import 'package:elf_play/data/models/home_shortcut/category_shortcut.dart';
import 'package:elf_play/data/models/home_shortcut/playlist_shortcut.dart';
import 'package:elf_play/data/models/my_playlist.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/data/models/remote_image.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/data/models/sync/song_sync_played_from.dart';
import 'package:elf_play/data/models/text_lan.dart';
import 'package:elf_play/ui/common/app_card.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:elf_play/ui/common/small_text_price_widget.dart';
import 'package:elf_play/ui/screens/player/player_page.dart';
import 'package:elf_play/ui/screens/profile/edit_profile_page.dart';
import 'package:elf_play/ui/screens/user_playlist/create_user_playlist_page.dart';
import 'package:elf_play/ui/screens/user_playlist/edit_user_playlist_page.dart';
import 'package:elf_play/util/auth_util.dart';
import 'package:elf_play/util/color_util.dart';
import 'package:elf_play/util/download_util.dart';
import 'package:elf_play/util/l10n_util.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sizer/sizer.dart';

class PagesUtilFunctions {
  static String getPlaylistDescription(Playlist playlist, context) {
    if (L10nUtil.translateLocale(playlist.playlistDescriptionText, context)
        .isNotEmpty) {
      return L10nUtil.translateLocale(
          playlist.playlistDescriptionText, context);
    } else {
      return L10nUtil.translateLocale(playlist.playlistNameText, context);
    }
  }

  static String getPlaylistOwnerProfilePic(Playlist playlist) {
    if (playlist.createdBy == PlaylistCreatedBy.ADMIN ||
        playlist.createdBy == PlaylistCreatedBy.AUTO_GENERATED) {
      return "https://www.thoughtco.com/thmb/VfrRj6idAT6dCdaR8kEyLQD6P50=/2120x1414/filters:no_upscale():max_bytes(150000):strip_icc()/LatinCross-631151317-5a22dd90beba330037d3cecb.jpg";
    } else {
      return "https://images.askmen.com/1080x540/2016/01/25-021526-facebook_profile_picture_affects_chances_of_getting_hired.jpg";
    }
  }

  static String getPlaylistOwner(Playlist playlist) {
    if (playlist.createdBy == PlaylistCreatedBy.ADMIN ||
        playlist.createdBy == PlaylistCreatedBy.AUTO_GENERATED) {
      return "ELF PLAY";
    } else {
      return "SOMEONE ELSE";
    }
  }

  static String getPlaylistBy(Playlist playlist) {
    if (playlist.createdBy == PlaylistCreatedBy.ADMIN ||
        playlist.createdBy == PlaylistCreatedBy.AUTO_GENERATED) {
      return "BY ELF PLAY";
    } else {
      return "BY SOMEONE ELSE";
    }
  }

  static String getPlaylistDateCreated(Playlist playlist) {
    return DateFormat.yMMMd().format(playlist.playlistDateCreated).toString();
  }

  static String getPlaylistTotalDuration(List<Song> songs) {
    double totalDurationInSeconds = 0.0;
    for (Song song in songs) {
      totalDurationInSeconds += song.audioFile.audioDurationSeconds;
    }
    Duration duration = Duration(seconds: totalDurationInSeconds.toInt());

    var seconds = duration.inSeconds;
    final days = seconds ~/ Duration.secondsPerDay;
    seconds -= days * Duration.secondsPerDay;
    final hours = seconds ~/ Duration.secondsPerHour;
    seconds -= hours * Duration.secondsPerHour;
    final minutes = seconds ~/ Duration.secondsPerMinute;
    seconds -= minutes * Duration.secondsPerMinute;

    final List<String> tokens = [];
    if (days != 0) {
      tokens.add('$days days');
    }
    if (tokens.isNotEmpty || hours != 0) {
      tokens.add('${hours}h');
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add('$minutes min');
    }

    return tokens.join('  ');
    //return "${totalDurationInSeconds}";
  }

  static String getArtistsNames(List<TextLan> artistsName, context) {
    String names = "";
    for (TextLan name in artistsName) {
      if (names.isEmpty) {
        names = names + L10nUtil.translateLocale(name, context);
      } else {
        names = names + " , " + L10nUtil.translateLocale(name, context);
      }
    }
    return names;
  }

  static String getAlbumYear(Album album) {
    return DateFormat.y().format(album.albumReleaseDate).toString();
  }

  static String getGroupImageUrl(GroupType groupType, dynamic item) {
    if (groupType == GroupType.SONG) {
      return AppApi.baseFileUrl + (item as Song).albumArt.imageMediumPath;
    } else if (groupType == GroupType.PLAYLIST) {
      return AppApi.baseFileUrl +
          (item as Playlist).playlistImage.imageMediumPath;
    } else if (groupType == GroupType.ALBUM) {
      return AppApi.baseFileUrl +
          (item as Album).albumImages[0].imageMediumPath;
    } else if (groupType == GroupType.ARTIST) {
      return AppApi.baseFileUrl +
          (item as Artist).artistImages[0].imageMediumPath;
    } else {
      return "";
    }
  }

  static Widget getGroupItemPrice(GroupType groupType, dynamic item) {
    if (groupType == GroupType.SONG) {
      item as Song;
      return SmallTextPriceWidget(
        price: item.priceEtb,
        isDiscountAvailable: item.isDiscountAvailable,
        discountPercentage: item.discountPercentage,
        isFree: item.isFree,
        isPurchased: item.isBought,
      );
    } else if (groupType == GroupType.PLAYLIST) {
      item as Playlist;
      return SmallTextPriceWidget(
        price: item.priceEtb,
        isDiscountAvailable: item.isDiscountAvailable,
        discountPercentage: item.discountPercentage,
        isFree: item.isFree,
        isPurchased: item.isBought,
      );
    } else if (groupType == GroupType.ALBUM) {
      item as Album;
      return SmallTextPriceWidget(
        price: item.priceEtb,
        isDiscountAvailable: item.isDiscountAvailable,
        discountPercentage: item.discountPercentage,
        isFree: item.isFree,
        isPurchased: item.isBought,
      );
    } else if (groupType == GroupType.ARTIST) {
      return SizedBox();
    } else {
      return SizedBox();
    }
  }

  static Widget getItemPrice({
    required double price,
    required bool isDiscountAvailable,
    required double discountPercentage,
    required bool isFree,
    required bool isPurchased,
  }) {
    return SmallTextPriceWidget(
      price: price,
      isDiscountAvailable: isDiscountAvailable,
      discountPercentage: discountPercentage,
      isFree: isFree,
      isPurchased: isPurchased,
    );
  }

  static String getGroupItemTitle(GroupType groupType, dynamic item, context) {
    if (groupType == GroupType.SONG) {
      String title = L10nUtil.translateLocale((item as Song).songName, context);

      if (item.artistsName.length > 0) {
        title =
            "$title - ${L10nUtil.translateLocale(item.artistsName[0], context)}";
      }

      return title;
    } else if (groupType == GroupType.PLAYLIST) {
      return L10nUtil.translateLocale(
          (item as Playlist).playlistNameText, context);
    } else if (groupType == GroupType.ALBUM) {
      String title =
          "${L10nUtil.translateLocale((item as Album).albumTitle, context)} - ${L10nUtil.translateLocale(item.artist.artistName, context)}";
      return title;
    } else if (groupType == GroupType.ARTIST) {
      return L10nUtil.translateLocale((item as Artist).artistName, context);
    } else {
      return "";
    }
  }

  static AppItemsType getGroupItemImagePlaceHolderType(GroupType groupType) {
    if (groupType == GroupType.SONG) {
      return AppItemsType.SINGLE_TRACK;
    } else if (groupType == GroupType.PLAYLIST) {
      return AppItemsType.PLAYLIST;
    } else if (groupType == GroupType.ALBUM) {
      return AppItemsType.ALBUM;
    } else if (groupType == GroupType.ARTIST) {
      return AppItemsType.ARTIST;
    } else {
      return AppItemsType.SINGLE_TRACK;
    }
  }

  static getGroupItemTextStyle(GroupType groupType, item) {
    if (groupType == GroupType.SONG) {
      return TextStyle(
        color: AppColors.lightGrey,
        fontWeight: FontWeight.w500,
        fontSize: AppFontSizes.font_size_10.sp,
      );
    } else if (groupType == GroupType.PLAYLIST) {
      return TextStyle(
        color: AppColors.txtGrey,
        fontWeight: FontWeight.w500,
        fontSize: AppFontSizes.font_size_10.sp,
      );
    } else if (groupType == GroupType.ALBUM) {
      return TextStyle(
        color: AppColors.lightGrey,
        fontWeight: FontWeight.w500,
        fontSize: AppFontSizes.font_size_10.sp,
      );
    } else if (groupType == GroupType.ARTIST) {
      return TextStyle(
        color: AppColors.lightGrey,
        fontWeight: FontWeight.w500,
        fontSize: AppFontSizes.font_size_10.sp,
      );
    } else {
      return TextStyle(
        color: AppColors.lightGrey,
        fontWeight: FontWeight.w500,
        fontSize: AppFontSizes.font_size_10.sp,
      );
    }
  }

  static String albumTitle(Album album, context) {
    String title =
        "${L10nUtil.translateLocale(album.albumTitle, context)} - ${L10nUtil.translateLocale(album.artist.artistName, context)}";
    return title;
  }

  static void groupItemOnClick({
    required GroupType groupType,
    required dynamic item,
    required PlayingFrom playingFrom,
    required List<dynamic> items,
    required BuildContext context,
    required int index,
  }) {
    if (groupType == GroupType.SONG) {
      //SET PLAYER QUEUE
      setGroupItemsPlayerQueue(
        context: context,
        items: items,
        startPlaying: true,
        playingFrom: playingFrom,
        index: index,
      );

      //SET PLAYING FROM CUBIT
      BlocProvider.of<PlayerPagePlayingFromCubit>(context).changePlayingFrom(
        playingFrom,
      );

      //NAVIGATE TO PLAYER PAGE
      Navigator.of(context, rootNavigator: true).push(
        createBottomToUpAnimatedRoute(
          page: PlayerPage(),
        ),
      );
    } else if (groupType == GroupType.PLAYLIST) {
      Navigator.pushNamed(
        context,
        AppRouterPaths.playlistRoute,
        arguments: ScreenArguments(
            args: {'playlistId': (item as Playlist).playlistId}),
      );
    } else if (groupType == GroupType.ALBUM) {
      Navigator.pushNamed(
        context,
        AppRouterPaths.albumRoute,
        arguments: ScreenArguments(args: {'albumId': (item as Album).albumId}),
      );
    } else if (groupType == GroupType.ARTIST) {
      Navigator.pushNamed(
        context,
        AppRouterPaths.artistRoute,
        arguments:
            ScreenArguments(args: {'artistId': (item as Artist).artistId}),
      );
    }
  }

  static void searchResultItemOnClick({
    required AppSearchItemTypes appSearchItemTypes,
    required dynamic item,
    required PlayingFrom playingFrom,
    required List<dynamic> items,
    required BuildContext context,
    required int index,
  }) {
    if (appSearchItemTypes == AppSearchItemTypes.SONG) {
      //SET PLAYER QUEUE
      setGroupItemsPlayerQueue(
        context: context,
        items: items,
        startPlaying: true,
        playingFrom: playingFrom,
        index: index,
      );

      //SET PLAYING FROM CUBIT
      BlocProvider.of<PlayerPagePlayingFromCubit>(context).changePlayingFrom(
        playingFrom,
      );

      //NAVIGATE TO PLAYER PAGE
      Navigator.of(context, rootNavigator: true).push(
        createBottomToUpAnimatedRoute(
          page: PlayerPage(),
        ),
      );
    } else if (appSearchItemTypes == AppSearchItemTypes.PLAYLIST) {
      Navigator.pushNamed(
        context,
        AppRouterPaths.playlistRoute,
        arguments: ScreenArguments(
            args: {'playlistId': (item as Playlist).playlistId}),
      );
    } else if (appSearchItemTypes == AppSearchItemTypes.ALBUM) {
      Navigator.pushNamed(
        context,
        AppRouterPaths.albumRoute,
        arguments: ScreenArguments(args: {'albumId': (item as Album).albumId}),
      );
    } else if (appSearchItemTypes == AppSearchItemTypes.ARTIST) {
      Navigator.pushNamed(
        context,
        AppRouterPaths.artistRoute,
        arguments:
            ScreenArguments(args: {'artistId': (item as Artist).artistId}),
      );
    }
  }

  static void albumItemOnClick(Album album, BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRouterPaths.albumRoute,
      arguments: ScreenArguments(args: {'albumId': album.albumId}),
    );
  }

  static void artistItemOnClick(Artist artist, BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRouterPaths.artistRoute,
      arguments: ScreenArguments(args: {'artistId': artist.artistId}),
    );
  }

  static void songItemOnClick(Song album, BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRouterPaths.playerRoute,
    );
  }

  static void playlistItemOnClick(Playlist playlist, BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRouterPaths.playlistRoute,
      arguments: ScreenArguments(args: {'playlistId': playlist.playlistId}),
    );
  }

  static void setGroupItemsPlayerQueue({
    required BuildContext context,
    required List<dynamic> items,
    required bool startPlaying,
    required PlayingFrom playingFrom,
    required int index,
  }) async {
    DownloadUtil downloadUtil = DownloadUtil();
    //GENERATE LIST OF AUDIO SOURCE FROM LIST OF SONG ITEMS
    List<AudioSource> audioSourceItems = await Song.toListAudioSourceStreamUri(
      downloadUtil,
      items as List<Song>,
      playingFrom,
      context,
    );
    // List<AudioSource> audioSourceItems =
    //     await items.map((song) => Song.toListAudioSourceStreamUri(downloadUtil,song)).toList();
    // //SET PLAYER QUEUE
    BlocProvider.of<AudioPlayerBloc>(context).add(
      SetPlayerQueueEvent(
          queue: audioSourceItems, startPlaying: startPlaying, index: index),
    );
  }

  static void openSong({
    required BuildContext context,
    required List<Song> songs,
    required bool startPlaying,
    required PlayingFrom playingFrom,
    required int index,
  }) async {
    DownloadUtil downloadUtil = DownloadUtil();
    //GENERATE LIST OF AUDIO SOURCE FROM LIST OF SONG ITEMS
    List<AudioSource> audioSourceItems = await Song.toListAudioSourceStreamUri(
        downloadUtil, songs, playingFrom, context);
    //List<AudioSource> audioSourceItems = [Song.toAudioSourceStreamUri(song)];
    //SET PLAYER QUEUE
    BlocProvider.of<AudioPlayerBloc>(context).add(
      SetPlayerQueueEvent(
          queue: audioSourceItems, startPlaying: startPlaying, index: index),
    );
    //SET PLAYING FROM CUBIT
    BlocProvider.of<PlayerPagePlayingFromCubit>(context).changePlayingFrom(
      playingFrom,
    );
    //NAVIGATE TO PLAYER PAGE
    Navigator.of(context, rootNavigator: true).push(
      createBottomToUpAnimatedRoute(
        page: PlayerPage(),
      ),
    );
  }

  static void openSongShuffled({
    required BuildContext context,
    required List<Song> songs,
    required bool startPlaying,
    required PlayingFrom playingFrom,
    required int index,
  }) async {
    DownloadUtil downloadUtil = DownloadUtil();
    //GENERATE LIST OF AUDIO SOURCE FROM LIST OF SONG ITEMS
    List<AudioSource> audioSourceItems = await Song.toListAudioSourceStreamUri(
        downloadUtil, songs, playingFrom, context);
    //SET PLAYER QUEUE
    BlocProvider.of<AudioPlayerBloc>(context).add(
      SetPlayerQueueEvent(
          queue: audioSourceItems, startPlaying: startPlaying, index: index),
    );
    //SHUFFLE QUEUE
    BlocProvider.of<AudioPlayerBloc>(context).add(ShufflePlayerOnQueueEvent());
    //SET PLAYING FROM CUBIT
    BlocProvider.of<PlayerPagePlayingFromCubit>(context).changePlayingFrom(
      playingFrom,
    );
    //NAVIGATE TO PLAYER PAGE
    Navigator.of(context, rootNavigator: true).push(
      createBottomToUpAnimatedRoute(
        page: PlayerPage(),
      ),
    );
  }

  static Route createBottomToUpAnimatedRoute(
      {required Widget page, String? setting}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      settings: setting != null ? RouteSettings(name: setting) : null,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeIn;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static Route createScaleAnimatedRoute({required Widget page}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        animation = CurvedAnimation(curve: Curves.easeIn, parent: animation);

        return Align(
          child: SizeTransition(
            sizeFactor: animation,
            child: child,
            axisAlignment: 0.0,
          ),
        );
      },
    );
  }

  static Color getLoopButtonColor(LoopMode loopMode) {
    if (loopMode == LoopMode.off) {
      return AppColors.white;
    } else if (loopMode == LoopMode.all) {
      return AppColors.green;
    } else if (loopMode == LoopMode.one) {
      return AppColors.green;
    } else {
      return AppColors.white;
    }
  }

  static IconData? getLoopIcon(LoopMode loopMode) {
    if (loopMode == LoopMode.off) {
      return PhosphorIcons.repeat;
    } else if (loopMode == LoopMode.all) {
      return PhosphorIcons.repeat;
    } else if (loopMode == LoopMode.one) {
      return PhosphorIcons.repeat_once_light;
    } else {
      return PhosphorIcons.repeat_once_light;
    }
  }

  static String formatSongDurationTimeTo(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  static int getRandomIndex({required int min, required int max}) {
    return min + Random().nextInt(max - min);
  }

  static String getSearchFrontPageItemTitle(
      AppItemsType appItemsType, dynamic item, context) {
    if (appItemsType == AppItemsType.CATEGORY) {
      return L10nUtil.translateLocale(
          (item as Category).categoryNameText, context);
    } else if (appItemsType == AppItemsType.ARTIST) {
      return L10nUtil.translateLocale((item as Artist).artistName, context);
    } else if (appItemsType == AppItemsType.SINGLE_TRACK) {
      return L10nUtil.translateLocale((item as Song).songName, context);
    }
    return "";
  }

  static String getSearchFrontPageItemImageUrl(
      AppItemsType appItemsType, dynamic item) {
    if (appItemsType == AppItemsType.CATEGORY) {
      return AppApi.baseFileUrl +
          (item as Category).categoryImage.imageSmallPath;
    } else if (appItemsType == AppItemsType.ARTIST) {
      return AppApi.baseFileUrl +
          (item as Artist).artistImages[0].imageSmallPath;
    } else if (appItemsType == AppItemsType.SINGLE_TRACK) {
      return AppApi.baseFileUrl + (item as Song).albumArt.imageSmallPath;
    }
    return "";
  }

  static Color getSearchFrontPageDominantColor(
      AppItemsType appItemsType, dynamic item) {
    if (appItemsType == AppItemsType.CATEGORY) {
      item as Category;

      return ColorUtil.darken(
          ColorUtil.changeColorSaturation(
            HexColor(item.categoryImage.primaryColorHex),
            1,
          ),
          0.12);
    } else if (appItemsType == AppItemsType.ARTIST) {
      item as Artist;
      return ColorUtil.darken(
          ColorUtil.changeColorSaturation(
            HexColor(item.artistImages[0].primaryColorHex),
            1,
          ),
          0.12);
    } else if (appItemsType == AppItemsType.SINGLE_TRACK) {
      item as Song;
      return ColorUtil.darken(
          ColorUtil.changeColorSaturation(
            HexColor(item.albumArt.primaryColorHex),
            1,
          ),
          0.12);
    }
    return AppColors.appGradientDefaultColor;
  }

  static void showMenuDialog({
    required BuildContext context,
    required Widget child,
  }) {
    // showGeneralDialog(
    //   context: context,
    //   barrierColor: Colors.black.withOpacity(0.6), // Background color
    //   barrierDismissible: false,
    //   barrierLabel: AppValues.menuBarrierLabel,
    //   transitionDuration: Duration(milliseconds: 400),
    //   transitionBuilder: (context, a1, a2, widget) {
    //     final curvedValue = 1.0 -
    //         Curves.elasticInOut.transform(
    //           a1.value,
    //         );
    //     return Transform(
    //       transform: Matrix4.translationValues(
    //         0.0,
    //         curvedValue * 200,
    //         0.0,
    //       ),
    //       child: Opacity(
    //         opacity: a1.value,
    //         child: widget,
    //       ),
    //     );
    //   },
    //   pageBuilder: (context, animation, secondaryAnimation) {
    //     return child;
    //   },
    // );
    showModalBottomSheet(
      backgroundColor: AppColors.transparent,
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: true,
      builder: (context) {
        return SizedBox.expand(
          child: child,
        );
      },
    );
  }

  static getRecentItemId(item) {
    if (item is Song) {
      return "${EnumToString.convertToString(AppItemsType.SINGLE_TRACK)}_${item.songId}";
    } else if (item is Playlist) {
      return "${EnumToString.convertToString(AppItemsType.PLAYLIST)}_${item.playlistId}";
    } else if (item is Artist) {
      return "${EnumToString.convertToString(AppItemsType.ARTIST)}_${item.artistId}";
    } else if (item is Album) {
      return "${EnumToString.convertToString(AppItemsType.ALBUM)}_${item.albumId}";
    }
    throw "ITEM NOT SEARCHED TYPES";
  }

  static String getItemKey(dynamic item) {
    if (item is Song) {
      return "song_${item.songId}";
    } else if (item is Playlist) {
      return "playlist_${item.playlistId}";
    } else if (item is Album) {
      return "album_${item.albumId}";
    } else if (item is Artist) {
      return "artist_${item.artistId}";
    } else {
      throw "Unknown Recent type";
    }
  }

  static void openCreatePlaylistPage(context) async {
    final refresh = await Navigator.of(context, rootNavigator: true).push(
      PagesUtilFunctions.createBottomToUpAnimatedRoute(
        page: MultiBlocProvider(
          providers: [
            BlocProvider<ImagePickerCubit>(
              create: (context) => ImagePickerCubit(
                picker: ImagePicker(),
              ),
            ),
            BlocProvider(
              create: (context) => UserPlaylistBloc(
                userPLayListRepository: AppRepositories.userPLayListRepository,
              ),
            ),
          ],
          child: CreateUserPlaylistPage(
            createWithSong: false,
            song: null,
          ),
        ),
      ),
    );
    if (refresh != null) {
      if (refresh is bool) {
        if (refresh) {
          BlocProvider.of<MyPlaylistBloc>(context).add(
            LoadAllMyPlaylistsEvent(isForAddSongPage: false),
          );
        }
      }
    }
  }

  static void openEditPlaylistPage(context, MyPlaylist myPlaylist,
      Function(MyPlaylist myPlaylist) onUpdateSuccess) async {
    final updatedMyPlaylist =
        await Navigator.of(context, rootNavigator: true).push(
      PagesUtilFunctions.createBottomToUpAnimatedRoute(
        page: MultiBlocProvider(
          providers: [
            BlocProvider<ImagePickerCubit>(
              create: (context) => ImagePickerCubit(
                picker: ImagePicker(),
              ),
            ),
            BlocProvider(
              create: (context) => UserPlaylistBloc(
                userPLayListRepository: AppRepositories.userPLayListRepository,
              ),
            ),
          ],
          child: EditUserPlaylistPage(
            myPlaylist: myPlaylist,
          ),
        ),
      ),
    );
    if (updatedMyPlaylist != null) {
      if (updatedMyPlaylist is MyPlaylist) {
        ///UPDATE PLAYLIST PAGE WITH NEW DATA
        print(
            "onUpdateSuccess 1 ${L10nUtil.translateLocale(myPlaylist.playlistNameText, context)}");
        onUpdateSuccess(updatedMyPlaylist);
        Navigator.pop(context);
      }
    }
  }

  static void openCreatePlaylistPageForAdding(
      context, Song song, Function(MyPlaylist) onCreateWithSongSuccess) async {
    final shouldPop = await Navigator.of(context, rootNavigator: true).push(
      PagesUtilFunctions.createBottomToUpAnimatedRoute(
        page: MultiBlocProvider(
          providers: [
            BlocProvider<ImagePickerCubit>(
              create: (context) => ImagePickerCubit(
                picker: ImagePicker(),
              ),
            ),
            BlocProvider(
              create: (context) => UserPlaylistBloc(
                userPLayListRepository: AppRepositories.userPLayListRepository,
              ),
            ),
          ],
          child: CreateUserPlaylistPage(
            createWithSong: true,
            song: song,
            onCreateWithSongSuccess: onCreateWithSongSuccess,
          ),
        ),
      ),
    );
    if (shouldPop != null) {
      if (shouldPop) {
        Navigator.pop(context);
      }
    }
  }

  static Widget getSongGridImage(MyPlaylist myPlaylist) {
    if (myPlaylist.playlistImage != null) {
      return AppCard(
        child: CachedNetworkImage(
          width: AppValues.libraryMusicItemSize,
          height: AppValues.libraryMusicItemSize,
          fit: BoxFit.cover,
          imageUrl:
              AppApi.baseFileUrl + myPlaylist.playlistImage!.imageMediumPath,
          placeholder: (context, url) =>
              buildImagePlaceHolder(AppItemsType.SINGLE_TRACK),
          errorWidget: (context, url, e) =>
              buildImagePlaceHolder(AppItemsType.SINGLE_TRACK),
        ),
      );
    }
    if (myPlaylist.gridSongImages.length > 0) {
      if (myPlaylist.gridSongImages.length <= 3) {
        return AppCard(
          child: CachedNetworkImage(
            width: AppValues.libraryMusicItemSize,
            height: AppValues.libraryMusicItemSize,
            fit: BoxFit.cover,
            imageUrl: AppApi.baseFileUrl +
                myPlaylist.gridSongImages.elementAt(0).imageMediumPath,
            placeholder: (context, url) =>
                buildImagePlaceHolder(AppItemsType.SINGLE_TRACK),
            errorWidget: (context, url, e) =>
                buildImagePlaceHolder(AppItemsType.SINGLE_TRACK),
          ),
        );
      }
      if (myPlaylist.gridSongImages.length >= 4) {
        return GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: List.generate(
            4,
            (index) {
              return CachedNetworkImage(
                width: AppValues.libraryMusicItemSize,
                height: AppValues.libraryMusicItemSize,
                fit: BoxFit.cover,
                imageUrl: AppApi.baseFileUrl +
                    myPlaylist.gridSongImages.elementAt(index).imageSmallPath,
                placeholder: (context, url) =>
                    buildImagePlaceHolder(AppItemsType.OTHER),
                errorWidget: (context, url, e) =>
                    buildImagePlaceHolder(AppItemsType.OTHER),
              );
            },
          ),
        );
      }
    }
    return AppCard(
      child: CachedNetworkImage(
        width: AppValues.libraryMusicItemSize,
        height: AppValues.libraryMusicItemSize,
        fit: BoxFit.cover,
        imageUrl: AppApi.baseFileUrl,
        placeholder: (context, url) =>
            buildImagePlaceHolder(AppItemsType.SINGLE_TRACK),
        errorWidget: (context, url, e) =>
            buildImagePlaceHolder(AppItemsType.SINGLE_TRACK),
      ),
    );
  }

  static Widget buildImagePlaceHolder(appItemsType) {
    if (appItemsType == AppItemsType.OTHER) {
      return Container(
        color: AppColors.darkGrey,
      );
    }
    return AppItemsImagePlaceHolder(appItemsType: appItemsType);
  }

  static String getUserPlaylistByText(MyPlaylist myPlaylist, context) {
    return "BY ${AuthUtil.getUserName(BlocProvider.of<AppUserWidgetsCubit>(context).state).toUpperCase()}";
  }

  static String getUserPlaylistDescription(MyPlaylist myPlaylist, context) {
    if (L10nUtil.translateLocale(myPlaylist.playlistDescriptionText, context)
        .isNotEmpty) {
      return L10nUtil.translateLocale(
          myPlaylist.playlistDescriptionText, context);
    } else {
      return L10nUtil.translateLocale(myPlaylist.playlistNameText, context);
    }
  }

  static String getUserPlaylistOwner(MyPlaylist myPlaylist, context) {
    return AuthUtil.getUserName(
        BlocProvider.of<AppUserWidgetsCubit>(context).state);
  }

  static getUserPlaylistDateCreated(MyPlaylist myPlaylist) {
    return DateFormat.yMMMd().format(myPlaylist.playlistDateCreated).toString();
  }

  static void changeUserPlaylistDominantColor(
      MyPlaylist myPlaylist, BuildContext context) {
    if (myPlaylist.playlistImage != null) {
      BlocProvider.of<PagesDominantColorBloc>(context).add(
        UserPlaylistPageDominantColorChanged(
          dominantColor: HexColor(myPlaylist.playlistImage!.primaryColorHex),
        ),
      );
      return;
    }
    if (myPlaylist.gridSongImages.length > 0) {
      if (myPlaylist.gridSongImages.length >= 4) {
        Color color1 = HexColor(myPlaylist.gridSongImages[0].primaryColorHex);
        Color color2 = HexColor(myPlaylist.gridSongImages[1].primaryColorHex);
        Color color3 = HexColor(myPlaylist.gridSongImages[2].primaryColorHex);
        Color color4 = HexColor(myPlaylist.gridSongImages[3].primaryColorHex);

        Color newColor1 = Color.alphaBlend(color1, color2);
        Color newColor2 = Color.alphaBlend(color3, color4);

        Color dominantColor = Color.alphaBlend(newColor1, newColor2);
        BlocProvider.of<PagesDominantColorBloc>(context).add(
          UserPlaylistPageDominantColorChanged(
            dominantColor: HexColor(
              "#${dominantColor.value.toRadixString(16)}",
            ),
          ),
        );
        return;
      }
      if (myPlaylist.gridSongImages.length <= 3) {
        BlocProvider.of<PagesDominantColorBloc>(context).add(
          UserPlaylistPageDominantColorChanged(
            dominantColor:
                HexColor(myPlaylist.gridSongImages[0].primaryColorHex),
          ),
        );
        return;
      }
    }
    BlocProvider.of<PagesDominantColorBloc>(context).add(
      UserPlaylistPageDominantColorChanged(
        dominantColor: HexColor(
          ColorUtil.darken(
            AppColors.appGradientDefaultColorBlack,
            0.1,
          ).value.toRadixString(16),
        ),
      ),
    );
    return;
  }

  static void openEditProfilePage(
    context,
    Function(AppUser appUser) onUpdateSuccess,
  ) async {
    final appUser = await Navigator.of(context, rootNavigator: true).push(
      PagesUtilFunctions.createScaleAnimatedRoute(
        page: MultiBlocProvider(
          providers: [
            BlocProvider<ImagePickerCubit>(
              create: (context) => ImagePickerCubit(
                picker: ImagePicker(),
              ),
            ),
            BlocProvider<AuthBloc>(
              create: (context) => AuthBloc(
                firebaseAuth: FirebaseAuth.instance,
                authRepository: AppRepositories.authRepository,
              ),
            ),
          ],
          child: EditUserProfilePage(),
        ),
      ),
    );
    if (appUser != null) {
      if (appUser is AppUser) {
        onUpdateSuccess(appUser);
      }
    }
  }

  static double getSongLength(Song song) {
    if (!song.isBought && !song.isFree) {
      return song.audioFile.audioPreviewDurationSeconds;
    }
    return song.audioFile.audioDurationSeconds;
  }

  static String getFormatdMaxSongDuration(Song song) {
    if (!song.isBought && !song.isFree) {
      return formatSongDurationTimeTo(
        Duration(
          seconds: song.audioFile.audioPreviewDurationSeconds.toInt(),
        ),
      );
    }
    return formatSongDurationTimeTo(
      Duration(
        seconds: song.audioFile.audioDurationSeconds.toInt(),
      ),
    );
  }

  static SongSyncPlayedFrom getSongSyncPlayedFromGroupType(
      GroupType groupType) {
    if (groupType == GroupType.ARTIST) return SongSyncPlayedFrom.ARTIST_GROUP;
    if (groupType == GroupType.PLAYLIST)
      return SongSyncPlayedFrom.PLAYLIST_GROUP;
    if (groupType == GroupType.ALBUM) return SongSyncPlayedFrom.ALBUM_GROUP;
    if (groupType == GroupType.SONG) return SongSyncPlayedFrom.SONG_GROUP;
    return SongSyncPlayedFrom.UNK;
  }

  static String getShortCutText(shortcut, context) {
    if (shortcut is CategoryShortcut) {
      return L10nUtil.translateLocale(shortcut.categoryNameText, context);
    }
    if (shortcut is AlbumShortcut) {
      return L10nUtil.translateLocale(shortcut.albumTitle, context);
    }
    if (shortcut is PlaylistShortcut) {
      return L10nUtil.translateLocale(shortcut.playlistNameText, context);
    } else {
      throw "shortcut type not valid";
    }
  }

  static RemoteImage getImage(shortcut) {
    if (shortcut is CategoryShortcut) {
      return shortcut.categoryImage;
    }
    if (shortcut is AlbumShortcut) {
      return shortcut.albumImages[0];
    }
    if (shortcut is PlaylistShortcut) {
      return shortcut.playlistImage;
    } else {
      throw "shortcut type not valid";
    }
  }

  static AppItemsType getAppItemsType(shortcut) {
    if (shortcut is CategoryShortcut) {
      return AppItemsType.OTHER;
    }
    if (shortcut is AlbumShortcut) {
      return AppItemsType.ALBUM;
    }
    if (shortcut is PlaylistShortcut) {
      return AppItemsType.PLAYLIST;
    } else {
      throw "shortcut type not valid";
    }
  }

  static String getShortCutType(shortcut) {
    if (shortcut is CategoryShortcut) {
      return "Category";
    }
    if (shortcut is AlbumShortcut) {
      return "Album";
    }
    if (shortcut is PlaylistShortcut) {
      return "Playlist";
    } else {
      throw "shortcut type not valid";
    }
  }

  static getShortCutClickAction(shortcut, context) {
    if (shortcut is CategoryShortcut) {
      Navigator.pushNamed(
        context,
        AppRouterPaths.categoryRoute,
        arguments: ScreenArguments(
          args: {
            'category': Category(
              categoryId: shortcut.categoryId,
              categoryNameText: shortcut.categoryNameText,
              categoryDescriptionText: shortcut.categoryNameText,
              categoryImage: shortcut.categoryImage,
              categoryDateCreated: DateTime.now(),
              categoryDateUpdated: DateTime.now(),
            )
          },
        ),
      );
    }
    if (shortcut is AlbumShortcut) {
      Navigator.pushNamed(
        context,
        AppRouterPaths.albumRoute,
        arguments: ScreenArguments(args: {'albumId': shortcut.albumId}),
      );
    }
    if (shortcut is PlaylistShortcut) {
      Navigator.pushNamed(
        context,
        AppRouterPaths.playlistRoute,
        arguments: ScreenArguments(
          args: {'playlistId': shortcut.playlistId},
        ),
      );
    } else {
      throw "shortcut type not valid";
    }
  }
}
