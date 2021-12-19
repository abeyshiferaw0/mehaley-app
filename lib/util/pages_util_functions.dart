import 'dart:io';
import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:mehaley/business_logic/blocs/payment_blocs/purcahsed_item_status_bloc/purchase_item_status_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/purchase_item_bloc/purchase_item_bloc.dart';
import 'package:mehaley/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:mehaley/business_logic/blocs/user_playlist_bloc/user_playlist_bloc.dart';
import 'package:mehaley/business_logic/blocs/wallet_bloc/wallet_bill_cancel_bloc/wallet_bill_cancel_bloc.dart';
import 'package:mehaley/business_logic/blocs/wallet_bloc/wallet_bill_status_bloc/wallet_bill_status_bloc.dart';
import 'package:mehaley/business_logic/blocs/wallet_bloc/wallet_history_bloc/wallet_history_bloc.dart';
import 'package:mehaley/business_logic/blocs/wallet_bloc/wallet_page_bloc/wallet_page_bloc.dart';
import 'package:mehaley/business_logic/blocs/wallet_bloc/wallet_recharge_initial_bloc/wallet_recharge_initial_bloc.dart';
import 'package:mehaley/business_logic/cubits/app_user_widgets_cubit.dart';
import 'package:mehaley/business_logic/cubits/image_picker_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/business_logic/cubits/wallet/fresh_wallet_bill_cubit.dart';
import 'package:mehaley/config/app_repositories.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
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
import 'package:mehaley/data/models/payment/wallet_history.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/data/models/text_lan.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/dialog/dialog_permission_permanent_refused.dart';
import 'package:mehaley/ui/common/dialog/payment/dialog_wallet_cart_checkout.dart';
import 'package:mehaley/ui/common/dialog/payment/dialog_wallet_cart_checkout_status.dart';
import 'package:mehaley/ui/common/dialog/payment/dialog_wallet_purchase.dart';
import 'package:mehaley/ui/common/dialog/payment/dialog_wallet_purchase_status.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/ui/common/small_text_price_widget.dart';
import 'package:mehaley/ui/common/song_item/song_item_badge.dart';
import 'package:mehaley/ui/screens/player/player_page.dart';
import 'package:mehaley/ui/screens/profile/edit_profile_page.dart';
import 'package:mehaley/ui/screens/user_playlist/create_user_playlist_page.dart';
import 'package:mehaley/ui/screens/user_playlist/edit_user_playlist_page.dart';
import 'package:mehaley/ui/screens/wallet/dialogs/dialog_wallet_recharge_initial.dart';
import 'package:mehaley/ui/screens/wallet/how_to_pay_page.dart';
import 'package:mehaley/ui/screens/wallet/wallet_page.dart';
import 'package:mehaley/util/app_extention.dart';
import 'package:mehaley/util/auth_util.dart';
import 'package:mehaley/util/color_util.dart';
import 'package:mehaley/util/download_util.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
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
      return AppApi.baseUrl + (item as Song).albumArt.imageMediumPath;
    } else if (groupType == GroupType.PLAYLIST) {
      return AppApi.baseUrl + (item as Playlist).playlistImage.imageMediumPath;
    } else if (groupType == GroupType.ALBUM) {
      return AppApi.baseUrl + (item as Album).albumImages[0].imageMediumPath;
    } else if (groupType == GroupType.ARTIST) {
      return AppApi.baseUrl + (item as Artist).artistImages[0].imageMediumPath;
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
    required double priceUsd,
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
        color: AppColors.darkGrey,
        fontWeight: FontWeight.w500,
        fontSize: AppFontSizes.font_size_10.sp,
      );
    } else if (groupType == GroupType.PLAYLIST) {
      return TextStyle(
        color: AppColors.darkGrey,
        fontWeight: FontWeight.w500,
        fontSize: AppFontSizes.font_size_10.sp,
      );
    } else if (groupType == GroupType.ALBUM) {
      return TextStyle(
        color: AppColors.darkGrey,
        fontWeight: FontWeight.w500,
        fontSize: AppFontSizes.font_size_10.sp,
      );
    } else if (groupType == GroupType.ARTIST) {
      return TextStyle(
        color: AppColors.darkGrey,
        fontWeight: FontWeight.w500,
        fontSize: AppFontSizes.font_size_10.sp,
      );
    } else {
      return TextStyle(
        color: AppColors.darkGrey,
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
      return AppColors.white.withOpacity(0.5);
    } else if (loopMode == LoopMode.all) {
      return AppColors.white;
    } else if (loopMode == LoopMode.one) {
      return AppColors.white;
    } else {
      return AppColors.white.withOpacity(0.5);
    }
  }

  static Color getLoopLightButtonColor(LoopMode loopMode) {
    if (loopMode == LoopMode.off) {
      return AppColors.black;
    } else if (loopMode == LoopMode.all) {
      return AppColors.darkOrange;
    } else if (loopMode == LoopMode.one) {
      return AppColors.darkOrange;
    } else {
      return AppColors.black;
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
      return AppApi.baseUrl + (item as Category).categoryImage.imageSmallPath;
    } else if (appItemsType == AppItemsType.ARTIST) {
      return AppApi.baseUrl + (item as Artist).artistImages[0].imageSmallPath;
    } else if (appItemsType == AppItemsType.SINGLE_TRACK) {
      return AppApi.baseUrl + (item as Song).albumArt.imageSmallPath;
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
        radius: 2.0,
        child: CachedNetworkImage(
          width: AppValues.libraryMusicItemSize,
          height: AppValues.libraryMusicItemSize,
          fit: BoxFit.cover,
          imageUrl: AppApi.baseUrl + myPlaylist.playlistImage!.imageMediumPath,
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
          radius: 2.0,
          child: CachedNetworkImage(
            width: AppValues.libraryMusicItemSize,
            height: AppValues.libraryMusicItemSize,
            fit: BoxFit.cover,
            imageUrl: AppApi.baseUrl +
                myPlaylist.gridSongImages.elementAt(0).imageMediumPath,
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
          radius: 2.0,
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
                  imageUrl: AppApi.baseUrl +
                      myPlaylist.gridSongImages.elementAt(index).imageSmallPath,
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
      radius: 2.0,
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
        color: AppColors.lightGrey,
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

  static String getPaymentMethodName(
      AppPaymentMethods appPaymentMethod, context) {
    if (appPaymentMethod == AppPaymentMethods.METHOD_HELLO_CASH) {
      return AppLocale.of().helloCash;
    } else if (appPaymentMethod == AppPaymentMethods.METHOD_MBIRR) {
      return AppLocale.of().mbirr;
    } else if (appPaymentMethod == AppPaymentMethods.METHOD_CBE_BIRR) {
      return AppLocale.of().cbeBirr;
    } else if (appPaymentMethod == AppPaymentMethods.METHOD_AMOLE) {
      return AppLocale.of().amole;
    } else if (appPaymentMethod == AppPaymentMethods.METHOD_VISA) {
      return AppLocale.of().visa;
    } else if (appPaymentMethod == AppPaymentMethods.METHOD_MASTERCARD) {
      return AppLocale.of().mastercard;
    } else {
      return 'Unknown';
    }
  }

  static String getPaymentMethodIcon(AppPaymentMethods appPaymentMethod) {
    if (appPaymentMethod == AppPaymentMethods.METHOD_HELLO_CASH) {
      return 'assets/icons/payment_icons/ic_hello_cash.png';
    } else if (appPaymentMethod == AppPaymentMethods.METHOD_MBIRR) {
      return 'assets/icons/payment_icons/ic_mbirr.png';
    } else if (appPaymentMethod == AppPaymentMethods.METHOD_CBE_BIRR) {
      return 'assets/icons/payment_icons/ic_cbe_birr.png';
    } else if (appPaymentMethod == AppPaymentMethods.METHOD_AMOLE) {
      return 'assets/icons/payment_icons/ic_amole.png';
    } else if (appPaymentMethod == AppPaymentMethods.METHOD_VISA) {
      return 'assets/icons/payment_icons/ic_visa.png';
    } else if (appPaymentMethod == AppPaymentMethods.METHOD_MASTERCARD) {
      return 'assets/icons/payment_icons/ic_mastercard.png';
    } else {
      return '';
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
    bool isAvailable = await inAppReview.isAvailable();
    if (isAvailable) {
      inAppReview.requestReview();
    } else {
      inAppReview.openStoreListing(
        appStoreId: AppValues.appStoreId,
      );
    }
  }

  static void shareApp() async {
    String appLink;
    if (Platform.isIOS) {
      appLink = 'https://apps.apple.com/app/id1600274398';
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
      statusBarBrightness: Brightness.light,
      statusBarColor: AppColors.transparent,
      statusBarIconBrightness: Brightness.dark,
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

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    print("packageInfo=> ${packageInfo.packageName}");

    return version;
  }

  static void goToWalletPage(context,
      {bool startRechargeProcess = false,
      bool showHowToPayOnInit = false,
      bool copyCodeOnInit = false,
      String codeToCopy = ''}) {
    Navigator.of(context, rootNavigator: true).push(
      PagesUtilFunctions.createBottomToUpAnimatedRoute(
        page: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => WalletPageBloc(
                walletDataRepository: AppRepositories.walletDataRepository,
              ),
            ),
            BlocProvider(
              create: (context) => WalletBillStatusBloc(
                walletDataRepository: AppRepositories.walletDataRepository,
              ),
            ),
            BlocProvider(
              create: (context) => WalletBillCancelBloc(
                walletDataRepository: AppRepositories.walletDataRepository,
              ),
            ),
            BlocProvider(
              create: (context) => WalletHistoryBloc(
                walletDataRepository: AppRepositories.walletDataRepository,
              ),
            ),
          ],
          child: WalletPage(
            startRechargeProcess: startRechargeProcess,
            showHowToPayOnInit: showHowToPayOnInit,
            copyCodeOnInit: copyCodeOnInit,
            codeToCopy: codeToCopy,
          ),
        ),
      ),
    );
  }

  static openWalletRechargeInitialDialog(context) {
    ///GET PROVIDERS BEFORE PASSING BY VALUE
    WalletPageBloc walletPageBloc = BlocProvider.of<WalletPageBloc>(context);
    FreshWalletBillCubit freshWalletBillCubit =
        BlocProvider.of<FreshWalletBillCubit>(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      isDismissible: true,
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => WalletRechargeInitialBloc(
                walletDataRepository: AppRepositories.walletDataRepository,
              ),
            ),
            BlocProvider.value(value: walletPageBloc),
            BlocProvider.value(value: freshWalletBillCubit),
          ],
          child: DialogWalletRechargeInitial(),
        );
      },
    );
  }

  static void goToHowToPayPage(context, String initialUrl) {
    Navigator.of(context, rootNavigator: true).push(
      PagesUtilFunctions.createBottomToUpAnimatedRoute(
        page: HowToPayPage(
          initialUrl: initialUrl,
        ),
      ),
    );
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

  static String getWalletHistoryAction(WalletHistory walletHistory) {
    if (walletHistory.walletHistoryItemType == PurchasedItemType.SONG_PAYMENT) {
      return AppLocale.of().songPurchased;
    } else if (walletHistory.walletHistoryItemType ==
        PurchasedItemType.ALBUM_PAYMENT) {
      return AppLocale.of().albumPurchased;
    } else if (walletHistory.walletHistoryItemType ==
        PurchasedItemType.PLAYLIST_PAYMENT) {
      return AppLocale.of().playlistPurchased;
    } else if (walletHistory.walletHistoryItemType ==
        PurchasedItemType.CART_PAYMENT) {
      return AppLocale.of().cartCheckOut;
    } else if (walletHistory.walletHistoryItemType ==
        PurchasedItemType.WALLET_RECHARGE) {
      return AppLocale.of().walletRecharged;
    } else if (walletHistory.walletHistoryItemType ==
        PurchasedItemType.WALLET_GIFT) {
      return AppLocale.of().giftReceived;
    }
    return '';
  }

  static String getWalletHistoryPrice(WalletHistory walletHistory) {
    if (walletHistory.walletHistoryItemType == PurchasedItemType.SONG_PAYMENT) {
      return '-${walletHistory.amount.parsePriceAmount()}';
    } else if (walletHistory.walletHistoryItemType ==
        PurchasedItemType.ALBUM_PAYMENT) {
      return '-${walletHistory.amount.parsePriceAmount()}';
    } else if (walletHistory.walletHistoryItemType ==
        PurchasedItemType.PLAYLIST_PAYMENT) {
      return '-${walletHistory.amount.parsePriceAmount()}';
    } else if (walletHistory.walletHistoryItemType ==
        PurchasedItemType.CART_PAYMENT) {
      return '-${walletHistory.amount.parsePriceAmount()}';
    } else if (walletHistory.walletHistoryItemType ==
        PurchasedItemType.WALLET_RECHARGE) {
      return '+${walletHistory.amount.parsePriceAmount()}';
    } else if (walletHistory.walletHistoryItemType ==
        PurchasedItemType.WALLET_GIFT) {
      return '+${walletHistory.amount.parsePriceAmount()}';
    }
    return '${walletHistory.amount.parsePriceAmount()}';
  }

  static Color getWalletHistoryPriceColor(WalletHistory walletHistory) {
    if (walletHistory.walletHistoryItemType == PurchasedItemType.SONG_PAYMENT) {
      return AppColors.errorRed;
    } else if (walletHistory.walletHistoryItemType ==
        PurchasedItemType.ALBUM_PAYMENT) {
      return AppColors.errorRed;
    } else if (walletHistory.walletHistoryItemType ==
        PurchasedItemType.PLAYLIST_PAYMENT) {
      return AppColors.errorRed;
    } else if (walletHistory.walletHistoryItemType ==
        PurchasedItemType.CART_PAYMENT) {
      return AppColors.errorRed;
    } else if (walletHistory.walletHistoryItemType ==
        PurchasedItemType.WALLET_RECHARGE) {
      return AppColors.green;
    } else if (walletHistory.walletHistoryItemType ==
        PurchasedItemType.WALLET_GIFT) {
      return AppColors.green;
    }
    return AppColors.black;
  }

  static void openPurchaseStatusDialog({
    required context,
    required purchasedItemType,
    required itemId,
    required String itemImageUrl,
    required String itemTitle,
    required String itemSubTitle,
    required VoidCallback onPurchasesSuccess,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => PurchaseItemStatusBloc(
            paymentRepository: AppRepositories.paymentRepository,
          ),
          child: DialogWalletPurchaseStatus(
            purchasedItemType: purchasedItemType,
            itemImageUrl: itemImageUrl,
            itemTitle: itemTitle,
            itemSubTitle: itemSubTitle,
            itemId: itemId,
            onPurchasesSuccess: onPurchasesSuccess,
          ),
        );
      },
    );
  }

  static void openCartCheckOutStatusDialog({
    required context,
    required VoidCallback onPurchasesSuccess,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => PurchaseItemStatusBloc(
            paymentRepository: AppRepositories.paymentRepository,
          ),
          child: DialogCartCheckOutStatus(
            onPurchasesSuccess: onPurchasesSuccess,
          ),
        );
      },
    );
  }

  static void openPurchaseItemDialog({
    required context,
    required itemId,
    required purchasedItemType,
    required itemImageUrl,
    required itemTitle,
    required itemSubTitle,
    required priceEtb,
    required balance,
    required onPurchasesSuccess,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BlocProvider(
          create: (context) => PurchaseItemBloc(
            paymentRepository: AppRepositories.paymentRepository,
          ),
          child: DialogWalletPurchase(
            itemId: itemId,
            purchasedItemType: purchasedItemType,
            itemImageUrl: itemImageUrl,
            itemTitle: itemTitle,
            itemSubTitle: itemSubTitle,
            itemPrice: priceEtb,
            balance: balance,
            onPurchasesSuccess: onPurchasesSuccess,
          ),
        );
      },
    );
  }

  static void openCartCheckOutDialog({
    required context,
    required cartTotalPrice,
    required balance,
    required onPurchasesSuccess,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BlocProvider(
          create: (context) => PurchaseItemBloc(
            paymentRepository: AppRepositories.paymentRepository,
          ),
          child: DialogWalletCartCheckOut(
            cartTotalPrice: cartTotalPrice,
            balance: balance,
            onPurchasesSuccess: onPurchasesSuccess,
          ),
        );
      },
    );
  }
}
