import 'dart:math';

import 'package:elf_play/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:elf_play/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/artist.dart';
import 'package:elf_play/data/models/category.dart';
import 'package:elf_play/data/models/enums/playlist_created_by.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/data/models/text_lan.dart';
import 'package:elf_play/ui/common/small_text_price_widget.dart';
import 'package:elf_play/ui/screens/player/player_page.dart';
import 'package:elf_play/util/color_util.dart';
import 'package:elf_play/util/download_util.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sizer/sizer.dart';

class PagesUtilFunctions {
  static String getPlaylistDescription(Playlist playlist) {
    if (playlist.playlistDescriptionText.textAm.isNotEmpty) {
      return playlist.playlistDescriptionText.textAm;
    } else {
      return playlist.playlistNameText.textAm;
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

  static String getArtistsNames(List<TextLan> artistsName) {
    String names = "";
    for (TextLan name in artistsName) {
      if (names.isEmpty) {
        names = names + name.textAm;
      } else {
        names = names + " , " + name.textAm;
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
      var item2 = (item as Song);
      return SmallTextPriceWidget(
        price: item.priceEtb,
        isDiscountAvailable: item.isDiscountAvailable,
        discountPercentage: item.discountPercentage,
        isFree: item.isFree,
      );
    } else if (groupType == GroupType.PLAYLIST) {
      var item2 = (item as Playlist);
      return SmallTextPriceWidget(
        price: item.priceEtb,
        isDiscountAvailable: item.isDiscountAvailable,
        discountPercentage: item.discountPercentage,
        isFree: item.isFree,
      );
    } else if (groupType == GroupType.ALBUM) {
      var item2 = (item as Album);
      return SmallTextPriceWidget(
        price: item.priceEtb,
        isDiscountAvailable: item.isDiscountAvailable,
        discountPercentage: item.discountPercentage,
        isFree: item.isFree,
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
  }) {
    return SmallTextPriceWidget(
      price: price,
      isDiscountAvailable: isDiscountAvailable,
      discountPercentage: discountPercentage,
      isFree: isFree,
    );
  }

  static String getGroupItemTitle(GroupType groupType, dynamic item) {
    if (groupType == GroupType.SONG) {
      String title = (item as Song).songName.textAm;

      if (item.artistsName.length > 0) {
        title = "$title - ${item.artistsName[0].textAm}";
      }

      return title;
    } else if (groupType == GroupType.PLAYLIST) {
      return (item as Playlist).playlistNameText.textAm;
    } else if (groupType == GroupType.ALBUM) {
      String title =
          "${(item as Album).albumTitle.textAm} - ${item.artist.artistName.textAm}";
      return title;
    } else if (groupType == GroupType.ARTIST) {
      return (item as Artist).artistName.textAm;
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

  static String albumTitle(Album album) {
    String title =
        "${album.albumTitle.textAm} - ${album.artist.artistName.textAm}";
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
    required int index,
  }) {
    //GENERATE LIST OF AUDIO SOURCE FROM LIST OF SONG ITEMS
    List<AudioSource> audioSourceItems =
        items.map((song) => Song.toAudioSourceStreamUri(song)).toList();
    //SET PLAYER QUEUE
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
    List<AudioSource> audioSourceItems =
        await Song.toListAudioSourceStreamUri(downloadUtil, songs);
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
  }) {
    List<AudioSource> audioSourceItems =
        songs.map((song) => Song.toAudioSourceStreamUri(song)).toList();
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

  static Route createBottomToUpAnimatedRoute({required Widget page}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
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

  static String formatDurationTimeTo(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  static int getRandomIndex({required int min, required int max}) {
    return Random().nextInt(max);
  }

  static String getSearchFrontPageItemTitle(
      AppItemsType appItemsType, dynamic item) {
    if (appItemsType == AppItemsType.CATEGORY) {
      return (item as Category).categoryNameText.textAm;
    } else if (appItemsType == AppItemsType.ARTIST) {
      return (item as Artist).artistName.textAm;
    } else if (appItemsType == AppItemsType.SINGLE_TRACK) {
      return (item as Song).songName.textAm;
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
            0.9,
          ),
          0.12);
    } else if (appItemsType == AppItemsType.ARTIST) {
      item as Artist;
      return ColorUtil.darken(
          ColorUtil.changeColorSaturation(
            HexColor(item.artistImages[0].primaryColorHex),
            0.9,
          ),
          0.12);
    } else if (appItemsType == AppItemsType.SINGLE_TRACK) {
      item as Song;
      return ColorUtil.darken(
          ColorUtil.changeColorSaturation(
            HexColor(item.albumArt.primaryColorHex),
            0.9,
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
}
