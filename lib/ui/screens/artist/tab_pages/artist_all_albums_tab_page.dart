import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/artist_page/artist_all_albums_bloc/artist_all_albums_bloc.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/artist.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/pagination_error_widget.dart';
import 'package:mehaley/ui/screens/home/widgets/item_custom_group_grid.dart';
import 'package:mehaley/ui/screens/library/widgets/library_empty_page.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/screen_util.dart';

class ArtistAllAlbumsTabPage extends StatefulWidget {
  const ArtistAllAlbumsTabPage({Key? key, required this.artist})
      : super(key: key);

  final Artist artist;

  @override
  State<ArtistAllAlbumsTabPage> createState() => _ArtistAllAlbumsTabPageState();
}

class _ArtistAllAlbumsTabPageState extends State<ArtistAllAlbumsTabPage>
    with AutomaticKeepAliveClientMixin<ArtistAllAlbumsTabPage> {
  ///TO PRESERVE PAGES STATE
  @override
  bool get wantKeepAlive => true;

  //PAGINATION CONTROLLER
  final PagingController<int, Album> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    ///FETCH PAGINATED ALBUMS WITH PAGINATED CONTROLLER
    _pagingController.addPageRequestListener(
      (pageKey) {
        ///INITIALLY LOAD ALL PAGINATED ALBUMS
        BlocProvider.of<ArtistAllAlbumsBloc>(context).add(
          LoadAllPaginatedAlbumsEvent(
            pageSize: AppValues.allAlbumsPageSize,
            page: pageKey,
            artistId: widget.artist.artistId,
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
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.padding_16,
        vertical: AppPadding.padding_20,
      ),
      child: MultiBlocListener(
        listeners: [
          BlocListener<ArtistAllAlbumsBloc, ArtistAllAlbumsState>(
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
          ),
        ],
        child: PagedGridView<int, Album>(
          pagingController: _pagingController,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
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
                height: screenHeight * 0.2,
                child: LibraryEmptyPage(
                  icon: FlutterRemix.disc_line,
                  msg: AppLocale.of().zemariEmptyAlbums(
                    zemariName: L10nUtil.translateLocale(
                      widget.artist.artistName,
                      context,
                    ),
                  ),
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
                  top: ScreenUtil(context: context).getScreenHeight() * 0.02,
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
    );
  }

  Container buildAppLoading(BuildContext context, double screenHeight) {
    return Container(
      height: screenHeight * 0.2,
      child: AppLoading(size: AppValues.loadingWidgetSize / 2),
    );
  }
}
