import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/videos_bloc/all_videos_bloc/all_videos_bloc.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_error.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/pagination_error_widget.dart';
import 'package:mehaley/ui/common/song_item/song_item_video.dart';
import 'package:mehaley/ui/screens/videos/widgets/shimmer_videos.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class AllVideosPage extends StatefulWidget {
  const AllVideosPage({Key? key}) : super(key: key);

  @override
  _AllVideosPageState createState() => _AllVideosPageState();
}

class _AllVideosPageState extends State<AllVideosPage> {
  //PAGINATION CONTROLLER
  final PagingController<int, Song> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    //FETCH PAGINATED SONG VIDEOS WITH PAGINATED CONTROLLER
    _pagingController.addPageRequestListener(
      (pageKey) {
        BlocProvider.of<AllVideosBloc>(context).add(
          LoadAllVideosEvent(
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
    return BlocListener<AllVideosBloc, AllVideosState>(
      listener: (context, state) {
        if (state is AllVideosLoadedState) {
          final isLastPage = state.videoSongsList.length < AppValues.pageSize;
          if (isLastPage) {
            _pagingController.appendLastPage(
              state.videoSongsList,
            );
          } else {
            final nextPageKey = state.page + 1;
            _pagingController.appendPage(
              state.videoSongsList,
              nextPageKey,
            );
          }
        }
        if (state is AllVideosLoadingErrorState) {
          _pagingController.error = AppLocale.of().networkError;
        }
      },
      child: Scaffold(
        backgroundColor: ColorMapper.getPagesBgColor(),
        appBar: buildAppBar(context),
        body: PagedListView<int, Song>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Song>(
            itemBuilder: (context, item, index) {
              return Column(
                children: [
                  ///VIDE ITEM
                  SizedBox(height: AppMargin.margin_8),
                  SongItemVideo(
                    videoSong: item,
                    onTap: () {
                      PagesUtilFunctions.openYtPlayerPage(
                        context,
                        item,
                        false,
                      );
                    },
                    onOpenAudioOnly: () {
                      PagesUtilFunctions.openVideoAudioOnly(
                        context,
                        item,
                        false,
                      );
                    },
                  ),
                  SizedBox(height: AppMargin.margin_8),
                ],
              );
            },
            noItemsFoundIndicatorBuilder: (context) {
              return buildEmptyVideosList();
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
              return VideosShimmer();
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
        AppLocale.of().allVideos,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: AppFontSizes.font_size_12.sp,
          fontWeight: FontWeight.w600,
          color: ColorMapper.getBlack(),
        ),
      ),
    );
  }

  Container buildEmptyVideosList() {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          FlutterRemix.video_line,
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
            AppLocale.of().emptyVideos,
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

  Widget buildPageLoading() {
    return AppLoading(
      size: AppValues.loadingWidgetSize,
    );
  }

  Widget buildPageError() {
    return AppError(
      onRetry: () {},
      bgWidget: AppLoading(
        size: AppValues.loadingWidgetSize,
      ),
    );
  }
}
