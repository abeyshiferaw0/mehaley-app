import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/home_page_blocs/all_songs_page_bloc/all_songs_page_bloc.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/pagination_error_widget.dart';
import 'package:mehaley/ui/common/song_item/song_item.dart';
import 'package:mehaley/ui/screens/library/widgets/library_empty_page.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/screen_util.dart';

class AllSongsTabPage extends StatefulWidget {
  const AllSongsTabPage({Key? key}) : super(key: key);

  @override
  State<AllSongsTabPage> createState() => _AllSongsTabPageState();
}

class _AllSongsTabPageState extends State<AllSongsTabPage>
    with AutomaticKeepAliveClientMixin<AllSongsTabPage> {
  ///TO PRESERVE PAGES STATE
  @override
  bool get wantKeepAlive => true;

  //PAGINATION CONTROLLER
  final PagingController<int, Song> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    ///FETCH PAGINATED SONGS WITH PAGINATED CONTROLLER
    _pagingController.addPageRequestListener(
      (pageKey) {
        ///INITIALLY LOAD ALL PAGINATED SONGS
        BlocProvider.of<AllSongsPageBloc>(context).add(
          LoadAllPaginatedSongsEvent(
            pageSize: AppValues.allSongsPageSize,
            page: pageKey,
          ),
        );
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = ScreenUtil(context: context).getScreenHeight();
    return Container(
      padding: EdgeInsets.only(
        left: AppPadding.padding_16,
        top: AppPadding.padding_16,
      ),
      child: BlocListener<AllSongsPageBloc, AllSongsPageState>(
        listener: (context, state) {
          if (state is AllPaginatedSongsLoadedState) {
            final isLastPage =
                state.paginatedSongs.length < AppValues.allSongsPageSize;

            if (isLastPage) {
              _pagingController.appendLastPage(state.paginatedSongs);
            } else {
              final nextPageKey = state.page + 1;
              _pagingController.appendPage(
                state.paginatedSongs,
                nextPageKey,
              );
            }
          }
          if (state is AllPaginatedSongsLoadingErrorState) {
            _pagingController.error = AppLocale.of().networkError;
          }
        },
        child: RefreshIndicator(
          color: ColorMapper.getDarkOrange(),
          onRefresh: () => Future.sync(
            () => _pagingController.refresh(),
          ),
          child: PagedListView<int, Song>(
            pagingController: _pagingController,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            builderDelegate: PagedChildBuilderDelegate<Song>(
              itemBuilder: (context, item, index) {
                return Column(
                  children: [
                    SizedBox(height: AppMargin.margin_8),
                    SongItem(
                      song: item,
                      isForMyPlaylist: false,
                      thumbUrl: item.albumArt.imageMediumPath,
                      thumbSize: AppValues.playlistSongItemSize,
                      onPressed: () {
                        //OPEN SONG
                        PagesUtilFunctions.openSong(
                          context: context,
                          songs: _pagingController.itemList != null
                              ? _pagingController.itemList!
                              : [],
                          startPlaying: true,
                          playingFrom: PlayingFrom(
                            from: AppLocale.of().playingFrom,
                            title:
                                "${AppLocale.of().all} ${AppLocale.of().mezmurs}",
                            songSyncPlayedFrom: SongSyncPlayedFrom.UNK,
                            songSyncPlayedFromId: -1,
                          ),
                          index: index,
                        );
                      },
                    ),
                    SizedBox(height: AppMargin.margin_8),
                  ],
                );
              },
              noItemsFoundIndicatorBuilder: (context) {
                return Container(
                  height: screenHeight * 0.5,
                  child: LibraryEmptyPage(
                    icon: FlutterRemix.music_2_line,
                    msg: 'empty mezmurs',
                  ),
                );
              },
              newPageProgressIndicatorBuilder: (context) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: AppPadding.padding_8),
                  child: AppLoading(
                    size: 50,
                    strokeWidth: 3,
                  ),
                );
              },
              firstPageProgressIndicatorBuilder: (context) {
                return buildAppLoading(context, screenHeight);
              },
              noMoreItemsIndicatorBuilder: (context) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: AppPadding.padding_8),
                  child: SizedBox(
                    height: 30,
                  ),
                );
              },
              newPageErrorIndicatorBuilder: (context) {
                return PaginationErrorWidget(
                  onRetry: () {
                    _pagingController.retryLastFailedRequest();
                  },
                );
              },
              firstPageErrorIndicatorBuilder: (context) {
                return Container(
                  margin: EdgeInsets.only(
                    top: ScreenUtil(context: context).getScreenHeight() * 0.2,
                  ),
                  child: PaginationErrorWidget(
                    onRetry: () {
                      _pagingController.refresh();
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Container buildAppLoading(BuildContext context, double screenHeight) {
    return Container(
      height: screenHeight * 0.5,
      child: AppLoading(size: AppValues.loadingWidgetSize / 2),
    );
  }
}
