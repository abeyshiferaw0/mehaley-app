import 'package:elf_play/business_logic/blocs/search_page_bloc/front_page_bloc/search_front_page_bloc.dart';
import 'package:elf_play/business_logic/cubits/bottom_bar_cubit/bottom_bar_cubit.dart';
import 'package:elf_play/business_logic/cubits/bottom_bar_cubit/bottom_bar_search_cubit.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/artist.dart';
import 'package:elf_play/data/models/category.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/ui/common/app_error.dart';
import 'package:elf_play/ui/common/app_loading.dart';
import 'package:elf_play/ui/screens/search/widgets/search_front_page_groups.dart';
import 'package:elf_play/ui/screens/search/widgets/search_page_persistant_header_deligate.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    BlocProvider.of<SearchFrontPageBloc>(context).add(CancelSearchFrontPageEvent());
  }

  @override
  void didPopNext() {
    BlocProvider.of<BottomBarCubit>(context).changeScreen(BottomBarPages.SEARCH);
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
    BlocProvider.of<SearchFrontPageBloc>(context).add(LoadSearchFrontPageEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = ScreenUtil(context: context).getScreenHeight() * 0.7;
    return Scaffold(
      backgroundColor: AppColors.black,
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

  SingleChildScrollView buildSearchPageLoaded(SearchFrontPageLoadedState state) {
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
      mainTitle: AppLocalizations.of(context)!.allCategories,
      appItemsType: AppItemsType.CATEGORY,
      items: allCategories,
    );
  }

  Widget buildTopCategoriesSection({required List<Category> topCategories}) {
    return SearchFrontPageGroups(
      mainTitle: AppLocalizations.of(context)!.topCategories,
      appItemsType: AppItemsType.CATEGORY,
      items: topCategories,
    );
  }

  Widget buildTopMusicSection({required List<Song> topSongs}) {
    return SearchFrontPageGroups(
      mainTitle: AppLocalizations.of(context)!.topMezmurs,
      appItemsType: AppItemsType.SINGLE_TRACK,
      items: topSongs,
    );
  }

  Widget buildLatestTopArtistsSection({required List<Artist> topArtists}) {
    return SearchFrontPageGroups(
      mainTitle: AppLocalizations.of(context)!.topArtists.toUpperCase(),
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
        AppLocalizations.of(context)!.searchTitle,
        style: TextStyle(
          fontSize: AppFontSizes.font_size_28,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
    );
  }
}
