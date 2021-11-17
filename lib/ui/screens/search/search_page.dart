import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/search_page_bloc/front_page_bloc/search_front_page_bloc.dart';
import 'package:mehaley/business_logic/cubits/bottom_bar_cubit/bottom_bar_cubit.dart';
import 'package:mehaley/business_logic/cubits/bottom_bar_cubit/bottom_bar_search_cubit.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/artist.dart';
import 'package:mehaley/data/models/category.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_error.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/screens/search/widgets/search_front_page_groups.dart';
import 'package:mehaley/ui/screens/search/widgets/search_page_persistant_header_deligate.dart';
import 'package:mehaley/util/screen_util.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with RouteAware {
  void didChangeDependencies() {
    super.didChangeDependencies();

    ///SUBSCRIBE TO ROUTH OBSERVER
    AppRouterPaths.routeObserver.subscribe(this, ModalRoute.of(context)!);

    ///CANCEL PAGE REQUEST
    BlocProvider.of<SearchFrontPageBloc>(context)
        .add(CancelSearchFrontPageEvent());
  }

  @override
  void didPopNext() {
    BlocProvider.of<BottomBarCubit>(context)
        .changeScreen(BottomBarPages.SEARCH);
    BlocProvider.of<BottomBarSearchCubit>(context).setPageShowing(true);
  }

  @override
  void didPushNext() {
    BlocProvider.of<BottomBarSearchCubit>(context).setPageShowing(false);
    super.didPushNext();
  }

  @override
  void didPop() {
    BlocProvider.of<BottomBarSearchCubit>(context).setPageShowing(false);
    super.didPop();
  }

  @override
  void didPush() {
    // TODO: implement didPush
    super.didPush();
  }

  @override
  void dispose() {
    AppRouterPaths.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void initState() {
    BlocProvider.of<SearchFrontPageBloc>(context)
        .add(LoadSearchFrontPageEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = ScreenUtil(context: context).getScreenHeight() * 0.7;
    return Scaffold(
      backgroundColor: AppColors.pagesBgColor,
      body: Container(
        padding: EdgeInsets.only(
          left: AppPadding.padding_16,
          right: AppPadding.padding_16,
          top: AppPadding.padding_32,
        ),
        child: CustomScrollView(
          slivers: [
            //SEARCH PAGE HEADER
            SliverToBoxAdapter(child: SizedBox(height: AppMargin.margin_32)),
            buildSearchElf(),
            SliverToBoxAdapter(child: SizedBox(height: AppMargin.margin_16)),
            buildSearchHeader(),

            ///SEARCH PAGE REST SECTIONS
            SliverToBoxAdapter(
              child: BlocBuilder<SearchFrontPageBloc, SearchFrontPageState>(
                builder: (context, state) {
                  if (state is SearchFrontPageLoadingState) {
                    return Container(
                      height: screenHeight,
                      child: AppLoading(size: AppValues.loadingWidgetSize),
                    );
                  }
                  if (state is SearchFrontPageLoadingErrorState) {
                    return AppError(
                      bgWidget: AppLoading(size: AppValues.loadingWidgetSize),
                      height: screenHeight,
                      onRetry: () {
                        BlocProvider.of<SearchFrontPageBloc>(context).add(
                          LoadSearchFrontPageEvent(),
                        );
                      },
                    );
                  }
                  if (state is SearchFrontPageLoadedState) {
                    return buildSearchPageLoaded(state);
                  }
                  return AppLoading(size: AppValues.loadingWidgetSize);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  SingleChildScrollView buildSearchPageLoaded(
      SearchFrontPageLoadedState state) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: AppMargin.margin_16),
          buildTopCategoriesSection(
            topCategories: state.searchPageFrontData.topCategories,
          ),
          SizedBox(height: AppMargin.margin_28),
          buildTopMusicSection(
            topSongs: state.searchPageFrontData.topSongs,
          ),
          SizedBox(height: AppMargin.margin_28),
          buildLatestTopArtistsSection(
            topArtists: state.searchPageFrontData.topArtists,
          ),
          SizedBox(height: AppMargin.margin_28),
          buildAllCategoriesSection(
            allCategories: state.searchPageFrontData.allCategories,
          ),
          SizedBox(height: AppMargin.margin_20),
        ],
      ),
    );
  }

  Widget buildAllCategoriesSection({required List<Category> allCategories}) {
    return SearchFrontPageGroups(
      mainTitle: AppLocale.of().allCategories,
      appItemsType: AppItemsType.CATEGORY,
      items: allCategories,
    );
  }

  Widget buildTopCategoriesSection({required List<Category> topCategories}) {
    return SearchFrontPageGroups(
      mainTitle: AppLocale.of().topCategories,
      appItemsType: AppItemsType.CATEGORY,
      items: topCategories,
    );
  }

  Widget buildTopMusicSection({required List<Song> topSongs}) {
    return SearchFrontPageGroups(
      mainTitle: AppLocale.of().topMezmurs,
      appItemsType: AppItemsType.SINGLE_TRACK,
      items: topSongs,
    );
  }

  Widget buildLatestTopArtistsSection({required List<Artist> topArtists}) {
    return SearchFrontPageGroups(
      mainTitle: AppLocale.of().topArtists.toUpperCase(),
      appItemsType: AppItemsType.ARTIST,
      items: topArtists,
    );
  }

  SliverPersistentHeader buildSearchHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SearchPersistentSliverHeaderDelegate(),
    );
  }

  SliverToBoxAdapter buildSearchElf() {
    return SliverToBoxAdapter(
      child: Text(
        AppLocale.of().searchTitle,
        style: TextStyle(
          fontSize: AppFontSizes.font_size_28,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
    );
  }
}
