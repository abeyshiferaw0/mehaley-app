import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/home_page_blocs/all_playlists_page_bloc/all_playlists_page_bloc.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/pagination_error_widget.dart';
import 'package:mehaley/ui/screens/home/widgets/item_custom_group_grid.dart';
import 'package:mehaley/ui/screens/library/widgets/library_empty_page.dart';
import 'package:mehaley/util/screen_util.dart';

class AllPlaylistsTabPage extends StatefulWidget {
  const AllPlaylistsTabPage({Key? key}) : super(key: key);

  @override
  State<AllPlaylistsTabPage> createState() => _AllPlaylistsTabPageState();
}

class _AllPlaylistsTabPageState extends State<AllPlaylistsTabPage>
    with AutomaticKeepAliveClientMixin<AllPlaylistsTabPage> {
  ///TO PRESERVE PAGES STATE
  @override
  bool get wantKeepAlive => true;

  //PAGINATION CONTROLLER
  final PagingController<int, Playlist> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    ///FETCH PAGINATED SONGS WITH PAGINATED CONTROLLER
    _pagingController.addPageRequestListener(
      (pageKey) {
        ///INITIALLY LOAD ALL PURCHASED SONGS
        BlocProvider.of<AllPlaylistsPageBloc>(context).add(
          LoadAllPaginatedPlaylistsEvent(
            pageSize: AppValues.allPlaylistsPageSize,
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
        top: AppPadding.padding_16,
        left: AppPadding.padding_16,
        right: AppPadding.padding_16,
      ),
      child: BlocListener<AllPlaylistsPageBloc, AllPlaylistsPageState>(
        listener: (context, state) {
          if (state is AllPaginatedPlaylistsLoadedState) {
            final isLastPage = state.paginatedPlaylists.length <
                AppValues.allPlaylistsPageSize;

            if (isLastPage) {
              _pagingController.appendLastPage(state.paginatedPlaylists);
            } else {
              final nextPageKey = state.page + 1;
              _pagingController.appendPage(
                state.paginatedPlaylists,
                nextPageKey,
              );
            }
          }
          if (state is AllPaginatedPlaylistsLoadingErrorState) {
            _pagingController.error = AppLocale.of().networkError;
          }
        },
        child: RefreshIndicator(
          color: ColorMapper.getDarkOrange(),
          onRefresh: () => Future.sync(
            () => _pagingController.refresh(),
          ),
          child: PagedGridView<int, Playlist>(
            pagingController: _pagingController,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 100 / 120,
              crossAxisSpacing: AppPadding.padding_16,
              mainAxisSpacing: AppPadding.padding_20,
              crossAxisCount: 2,
            ),
            builderDelegate: PagedChildBuilderDelegate<Playlist>(
              itemBuilder: (context, item, index) {
                return ItemCustomGroupGrid(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRouterPaths.playlistRoute,
                      arguments: ScreenArguments(
                          args: {'playlistId': (item).playlistId}),
                    );
                  },
                  groupType: GroupType.PLAYLIST,
                  item: item,
                );
              },
              noItemsFoundIndicatorBuilder: (context) {
                return Container(
                  height: screenHeight * 0.5,
                  child: LibraryEmptyPage(
                    icon: FlutterRemix.disc_line,
                    msg: 'empty playlists',
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
