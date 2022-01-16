import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/library_page_bloc/purchased_all_songs_bloc/purchased_all_songs_bloc.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
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

class PurchasedAllSongsPage extends StatefulWidget {
  const PurchasedAllSongsPage({
    Key? key,
    required this.onSongsLoaded,
    required this.onPagingController,
  }) : super(key: key);

  final Function(List<Song>) onSongsLoaded;
  final Function(PagingController<int, Song>) onPagingController;

  @override
  _PurchasedAllSongsPageState createState() => _PurchasedAllSongsPageState();
}

class _PurchasedAllSongsPageState extends State<PurchasedAllSongsPage> {
  //PAGINATION CONTROLLER
  final PagingController<int, Song> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    ///FETCH PAGINATED SONGS WITH PAGINATED CONTROLLER
    _pagingController.addPageRequestListener(
      (pageKey) {
        ///INITIALLY LOAD ALL PURCHASED SONGS
        BlocProvider.of<PurchasedAllSongsBloc>(context).add(
          LoadAllPaginatedPurchasedSongsEvent(
            pageSize: AppValues.pageSize,
            page: pageKey,
          ),
        );
      },
    );
    widget.onPagingController(_pagingController);
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
    return BlocListener<PurchasedAllSongsBloc, PurchasedAllSongsState>(
      listener: (context, state) {
        if (state is AllPurchasedPaginatedSongsLoadedState) {
          final isLastPage = state.allPurchasedSong.length < AppValues.pageSize;

          if (_pagingController.itemList != null) {
            widget.onSongsLoaded(_pagingController.itemList!);
          }

          if (isLastPage) {
            _pagingController.appendLastPage(
              state.allPurchasedSong.map((e) => e.song).toList(),
            );
          } else {
            final nextPageKey = state.page + 1;
            _pagingController.appendPage(
              state.allPurchasedSong.map((e) => e.song).toList(),
              nextPageKey,
            );
          }
        }
        if (state is PurchasedAllPaginatedSongsLoadingErrorState) {
          _pagingController.error = AppLocale.of().networkError;
        }
      },
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
                  thumbUrl: item.albumArt.imageSmallPath,
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
                        title: AppLocale.of().purchasedMezmurs,
                        songSyncPlayedFrom: SongSyncPlayedFrom.PURCHASED_SONG,
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
                icon: FlutterRemix.folder_fill,
                msg: AppLocale.of().uDontHavePurchase,
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
            return PaginationErrorWidget(
              onRetry: () {
                _pagingController.refresh();
              },
            );
          },
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
