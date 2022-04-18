import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/home_page_blocs/all_albums_page_bloc/all_albums_page_bloc.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/pagination_error_widget.dart';
import 'package:mehaley/ui/screens/home/widgets/item_custom_group_grid.dart';
import 'package:mehaley/ui/screens/library/widgets/library_empty_page.dart';
import 'package:mehaley/util/screen_util.dart';

class AllAlbumsTabPage extends StatefulWidget {
  const AllAlbumsTabPage({Key? key}) : super(key: key);

  @override
  State<AllAlbumsTabPage> createState() => _AllAlbumsTabPageState();
}

class _AllAlbumsTabPageState extends State<AllAlbumsTabPage>
    with AutomaticKeepAliveClientMixin<AllAlbumsTabPage> {
  ///TO PRESERVE PAGES STATE
  @override
  bool get wantKeepAlive => true;

  //PAGINATION CONTROLLER
  final PagingController<int, Album> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    ///FETCH PAGINATED SONGS WITH PAGINATED CONTROLLER
    _pagingController.addPageRequestListener(
      (pageKey) {
        ///INITIALLY LOAD ALL PURCHASED SONGS
        BlocProvider.of<AllAlbumsPageBloc>(context).add(
          LoadAllPaginatedAlbumsEvent(
            pageSize: AppValues.allAlbumsPageSize,
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
      child: BlocListener<AllAlbumsPageBloc, AllAlbumsPageState>(
        listener: (context, state) {
          if (state is AllPaginatedAlbumsLoadedState) {
            final isLastPage =
                state.paginatedAlbums.length < AppValues.allAlbumsPageSize;

            if (isLastPage) {
              _pagingController.appendLastPage(state.paginatedAlbums);
            } else {
              final nextPageKey = state.page + 1;
              _pagingController.appendPage(
                state.paginatedAlbums,
                nextPageKey,
              );
            }
          }
          if (state is AllPaginatedAlbumsLoadingErrorState) {
            _pagingController.error = AppLocale.of().networkError;
          }
        },
        child: RefreshIndicator(
          color: ColorMapper.getDarkOrange(),
          onRefresh: () => Future.sync(
            () => _pagingController.refresh(),
          ),
          child: PagedGridView<int, Album>(
            pagingController: _pagingController,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 100 / 120,
              crossAxisSpacing: AppPadding.padding_16,
              mainAxisSpacing: AppPadding.padding_20,
              crossAxisCount: 2,
            ),
            builderDelegate: PagedChildBuilderDelegate<Album>(
              itemBuilder: (context, item, index) {
                return ItemCustomGroupGrid(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRouterPaths.albumRoute,
                      arguments:
                          ScreenArguments(args: {'albumId': (item).albumId}),
                    );
                  },
                  groupType: GroupType.ALBUM,
                  item: item,
                );
              },
              noItemsFoundIndicatorBuilder: (context) {
                return Container(
                  height: screenHeight * 0.5,
                  child: LibraryEmptyPage(
                    icon: FlutterRemix.disc_line,
                    msg: 'empty albums',
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
