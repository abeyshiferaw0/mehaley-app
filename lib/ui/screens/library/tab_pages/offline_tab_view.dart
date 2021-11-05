import 'package:elf_play/business_logic/blocs/library_page_bloc/offline_songs_bloc/offline_songs_bloc.dart';
import 'package:elf_play/business_logic/cubits/library/library_tab_pages_cubit.dart';
import 'package:elf_play/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:elf_play/config/app_repositories.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/data/models/sync/song_sync_played_from.dart';
import 'package:elf_play/ui/common/app_snack_bar.dart';
import 'package:elf_play/ui/screens/library/tab_pages/tab_pages/offline_songs_page.dart';
import 'package:elf_play/ui/screens/library/widgets/library_icon_button.dart';
import 'package:elf_play/ui/screens/library/widgets/library_sort_button.dart';
import 'package:elf_play/ui/screens/library/widgets/library_sub_tab_button.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
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
                    currentLocale: Localizations.localeOf(context),
                  ),
                );
                await BlocProvider.of<OfflineSongsBloc>(context).stream.first;
              }
            },
            color: AppColors.darkGreen,
            edgeOffset: AppMargin.margin_16,
            child: Container(
              color: AppColors.black,
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
        //           text: "DOWNLOAD ALL PURCHASED".toUpperCase(),
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
              text: "SORT",
              prefixIcon: PhosphorIcons.sort_ascending,
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
                  from: "playing from",
                  title: "purchased mezmurs",
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
                  msg: "no mezmurs to play",
                  txtColor: AppColors.white,
                ),
              );
            }
          },
          iconColor: AppColors.white,
          icon: PhosphorIcons.shuffle_light,
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
      color: AppColors.darkGrey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sort by",
            style: TextStyle(
              fontSize: AppFontSizes.font_size_8.sp,
              color: AppColors.txtGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
          LibrarySortButton(
            text: "Latest downloads",
            onTap: () {
              ///CHANGE SORT BY VALUES
              setState(() {
                appLibrarySortTypes = AppLibrarySortTypes.LATEST_DOWNLOAD;
              });

              ///
              BlocProvider.of<OfflineSongsBloc>(mContext).add(
                LoadOfflineSongsEvent(
                  appLibrarySortTypes: AppLibrarySortTypes.LATEST_DOWNLOAD,
                  currentLocale: Localizations.localeOf(context),
                ),
              );

              Navigator.pop(dialogContext);
            },
            isSelected:
                appLibrarySortTypes == AppLibrarySortTypes.LATEST_DOWNLOAD,
          ),
          LibrarySortButton(
            text: "Title(A-z)",
            onTap: () {
              ///CHANGE SORT BY VALUES
              setState(() {
                appLibrarySortTypes = AppLibrarySortTypes.TITLE_A_Z;
              });

              ///
              BlocProvider.of<OfflineSongsBloc>(mContext).add(
                LoadOfflineSongsEvent(
                  appLibrarySortTypes: AppLibrarySortTypes.TITLE_A_Z,
                  currentLocale: Localizations.localeOf(context),
                ),
              );

              Navigator.pop(dialogContext);
            },
            isSelected: appLibrarySortTypes == AppLibrarySortTypes.TITLE_A_Z,
          ),
          LibrarySortButton(
            text: "Newest",
            onTap: () {
              ///CHANGE SORT BY VALUES
              setState(() {
                appLibrarySortTypes = AppLibrarySortTypes.NEWEST;
              });

              BlocProvider.of<OfflineSongsBloc>(mContext).add(
                LoadOfflineSongsEvent(
                  appLibrarySortTypes: AppLibrarySortTypes.NEWEST,
                  currentLocale: Localizations.localeOf(context),
                ),
              );
              Navigator.pop(dialogContext);
            },
            isSelected: appLibrarySortTypes == AppLibrarySortTypes.NEWEST,
          ),
          LibrarySortButton(
            text: "Oldest",
            onTap: () {
              ///CHANGE SORT BY VALUES
              setState(() {
                appLibrarySortTypes = AppLibrarySortTypes.OLDEST;
              });

              BlocProvider.of<OfflineSongsBloc>(mContext).add(
                LoadOfflineSongsEvent(
                  appLibrarySortTypes: AppLibrarySortTypes.OLDEST,
                  currentLocale: Localizations.localeOf(context),
                ),
              );
              Navigator.pop(dialogContext);
            },
            isSelected: appLibrarySortTypes == AppLibrarySortTypes.OLDEST,
          ),
          LibrarySortButton(
            text: "Artist(A-z)",
            onTap: () {
              ///CHANGE SORT BY VALUES
              setState(() {
                appLibrarySortTypes = AppLibrarySortTypes.ARTIST_A_Z;
              });

              BlocProvider.of<OfflineSongsBloc>(mContext).add(
                LoadOfflineSongsEvent(
                  appLibrarySortTypes: AppLibrarySortTypes.ARTIST_A_Z,
                  currentLocale: Localizations.localeOf(context),
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
