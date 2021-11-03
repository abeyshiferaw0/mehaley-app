import 'package:elf_play/business_logic/blocs/category_page_bloc/category_page_bloc.dart';
import 'package:elf_play/business_logic/blocs/category_page_bloc/category_page_pagination_bloc.dart';
import 'package:elf_play/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/category.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/data/models/sync/song_sync_played_from.dart';
import 'package:elf_play/ui/common/app_error.dart';
import 'package:elf_play/ui/common/app_loading.dart';
import 'package:elf_play/ui/common/song_item/song_item.dart';
import 'package:elf_play/ui/screens/category/widgets/category_sliver_header_delegate.dart';
import 'package:elf_play/ui/screens/category/widgets/item_popular_album.dart';
import 'package:elf_play/ui/screens/category/widgets/item_popular_playlist.dart';
import 'package:elf_play/ui/screens/category/widgets/pagination_error_widget.dart';
import 'package:elf_play/ui/screens/category/widgets/shimmer_category.dart';
import 'package:elf_play/ui/screens/category/widgets/shimmer_category_top.dart';
import 'package:elf_play/util/l10n_util.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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
          _pagingController.error = "Network Error";
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                buildSliverHeader(widget.category),
                SliverToBoxAdapter(
                  child: SizedBox(height: AppMargin.margin_16),
                ),
                buildCategoryTopAlbumPlaylist(),
                SliverToBoxAdapter(
                  child: SizedBox(height: AppMargin.margin_48),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: AppMargin.margin_16),
                ),
                buildCategorySongsList(),
              ],
            ),
            buildCategoryErrorBlocBuilder(),
          ],
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
            return CategoryTopShimmer();
          }
          if (state is CategoryPageTopLoadingError) {
            return CategoryTopShimmer();
          }
          return CategoryTopShimmer();
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
                  thumbUrl: AppApi.baseFileUrl + item.albumArt.imageSmallPath,
                  thumbSize: AppValues.categorySongItemSize,
                  onPressed: () {
                    //OPEN SONG
                    PagesUtilFunctions.openSong(
                      context: context,
                      songs: [item],
                      playingFrom: PlayingFrom(
                        from: "playing from category",
                        title: L10nUtil.translateLocale(
                          widget.category.categoryNameText,
                          context,
                        ),
                        songSyncPlayedFrom: SongSyncPlayedFrom.CATEGORY_DETAIL,
                        songSyncPlayedFromId: widget.category.categoryId,
                      ),
                      startPlaying: true,
                      index: 0,
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
          PhosphorIcons.music_note_simple_light,
          size: AppIconSizes.icon_size_72,
          color: AppColors.darkGrey.withOpacity(0.8),
        ),
        SizedBox(
          height: AppMargin.margin_8,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.padding_32 * 2,
          ),
          child: Text(
            "Empty category",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              color: AppColors.txtGrey,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    ));
  }

  Column buildCategoryTopAlbumPlaylistItems(CategoryPageTopLoaded state) {
    return Column(
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
      ],
    );
  }

  Column buildCategoryPlaylist(List<Playlist> topPlaylist) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Playlists",
          style: TextStyle(
            color: Colors.white,
            fontSize: AppFontSizes.font_size_14.sp,
            fontWeight: FontWeight.w600,
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Albums",
          style: TextStyle(
            color: Colors.white,
            fontSize: AppFontSizes.font_size_14.sp,
            fontWeight: FontWeight.w600,
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
          "Mezmurs",
          style: TextStyle(
            color: Colors.white,
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

  SliverPersistentHeader buildSliverHeader(Category category) {
    return SliverPersistentHeader(
      delegate: CategorySliverHeaderDelegate(category: category),
      floating: true,
      pinned: true,
    );
  }
}
