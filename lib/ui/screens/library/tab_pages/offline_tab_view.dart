import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/library_page_bloc/offline_songs_bloc/offline_songs_bloc.dart';
import 'package:mehaley/business_logic/cubits/library/library_tab_pages_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/config/app_repositories.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/screens/library/tab_pages/tab_pages/offline_songs_page.dart';
import 'package:mehaley/ui/screens/library/widgets/library_icon_button.dart';
import 'package:mehaley/ui/screens/library/widgets/library_sort_button.dart';
import 'package:mehaley/ui/screens/library/widgets/library_sub_tab_button.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

class OfflineTabView extends StatefulWidget {
  const OfflineTabView({Key? key}) : super(key: key);

  @override
  _OfflineTabViewState createState() => _OfflineTabViewState();
}

class _OfflineTabViewState extends State<OfflineTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  ///
  late List<Song> offlineSongs = [];

  ///
  late AppLibrarySortTypes appLibrarySortTypes =
      AppLibrarySortTypes.LATEST_DOWNLOAD;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => OfflineSongsBloc(
        libraryPageDataRepository: AppRepositories.libraryPageDataRepository,
      ),
      child: Builder(
        builder: (context) {
          return RefreshIndicator(
            onRefresh: () async {
              if (BlocProvider.of<LibraryTabPagesCubit>(context).state == 1) {
                BlocProvider.of<OfflineSongsBloc>(context).add(
                  RefreshOfflineSongsEvent(
                    appLibrarySortTypes: appLibrarySortTypes,
                  ),
                );
                await BlocProvider.of<OfflineSongsBloc>(context).stream.first;
              }
            },
            color: AppColors.darkOrange,
            edgeOffset: AppMargin.margin_16,
            child: Container(
              color: AppColors.white,
              height: ScreenUtil(context: context).getScreenHeight(),
              padding: EdgeInsets.only(left: AppPadding.padding_16),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: AppMargin.margin_8),
                    buildSubTabs(),
                    SizedBox(height: AppMargin.margin_8),
                    OfflineSongsPage(
                      onSongsLoaded: (songs) {
                        offlineSongs.clear();
                        offlineSongs.addAll(songs);
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Row buildSubTabs() {
    return Row(
      children: [
        // Expanded(
        //   child: SingleChildScrollView(
        //     scrollDirection: Axis.horizontal,
        //     physics: BouncingScrollPhysics(),
        //     child: Row(
        //       children: [
        //         LibraryPageSubTabButton(
        //           text:AppLocale.of().downloadAllPurchased.toUpperCase(),
        //           isSelected: false,
        //           onTap: () {},
        //           hasLeftMargin: false,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        Builder(
          builder: (context) {
            return LibraryPageSubTabButton(
              text: AppLocale.of().sort.toUpperCase(),
              prefixIcon: FlutterRemix.sort_asc,
              isSelected: true,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  builder: (dialogContext) {
                    return buildSortDialog(context, dialogContext);
                  },
                );
              },
              hasLeftMargin: false,
            );
          },
        ),
        Expanded(
          child: SizedBox(),
        ),
        LibraryIconButton(
          onTap: () {
            if (offlineSongs.length > 0) {
              PagesUtilFunctions.openSongShuffled(
                context: context,
                songs: offlineSongs,
                startPlaying: true,
                playingFrom: PlayingFrom(
                  from: AppLocale.of().playingFrom,
                  title: AppLocale.of().purchasedMezmurs,
                  songSyncPlayedFrom: SongSyncPlayedFrom.OFFLINE_PAGE,
                  songSyncPlayedFromId: -1,
                ),
                index: PagesUtilFunctions.getRandomIndex(
                  min: 0,
                  max: offlineSongs.length,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.blue,
                  isFloating: true,
                  msg: AppLocale.of().noMezmursToPlay,
                  txtColor: AppColors.white,
                ),
              );
            }
          },
          iconColor: AppColors.black,
          icon: FlutterRemix.shuffle_line,
        )
      ],
    );
  }

  Container buildSortDialog(BuildContext mContext, BuildContext dialogContext) {
    return Container(
      width: ScreenUtil(context: context).getScreenWidth(),
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.padding_16,
        vertical: AppPadding.padding_16,
      ),
      color: AppColors.lightGrey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocale.of().sortBy,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_8.sp,
              color: AppColors.txtGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
          LibrarySortButton(
            text: AppLocale.of().latestDownloads,
            onTap: () {
              ///CHANGE SORT BY VALUES
              setState(() {
                appLibrarySortTypes = AppLibrarySortTypes.LATEST_DOWNLOAD;
              });

              ///
              BlocProvider.of<OfflineSongsBloc>(mContext).add(
                LoadOfflineSongsEvent(
                  appLibrarySortTypes: AppLibrarySortTypes.LATEST_DOWNLOAD,
                ),
              );

              Navigator.pop(dialogContext);
            },
            isSelected:
                appLibrarySortTypes == AppLibrarySortTypes.LATEST_DOWNLOAD,
          ),
          LibrarySortButton(
            text: AppLocale.of().titleAz,
            onTap: () {
              ///CHANGE SORT BY VALUES
              setState(() {
                appLibrarySortTypes = AppLibrarySortTypes.TITLE_A_Z;
              });

              ///
              BlocProvider.of<OfflineSongsBloc>(mContext).add(
                LoadOfflineSongsEvent(
                  appLibrarySortTypes: AppLibrarySortTypes.TITLE_A_Z,
                ),
              );

              Navigator.pop(dialogContext);
            },
            isSelected: appLibrarySortTypes == AppLibrarySortTypes.TITLE_A_Z,
          ),
          LibrarySortButton(
            text: AppLocale.of().newest,
            onTap: () {
              ///CHANGE SORT BY VALUES
              setState(() {
                appLibrarySortTypes = AppLibrarySortTypes.NEWEST;
              });

              BlocProvider.of<OfflineSongsBloc>(mContext).add(
                LoadOfflineSongsEvent(
                  appLibrarySortTypes: AppLibrarySortTypes.NEWEST,
                ),
              );
              Navigator.pop(dialogContext);
            },
            isSelected: appLibrarySortTypes == AppLibrarySortTypes.NEWEST,
          ),
          LibrarySortButton(
            text: AppLocale.of().oldest,
            onTap: () {
              ///CHANGE SORT BY VALUES
              setState(() {
                appLibrarySortTypes = AppLibrarySortTypes.OLDEST;
              });

              BlocProvider.of<OfflineSongsBloc>(mContext).add(
                LoadOfflineSongsEvent(
                  appLibrarySortTypes: AppLibrarySortTypes.OLDEST,
                ),
              );
              Navigator.pop(dialogContext);
            },
            isSelected: appLibrarySortTypes == AppLibrarySortTypes.OLDEST,
          ),
          LibrarySortButton(
            text: AppLocale.of().artistAz,
            onTap: () {
              ///CHANGE SORT BY VALUES
              setState(() {
                appLibrarySortTypes = AppLibrarySortTypes.ARTIST_A_Z;
              });

              BlocProvider.of<OfflineSongsBloc>(mContext).add(
                LoadOfflineSongsEvent(
                  appLibrarySortTypes: AppLibrarySortTypes.ARTIST_A_Z,
                ),
              );
              Navigator.pop(dialogContext);
            },
            isSelected: appLibrarySortTypes == AppLibrarySortTypes.ARTIST_A_Z,
          ),
        ],
      ),
    );
  }
}
