import 'dart:io';
import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:mehaley/business_logic/blocs/library_page_bloc/my_playlist_bloc/my_playlist_bloc.dart';
import 'package:mehaley/business_logic/blocs/page_dominant_color_bloc/pages_dominant_color_bloc.dart';
import 'package:mehaley/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:mehaley/business_logic/blocs/user_playlist_bloc/user_playlist_bloc.dart';
import 'package:mehaley/business_logic/blocs/videos_bloc/other_videos_bloc/other_videos_bloc.dart';
import 'package:mehaley/business_logic/cubits/app_user_widgets_cubit.dart';
import 'package:mehaley/business_logic/cubits/image_picker_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/config/app_repositories.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/country_codes.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/data_providers/iap_purchase_provider.dart';
import 'package:mehaley/data/data_providers/iap_subscription_provider.dart';
import 'package:mehaley/data/data_providers/settings_data_provider.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/app_permission.dart';
import 'package:mehaley/data/models/app_user.dart';
import 'package:mehaley/data/models/artist.dart';
import 'package:mehaley/data/models/category.dart';
import 'package:mehaley/data/models/enums/app_payment_methods.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/enums/playlist_created_by.dart';
import 'package:mehaley/data/models/my_playlist.dart';
import 'package:mehaley/data/models/payment/iap_product.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/models/subscription_offerings.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/data/models/text_lan.dart';
import 'package:mehaley/data/repositories/iap_purchase_repository.dart';
import 'package:mehaley/data/repositories/iap_subscription_repository.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/common/dialog/dialog_offline_song_subscribe_to_listen.dart';
import 'package:mehaley/ui/common/dialog/dialog_permission_permanent_refused.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/ui/common/small_text_price_widget.dart';
import 'package:mehaley/ui/common/song_item/song_item_badge.dart';
import 'package:mehaley/ui/screens/player/player_page.dart';
import 'package:mehaley/ui/screens/profile/edit_profile_page.dart';
import 'package:mehaley/ui/screens/user_playlist/create_user_playlist_page.dart';
import 'package:mehaley/ui/screens/user_playlist/edit_user_playlist_page.dart';
import 'package:mehaley/ui/screens/videos/yt_player.dart';
import 'package:mehaley/util/auth_util.dart';
import 'package:mehaley/util/color_util.dart';
import 'package:mehaley/util/download_util.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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

  static String getPlaylistOwner(Playlist playlist, context) {
    if (playlist.createdBy == PlaylistCreatedBy.ADMIN ||
        playlist.createdBy == PlaylistCreatedBy.AUTO_GENERATED) {
      return AppLocale.of().appName.toUpperCase();
    } else {
      return '';
    }
  }

  static String getPlaylistBy(Playlist playlist, context) {
    if (playlist.createdBy == PlaylistCreatedBy.ADMIN ||
        playlist.createdBy == PlaylistCreatedBy.AUTO_GENERATED) {
      return AppLocale.of().byAppName.toUpperCase();
    } else {
      return '';
    }
  }

  static String getPlaylistDateCreated(Playlist playlist) {
    return DateFormat.yMMMd().format(playlist.playlistDateCreated).toString();
  }

  static Widget getGroupItemType(GroupType groupType) {
    if (groupType == GroupType.SONG)
      return SongItemBadge(
        tag: AppLocale.of().mezmur,
      );
    if (groupType == GroupType.ALBUM)
      return SongItemBadge(
        tag: AppLocale.of().album,
      );
    if (groupType == GroupType.PLAYLIST)
      return SongItemBadge(
        tag: AppLocale.of().playlist,
      );
    if (groupType == GroupType.ARTIST) return SizedBox();
    return SizedBox();
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
      tokens.add('$hours h');
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add('$minutes min');
    }

    return tokens.join('  ');
    //return '${totalDurationInSeconds}';
  }

  static String getArtistsNames(List<TextLan> artistsName, context) {
    String names = '';
    for (TextLan name in artistsName) {
      if (names.isEmpty) {
        names = names + L10nUtil.translateLocale(name, context);
      } else {
        names = names + ' , ' + L10nUtil.translateLocale(name, context);
      }
    }
    return names;
  }

  static String getAlbumYear(Album album) {
    return DateFormat.y().format(album.albumReleaseDate).toString();
  }

  static String getGroupImageUrl(GroupType groupType, dynamic item) {
    if (groupType == GroupType.SONG) {
      return (item as Song).albumArt.imageLargePath;
    } else if (groupType == GroupType.PLAYLIST) {
      return (item as Playlist).playlistImage.imageLargePath;
    } else if (groupType == GroupType.ALBUM) {
      return (item as Album).albumImages[0].imageLargePath;
    } else if (groupType == GroupType.ARTIST) {
      return (item as Artist).artistImages[0].imageLargePath;
    } else {
      return '';
    }
  }

  static Widget getGroupItemPrice(GroupType groupType, dynamic item) {
    if (groupType == GroupType.SONG) {
      item as Song;
      return Padding(
        padding: const EdgeInsets.only(
          top: AppPadding.padding_2,
        ),
        child: SmallTextPriceWidget(
          priceEtb: item.priceEtb,
          priceUsd: item.priceDollar,
          isDiscountAvailable: item.isDiscountAvailable,
          discountPercentage: item.discountPercentage,
          isFree: item.isFree,
          isPurchased: item.isBought,
        ),
      );
    } else if (groupType == GroupType.PLAYLIST) {
      item as Playlist;
      if (item.isFree) {
        return SizedBox();
      }
      return Padding(
        padding: const EdgeInsets.only(
          top: AppPadding.padding_2,
        ),
        child: SmallTextPriceWidget(
          priceEtb: item.priceEtb,
          priceUsd: item.priceDollar,
          isDiscountAvailable: item.isDiscountAvailable,
          discountPercentage: item.discountPercentage,
          isFree: item.isFree,
          isPurchased: item.isBought,
        ),
      );
    } else if (groupType == GroupType.ALBUM) {
      item as Album;
      return Padding(
        padding: const EdgeInsets.only(
          top: AppPadding.padding_2,
        ),
        child: SmallTextPriceWidget(
          priceEtb: item.priceEtb,
          priceUsd: item.priceDollar,
          isDiscountAvailable: item.isDiscountAvailable,
          discountPercentage: item.discountPercentage,
          isFree: item.isFree,
          isPurchased: item.isBought,
        ),
      );
    } else if (groupType == GroupType.ARTIST) {
      return SizedBox();
    } else {
      return SizedBox();
    }
  }

  static Widget getItemPrice({
    required double priceEtb,
    required IapProduct priceUsd,
    required bool isDiscountAvailable,
    required double discountPercentage,
    required bool isFree,
    required bool isPurchased,
  }) {
    return SmallTextPriceWidget(
      priceEtb: priceEtb,
      priceUsd: priceUsd,
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
            '$title - ${L10nUtil.translateLocale(item.artistsName[0], context)}';
      }

      return title;
    } else if (groupType == GroupType.PLAYLIST) {
      return L10nUtil.translateLocale(
          (item as Playlist).playlistNameText, context);
    } else if (groupType == GroupType.ALBUM) {
      String title =
          '${L10nUtil.translateLocale((item as Album).albumTitle, context)} - ${L10nUtil.translateLocale(item.artist.artistName, context)}';
      return title;
    } else if (groupType == GroupType.ARTIST) {
      return L10nUtil.translateLocale((item as Artist).artistName, context);
    } else {
      return '';
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
        color: ColorMapper.getDarkGrey(),
        fontWeight: FontWeight.w500,
        fontSize: AppFontSizes.font_size_10.sp,
      );
    } else if (groupType == GroupType.PLAYLIST) {
      return TextStyle(
        color: ColorMapper.getDarkGrey(),
        fontWeight: FontWeight.w500,
        fontSize: AppFontSizes.font_size_10.sp,
      );
    } else if (groupType == GroupType.ALBUM) {
      return TextStyle(
        color: ColorMapper.getDarkGrey(),
        fontWeight: FontWeight.w500,
        fontSize: AppFontSizes.font_size_10.sp,
      );
    } else if (groupType == GroupType.ARTIST) {
      return TextStyle(
        color: ColorMapper.getDarkGrey(),
        fontWeight: FontWeight.w500,
        fontSize: AppFontSizes.font_size_10.sp,
      );
    } else {
      return TextStyle(
        color: ColorMapper.getDarkGrey(),
        fontWeight: FontWeight.w500,
        fontSize: AppFontSizes.font_size_10.sp,
      );
    }
  }

  static String albumTitle(Album album, context) {
    String title =
        '${L10nUtil.translateLocale(album.albumTitle, context)} - ${L10nUtil.translateLocale(album.artist.artistName, context)}';
    return title;
  }

  static void groupItemOnClick({
    required GroupType groupType,
    required dynamic item,
    required PlayingFrom playingFrom,
    required List<dynamic> items,
    required BuildContext context,
    required int index,
    bool openPlayerPage = true,
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

      if (openPlayerPage) {
        //NAVIGATE TO PLAYER PAGE
        Navigator.of(context, rootNavigator: true).push(
          createBottomToUpAnimatedRoute(
            page: PlayerPage(),
          ),
        );
      }
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
      SettingsDataProvider(),
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
      downloadUtil,
      songs,
      playingFrom,
      context,
      SettingsDataProvider(),
    );
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
      downloadUtil,
      songs,
      playingFrom,
      context,
      SettingsDataProvider(),
    );
    //SET PLAYER QUEUE
    BlocProvider.of<AudioPlayerBloc>(context).add(
      SetPlayerQueueEvent(
        queue: audioSourceItems,
        startPlaying: startPlaying,
        index: index,
      ),
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

  static Color getLoopDarkButtonColor(LoopMode loopMode) {
    if (loopMode == LoopMode.off) {
      return ColorMapper.getWhite().withOpacity(0.5);
    } else if (loopMode == LoopMode.all) {
      return ColorMapper.getWhite();
    } else if (loopMode == LoopMode.one) {
      return ColorMapper.getWhite();
    } else {
      return ColorMapper.getWhite().withOpacity(0.5);
    }
  }

  static Color getLoopLightButtonColor(LoopMode loopMode) {
    if (loopMode == LoopMode.off) {
      return ColorMapper.getBlack();
    } else if (loopMode == LoopMode.all) {
      return ColorMapper.getDarkOrange();
    } else if (loopMode == LoopMode.one) {
      return ColorMapper.getDarkOrange();
    } else {
      return ColorMapper.getBlack();
    }
  }

  static IconData? getLoopIcon(LoopMode loopMode) {
    if (loopMode == LoopMode.off) {
      return FlutterRemix.repeat_line;
    } else if (loopMode == LoopMode.all) {
      return FlutterRemix.repeat_line;
    } else if (loopMode == LoopMode.one) {
      return FlutterRemix.repeat_one_line;
    } else {
      return FlutterRemix.repeat_one_line;
    }
  }

  static String formatSongDurationTimeTo(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
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
    return '';
  }

  static String getSearchFrontPageItemImageUrl(
      AppItemsType appItemsType, dynamic item) {
    if (appItemsType == AppItemsType.CATEGORY) {
      return (item as Category).categoryImage.imageLargePath;
    } else if (appItemsType == AppItemsType.ARTIST) {
      return (item as Artist).artistImages[0].imageLargePath;
    } else if (appItemsType == AppItemsType.SINGLE_TRACK) {
      return (item as Song).albumArt.imageLargePath;
    }
    return '';
  }

  static Color getSearchFrontPageDominantColor(
      AppItemsType appItemsType, dynamic item) {
    if (appItemsType == AppItemsType.CATEGORY) {
      item as Category;

      // return ColorUtil.darken(
      //   ColorUtil.changeColorSaturation(
      //     HexColor(item.categoryImage.primaryColorHex),
      //     0.8,
      //   ),
      //   0.05,
      // );
      return HexColor(item.categoryImage.primaryColorHex);
    } else if (appItemsType == AppItemsType.ARTIST) {
      item as Artist;
      // return ColorUtil.darken(
      //   ColorUtil.changeColorSaturation(
      //     HexColor(item.artistImages[0].primaryColorHex),
      //     0.8,
      //   ),
      //   0.05,
      // );
      return HexColor(item.artistImages[0].primaryColorHex);
    } else if (appItemsType == AppItemsType.SINGLE_TRACK) {
      item as Song;
      // return ColorUtil.darken(
      //   ColorUtil.changeColorSaturation(
      //     HexColor(item.albumArt.primaryColorHex),
      //     0.8,
      //   ),
      //   0.05,
      // );
      return HexColor(item.albumArt.primaryColorHex);
    }
    return AppColors.appGradientDefaultColor;
  }

  static void showMenuSheet({
    required BuildContext context,
    required Widget child,
  }) {
    showModalBottomSheet(
      backgroundColor: AppColors.transparent,
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: true,
      builder: (context) {
        return child;
      },
    );
  }

  static getRecentItemId(item) {
    if (item is Song) {
      return '${EnumToString.convertToString(AppItemsType.SINGLE_TRACK)}_${item.songId}';
    } else if (item is Playlist) {
      return '${EnumToString.convertToString(AppItemsType.PLAYLIST)}_${item.playlistId}';
    } else if (item is Artist) {
      return '${EnumToString.convertToString(AppItemsType.ARTIST)}_${item.artistId}';
    } else if (item is Album) {
      return '${EnumToString.convertToString(AppItemsType.ALBUM)}_${item.albumId}';
    }
    throw 'ITEM NOT SEARCHED TYPES';
  }

  static String getItemKey(dynamic item) {
    if (item is Song) {
      return 'song_${item.songId}';
    } else if (item is Playlist) {
      return 'playlist_${item.playlistId}';
    } else if (item is Album) {
      return 'album_${item.albumId}';
    } else if (item is Artist) {
      return 'artist_${item.artistId}';
    } else {
      throw 'Unknown Recent type';
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
        withShadow: false,
        radius: 4.0,
        child: CachedNetworkImage(
          width: AppValues.libraryMusicItemSize,
          height: AppValues.libraryMusicItemSize,
          fit: BoxFit.cover,
          imageUrl: myPlaylist.playlistImage!.imageLargePath,
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
          withShadow: false,
          radius: 4.0,
          child: CachedNetworkImage(
            width: AppValues.libraryMusicItemSize,
            height: AppValues.libraryMusicItemSize,
            fit: BoxFit.cover,
            imageUrl: myPlaylist.gridSongImages.elementAt(0).imageLargePath,
            placeholder: (context, url) =>
                buildImagePlaceHolder(AppItemsType.SINGLE_TRACK),
            errorWidget: (context, url, e) =>
                buildImagePlaceHolder(AppItemsType.SINGLE_TRACK),
          ),
        );
      }
      if (myPlaylist.gridSongImages.length >= 4) {
        return AppCard(
          withShadow: false,
          radius: 4.0,
          child: GridView.count(
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
                  imageUrl: myPlaylist.gridSongImages
                      .elementAt(index)
                      .imageMediumPath,
                  placeholder: (context, url) =>
                      buildImagePlaceHolder(AppItemsType.OTHER),
                  errorWidget: (context, url, e) =>
                      buildImagePlaceHolder(AppItemsType.OTHER),
                );
              },
            ),
          ),
        );
      }
    }
    return AppCard(
      withShadow: false,
      radius: 4.0,
      child: CachedNetworkImage(
        width: AppValues.libraryMusicItemSize,
        height: AppValues.libraryMusicItemSize,
        fit: BoxFit.cover,
        imageUrl: AppApi.baseUrl,
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
        color: ColorMapper.getLightGrey(),
      );
    }
    return AppItemsImagePlaceHolder(appItemsType: appItemsType);
  }

  static String getUserPlaylistByText(MyPlaylist myPlaylist, context) {
    return '${AppLocale.of().by.toUpperCase()} ${AuthUtil.getUserName(BlocProvider.of<AppUserWidgetsCubit>(context).state).toUpperCase()}';
  }

  static String getUserPlaylistDescription(MyPlaylist myPlaylist, context) {
    return L10nUtil.translateLocale(
      myPlaylist.playlistDescriptionText,
      context,
    );
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
              '#${dominantColor.value.toRadixString(16)}',
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
    final bool isUserSubscribed = PagesUtilFunctions.isUserSubscribed();
    if (PagesUtilFunctions.isNotFreeBoughtAndSubscribed(song)) {
      return song.audioFile.audioPreviewDurationSeconds;
    }
    return song.audioFile.audioDurationSeconds;
  }

  static String getFormatdMaxSongDuration(Song song) {
    final bool isUserSubscribed = PagesUtilFunctions.isUserSubscribed();
    if (PagesUtilFunctions.isNotFreeBoughtAndSubscribed(song)) {
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

  static String getPaymentMethodName(
      AppPaymentMethods appPaymentMethod, context) {
    if (appPaymentMethod == AppPaymentMethods.METHOD_INAPP) {
      return Platform.isAndroid
          ? AppLocale.of().googlePlayInappPurcahses
          : AppLocale.of().appStoreInappPurcahses;
    } else if (appPaymentMethod == AppPaymentMethods.METHOD_TELEBIRR) {
      return AppLocale.of().telebirr;
    } else if (appPaymentMethod == AppPaymentMethods.METHOD_YENEPAY) {
      return AppLocale.of().yenepay;
    } else {
      return 'Unknown';
    }
  }

  static void takeAPhoto({
    required BuildContext context,
    required VoidCallback onImageChanged,
  }) async {
    var camStatus = await Permission.camera.status;
    var photoStatus = await Permission.photos.status;

    ///ASK FOR CAMERA PERMISSION
    List<AppPermission> permissionList = [];
    if (camStatus.isPermanentlyDenied) {
      permissionList.add(
        AppPermission(
          AppLocale.of().cameraAccess,
          FlutterRemix.camera_line,
        ),
      );
    }

    ///ASK FOR PHOTO PERMISSION
    if (photoStatus.isPermanentlyDenied) {
      permissionList.add(
        AppPermission(
          AppLocale.of().photoAccess,
          FlutterRemix.image_line,
        ),
      );
    }

    if (permissionList.length > 0) {
      showDialog(
        context: context,
        builder: (context) {
          return DialogPermissionPermanentlyRefused(
            onGoToSetting: () {
              ///GO TO APP SETTINGS TO ALLOW PERMISSIONS
              AppSettings.openAppSettings();
            },
            permissionList: permissionList,
          );
        },
      );
    } else {
      onImageChanged();
      BlocProvider.of<ImagePickerCubit>(context).getFromCamera();
      Navigator.pop(context);
    }
  }

  static void getFromGallery({
    required BuildContext context,
    required VoidCallback onImageChanged,
  }) async {
    var photoStatus = await Permission.photos.status;

    List<AppPermission> permissionList = [];

    ///ASK FOR PHOTO PERMISSION
    if (photoStatus.isPermanentlyDenied) {
      permissionList.add(
        AppPermission(
          AppLocale.of().photoAccess,
          FlutterRemix.image_line,
        ),
      );
    }

    if (permissionList.length > 0) {
      showDialog(
        context: context,
        builder: (context) {
          return DialogPermissionPermanentlyRefused(
            onGoToSetting: () {
              ///GO TO APP SETTINGS TO ALLOW PERMISSIONS
              AppSettings.openAppSettings();
            },
            permissionList: permissionList,
          );
        },
      );
    } else {
      onImageChanged();
      BlocProvider.of<ImagePickerCubit>(context).getFromGallery();
      Navigator.pop(context);
    }
  }

  static void rateApp() async {
    final InAppReview inAppReview = InAppReview.instance;
    inAppReview.openStoreListing(
      appStoreId: AppValues.appStoreId,
    );

    ///REMOVE requestReview BECAUSE OF QUOTA ISSUE AND
    ///SHOULD NOT BE IMPLEMENTED WITH A BUTTON CLICK
    //bool isAvailable = await inAppReview.isAvailable();
    // if (isAvailable) {
    //   inAppReview.requestReview();
    // } else {
    //   inAppReview.openStoreListing(
    //     appStoreId: AppValues.appStoreId,
    //   );
    // }
  }

  static void shareApp() async {
    String appLink;
    if (Platform.isIOS) {
      appLink = 'https://apps.apple.com/us/app/mehaleye/id1616875830';
    } else {
      appLink =
          'https://play.google.com/store/apps/details?id=com.marathonsystems.mehaleye';
    }
    await Share.share(
      'check out Mehaleye, Ethiopia Orthodox Mezmur Streaming App $appLink',
    );
  }

  static SystemUiOverlayStyle getStatusBarStyle() {
    return SystemUiOverlayStyle(
      statusBarBrightness:
          AppEnv.isMehaleye() ? Brightness.light : Brightness.dark,
      statusBarColor: AppColors.transparent,
      statusBarIconBrightness:
          AppEnv.isMehaleye() ? Brightness.dark : Brightness.light,
    );
  }

  static getIsExplicitTag(GroupType groupType, item) {
    if (groupType == GroupType.SONG) {
      item as Song;
      if (item.isOnlyOnElf) {
        return Padding(
          padding: const EdgeInsets.only(
            top: AppPadding.padding_4,
          ),
          child: SongItemBadge(
            tag: AppLocale.of().onlyOnElf.toUpperCase(),
          ),
        );
      }
    }
    return SizedBox();
  }

  static Future<String> getAppVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    //String buildNumber = packageInfo.buildNumber;

    return version;
  }

  static getUserGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return AppLocale.of().goodMorning;
    }
    if (hour < 17) {
      return AppLocale.of().goodAfterNoon;
    }
    return AppLocale.of().goodEvening;
  }

  static void openYtPlayerPage(context, Song songVideo, bool shouldPop) {
    String videoLink =
        songVideo.youtubeUrl != null ? songVideo.youtubeUrl! : '';

    ///STOP PLAYER IF PLAYING
    BlocProvider.of<AudioPlayerBloc>(context).add(
      PauseEvent(),
    );

    String? videoId = YoutubePlayer.convertUrlToId(videoLink);

    if (videoId != null) {
      ///NAVIGATE TO PLAYER PAGE
      if (shouldPop == true) Navigator.pop(context);
      Navigator.of(context, rootNavigator: true).push(
        createBottomToUpAnimatedRoute(
          page: BlocProvider(
            create: (context) => OtherVideosBloc(
              videosRepository: AppRepositories.videosRepository,
            ),
            child: YouTubePlayerPage(
              videoId: videoId,
              songId: songVideo.songId,
              title: L10nUtil.translateLocale(
                songVideo.songName,
                context,
              ),
            ),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        buildAppSnackBar(
          bgColor: AppColors.errorRed,
          txtColor: ColorMapper.getWhite(),
          msg: 'Unable To Play Video',
          isFloating: false,
        ),
      );
    }
  }

  static void openVideoAudioOnly(context, Song songVideo, bool shouldPop) {
    if (shouldPop) Navigator.pop(context);

    ///PLAY AUDIO ONLY
    openSong(
      context: context,
      songs: [songVideo],
      startPlaying: true,
      playingFrom: PlayingFrom(
        from: AppLocale.of().featuredVideos,
        title: PagesUtilFunctions.getArtistsNames(
          songVideo.artistsName,
          context,
        ),
        songSyncPlayedFrom: SongSyncPlayedFrom.UNK,
        songSyncPlayedFromId: -1,
      ),
      index: 0,
    );
  }

  static bool isUserSubscribed() {
    bool isUserSubscribed = IapSubscriptionRepository(
      iapSubscriptionProvider: IapSubscriptionProvider(),
    ).getUserIsSubscribes();

    bool isIapAvailable = IapPurchaseRepository(
      iapPurchaseProvider: IapPurchaseProvider(),
    ).getIsIapAvailable();
    if (isUserSubscribed & isIapAvailable) {
      return true;
    } else {
      return false;
    }
  }

  static bool isIapAvailable() {
    ///Check Is Iap Available
    ///CHECK IF ANDROID AND ALWAYS ALLOW FOR IOS
    if (Platform.isAndroid) {
      bool isIapAvailable = IapPurchaseRepository(
        iapPurchaseProvider: IapPurchaseProvider(),
      ).getIsIapAvailable();

      return isIapAvailable;
    } else {
      return true;
    }
  }

  static offlineSongOnClick(
      context, Song song, List<Song> offlineSong, int position) async {
    DownloadTask? downloadTask = await DownloadUtil().getSongDownloadTask(song);
    if (downloadTask != null) {
      ///GET VALUES
      final bool isSongDownloadedWithSubscription =
          DownloadUtil.getIsUserSubscribedPortion(downloadTask.url) == '1'
              ? true
              : false;
      final bool isUserSubscribed = PagesUtilFunctions.isUserSubscribed();

      ///IF SONG DOWNLOADED WITH SUBSCRIPTION AND IS NOT BOUGHT AND IS NOT FREE
      ///AND SUBSCRIPTION IS NOT ACTIVE SHOW DIALOG
      if (isSongDownloadedWithSubscription &&
          !isUserSubscribed &&
          !song.isBought &&
          !song.isFree) {
        showDialog(
          context: context,
          builder: (_) {
            return Center(
              child: DialogOfflineSongSubscribeToListen(
                onSubscribeButtonClicked: () {
                  Navigator.pushNamed(
                    context,
                    AppRouterPaths.subscriptionRoute,
                  );
                },
              ),
            );
          },
        );
      } else {
        //OPEN SONG
        PagesUtilFunctions.openSong(
          context: context,
          songs: offlineSong,
          startPlaying: true,
          playingFrom: PlayingFrom(
            from: AppLocale.of().playingFrom,
            title: AppLocale.of().offlineMezmurs,
            songSyncPlayedFrom: SongSyncPlayedFrom.OFFLINE_PAGE,
            songSyncPlayedFromId: -1,
          ),
          index: position,
        );
      }
    } else {
      //OPEN SONG
      PagesUtilFunctions.openSong(
        context: context,
        songs: offlineSong,
        startPlaying: true,
        playingFrom: PlayingFrom(
          from: AppLocale.of().playingFrom,
          title: AppLocale.of().offlineMezmurs,
          songSyncPlayedFrom: SongSyncPlayedFrom.OFFLINE_PAGE,
          songSyncPlayedFromId: -1,
        ),
        index: position,
      );
    }
  }

  static bool isUrlsEqual(Uri curUrl, Uri successReturnUrl) {
    if (curUrl.host == successReturnUrl.host &&
        curUrl.path == successReturnUrl.path) {
      return true;
    }
    return false;
  }

  static String getIapPurchasedMessage(
      AppPurchasedItemType appPurchasedItemType) {
    if (appPurchasedItemType == AppPurchasedItemType.SONG_PAYMENT) {
      return AppLocale.of().songPurchased;
    } else if (appPurchasedItemType == AppPurchasedItemType.PLAYLIST_PAYMENT) {
      return AppLocale.of().playlistPurchased;
    } else if (appPurchasedItemType == AppPurchasedItemType.ALBUM_PAYMENT) {
      return AppLocale.of().albumPurchased;
    } else {
      return 'Purchase Completed';
    }
  }

  static bool isNotFreeBoughtAndSubscribed(Song song) {
    final bool isUserSubscribed = PagesUtilFunctions.isUserSubscribed();

    if (!song.isFree && !song.isBought && !isUserSubscribed) return true;
    return false;
  }

  static bool isFreeBoughtOrSubscribed(Song currentPlayingSong) {
    final bool isUserSubscribed = PagesUtilFunctions.isUserSubscribed();

    if (currentPlayingSong.isFree ||
        currentPlayingSong.isBought ||
        isUserSubscribed) return true;
    return false;
  }

  static getPhoneInputLengthByCountryCode(String code) {
    Map? country = CountryCodesList.codes.firstWhereOrNull(
      (element) =>
          element['iso2_cc'].toString().toLowerCase() == code.toLowerCase(),
    );
    if (country != null) {
      return country['example'].toString().length + 2;
    }
    return 12;
  }

  static String getPhoneInputMask(CountryCode countryCode) {
    Map? country = CountryCodesList.codes.firstWhereOrNull(
      (element) =>
          element['iso2_cc'].toString().toLowerCase() ==
          countryCode.code!.toLowerCase(),
    );

    if (country != null) {
      int length = country['example'].length;
      String formattedPhone = '';

      for (var i = 0; i < length; i++) {
        if (i == 3) {
          formattedPhone = formattedPhone + '-' + '0';
        } else if (i == 6) {
          formattedPhone = formattedPhone + '-' + '0';
        } else {
          formattedPhone = formattedPhone + '0';
        }
      }

      return formattedPhone;
    } else {
      return "000-000-00000";
    }
  }

  static bool validatePhoneByCountryCode(String code, String text) {
    Map? country = CountryCodesList.codes.firstWhereOrNull(
      (element) =>
          element['iso2_cc'].toString().toLowerCase() == code.toLowerCase(),
    );

    if (country != null) {
      return text.length == country['example'].toString().length + 2;
    }
    return false;
  }

  static String getSubscriptionsOfferingButtonTxt(
      SubscriptionOfferings subscriptionOfferings) {
    if (Platform.isIOS) {
      if (subscriptionOfferings.iosAdditionalInfo != null) {
        return subscriptionOfferings.iosAdditionalInfo!.buttonTitle;
      }
    }
    return AppLocale.of().tryForFree.toUpperCase();
  }

  static String getSubscriptionsOfferingPriceDescTxt(
      SubscriptionOfferings subscriptionOfferings) {
    if (Platform.isIOS) {
      if (subscriptionOfferings.iosAdditionalInfo != null) {
        return subscriptionOfferings.iosAdditionalInfo!.priceDescription;
      }
    }
    return subscriptionOfferings.priceDescription;
  }

  static bool isValidIpAddress(String text) {
    final RegExp _ipRegex = RegExp(
        r"^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$");
    return _ipRegex.hasMatch(text);
  }
}
