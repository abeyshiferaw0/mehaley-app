import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/category_page_bloc/category_page_bloc.dart';
import 'package:mehaley/business_logic/blocs/category_page_bloc/category_page_pagination_bloc.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/category.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/ui/common/app_error.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/pagination_error_widget.dart';
import 'package:mehaley/ui/common/song_item/song_item.dart';
import 'package:mehaley/ui/screens/category/widgets/item_popular_album.dart';
import 'package:mehaley/ui/screens/category/widgets/item_popular_playlist.dart';
import 'package:mehaley/ui/screens/category/widgets/shimmer_category.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key? key, required this.category}) : super(key: key);

  final Category category;

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with TickerProviderStateMixin {
  //PAGINATION CONTROLLER
  final PagingController<int, Song> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    //FETCH TOP ALBUMS AND PLAYLISTS
    BlocProvider.of<CategoryPageBloc>(context).add(
      LoadCategoryPageTopEvent(categoryId: widget.category.categoryId),
    );
    //FETCH PAGINATED SONGS WITH PAGINATED CONTROLLER
    _pagingController.addPageRequestListener(
      (pageKey) {
        BlocProvider.of<CategoryPagePaginationBloc>(context).add(
          LoadCategoryPagePaginatedEvent(
            categoryId: widget.category.categoryId,
            pageSize: AppValues.pageSize,
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
    return BlocListener<CategoryPagePaginationBloc,
        CategoryPagePaginationState>(
      listener: (context, state) {
        if (state is CategoryPagePaginatedLoaded) {
          final isLastPage = state.songs.length < AppValues.pageSize;
          if (isLastPage) {
            _pagingController.appendLastPage(state.songs);
          } else {
            final nextPageKey = state.page + 1;
            _pagingController.appendPage(state.songs, nextPageKey);
          }
        }
        if (state is CategoryPagePaginatedLoadingError) {
          _pagingController.error = AppLocale.of().networkError;
        }
      },
      child: Scaffold(
        backgroundColor: ColorMapper.getPagesBgColor(),
        appBar: buildAppBar(context),
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(height: AppMargin.margin_16),
                ),
                buildCategoryTopAlbumPlaylist(),
                buildCategorySongsList(),
              ],
            ),
            buildCategoryErrorBlocBuilder(),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      //brightness: Brightness.dark,
      systemOverlayStyle: PagesUtilFunctions.getStatusBarStyle(),
      backgroundColor: ColorMapper.getWhite(),
      shadowColor: AppColors.transparent,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          FlutterRemix.arrow_left_line,
          size: AppIconSizes.icon_size_24,
          color: ColorMapper.getBlack(),
        ),
      ),
      title: Text(
        L10nUtil.translateLocale(
          widget.category.categoryNameText,
          context,
        ),
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: AppFontSizes.font_size_12.sp,
          fontWeight: FontWeight.w600,
          color: ColorMapper.getBlack(),
        ),
      ),
    );
  }

  BlocBuilder<CategoryPageBloc, CategoryPageState>
      buildCategoryErrorBlocBuilder() {
    return BlocBuilder<CategoryPageBloc, CategoryPageState>(
      builder: (context, state) {
        if (state is CategoryPageTopLoadingError) {
          return AppError(
            height: ScreenUtil(context: context).getScreenHeight(),
            bgWidget: SizedBox(),
            onRetry: () {
              BlocProvider.of<CategoryPageBloc>(context).add(
                LoadCategoryPageTopEvent(
                  categoryId: widget.category.categoryId,
                ),
              );
              _pagingController.refresh();
            },
          );
        }
        return SizedBox();
      },
    );
  }

  SliverToBoxAdapter buildCategoryTopAlbumPlaylist() {
    return SliverToBoxAdapter(
      child: BlocBuilder<CategoryPageBloc, CategoryPageState>(
        builder: (context, state) {
          if (state is CategoryPageTopLoaded) {
            return buildCategoryTopAlbumPlaylistItems(state);
          }
          if (state is CategoryPageTopLoading) {
            return Container(
              height: ScreenUtil(context: context).getScreenHeight() * 0.3,
              child: AppLoading(size: AppValues.loadingWidgetSize / 2),
            );
          }
          if (state is CategoryPageTopLoadingError) {
            return Container(
              height: ScreenUtil(context: context).getScreenHeight() * 0.3,
              child: AppLoading(size: AppValues.loadingWidgetSize / 2),
            );
          }
          return Container(
            height: ScreenUtil(context: context).getScreenHeight() * 0.3,
            child: AppLoading(size: AppValues.loadingWidgetSize / 2),
          );
        },
      ),
    );
  }

  SliverPadding buildCategorySongsList() {
    return SliverPadding(
      padding: const EdgeInsets.only(left: AppPadding.padding_16),
      sliver: PagedSliverList<int, Song>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Song>(
          itemBuilder: (context, item, index) {
            return Column(
              children: [
                index == 0 ? buildCategorySongsHeader() : SizedBox(),
                SizedBox(height: AppMargin.margin_8),
                SongItem(
                  song: item,
                  isForMyPlaylist: false,
                  thumbUrl: item.albumArt.imageSmallPath,
                  thumbSize: AppValues.categorySongItemSize,
                  onPressed: () {
                    //OPEN SONG
                    PagesUtilFunctions.openSong(
                      context: context,
                      songs: _pagingController.itemList != null
                          ? _pagingController.itemList!
                          : [item],
                      playingFrom: PlayingFrom(
                        from: AppLocale.of().playingFromCategory,
                        title: L10nUtil.translateLocale(
                          widget.category.categoryNameText,
                          context,
                        ),
                        songSyncPlayedFrom: SongSyncPlayedFrom.CATEGORY_DETAIL,
                        songSyncPlayedFromId: widget.category.categoryId,
                      ),
                      startPlaying: true,
                      index: _pagingController.itemList != null ? index : 0,
                    );
                  },
                ),
                SizedBox(height: AppMargin.margin_8),
              ],
            );
          },
          noItemsFoundIndicatorBuilder: (context) {
            return buildEmptyCategory();
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
            return CategoryShimmer();
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

  Container buildEmptyCategory() {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          FlutterRemix.music_line,
          size: AppIconSizes.icon_size_72,
          color: ColorMapper.getLightGrey().withOpacity(0.8),
        ),
        SizedBox(
          height: AppMargin.margin_8,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.padding_32 * 2,
          ),
          child: Text(
            AppLocale.of().emptyCategory,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              color: ColorMapper.getTxtGrey(),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    ));
  }

  Column buildCategoryTopAlbumPlaylistItems(CategoryPageTopLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //CHECK IF NO PLAYLIST IS NOT EMPTY TO SHOW LIST VIEW
        state.categoryPageTopData.topPlaylist.length > 0
            ? buildCategoryPlaylist(state.categoryPageTopData.topPlaylist)
            : SizedBox(),
        SizedBox(height: AppMargin.margin_32),
        //CHECK IF NO ALBUMS IS NOT EMPTY TO SHOW LIST VIEW
        state.categoryPageTopData.topAlbum.length > 0
            ? buildCategoryAlbums(state.categoryPageTopData.topAlbum)
            : SizedBox(),
        SizedBox(height: AppMargin.margin_48),
      ],
    );
  }

  Column buildCategoryPlaylist(List<Playlist> topPlaylist) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppPadding.padding_16),
          child: Text(
            AppLocale.of().playlists,
            style: TextStyle(
              color: ColorMapper.getBlack(),
              fontSize: AppFontSizes.font_size_14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: AppMargin.margin_16,
        ),
        Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: buildCategoryTopPlaylists(topPlaylist),
            ),
          ),
        )
      ],
    );
  }

  List<Widget> buildCategoryTopPlaylists(List<Playlist> playlists) {
    final items = <Widget>[];

    if (playlists.length > 0) {
      items.add(
        SizedBox(
          width: AppMargin.margin_16,
        ),
      );
      for (int i = 0; i < playlists.length; i++) {
        items.add(
          ItemPopularPlaylist(
            playlist: playlists[i],
          ),
        );
        items.add(
          SizedBox(
            width: AppMargin.margin_16,
          ),
        );
      }
    }

    return items;
  }

  Column buildCategoryAlbums(List<Album> topAlbum) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppPadding.padding_16),
          child: Text(
            AppLocale.of().albums,
            style: TextStyle(
              color: ColorMapper.getBlack(),
              fontSize: AppFontSizes.font_size_14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: AppMargin.margin_16),
        Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: buildCategoryTopAlbums(topAlbum),
            ),
          ),
        )
      ],
    );
  }

  List<Widget> buildCategoryTopAlbums(List<Album> albums) {
    final items = <Widget>[];

    if (albums.length > 0) {
      items.add(
        SizedBox(
          width: AppMargin.margin_16,
        ),
      );
      for (int i = 0; i < albums.length; i++) {
        items.add(
          ItemPopularAlbum(
            album: albums[i],
          ),
        );
        items.add(
          SizedBox(
            width: AppMargin.margin_16,
          ),
        );
      }
    }

    return items;
  }

  Column buildCategorySongsHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppLocale.of().mezmurs,
          style: TextStyle(
            color: ColorMapper.getBlack(),
            fontSize: AppFontSizes.font_size_18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: AppMargin.margin_16,
        ),
      ],
    );
  }
}
