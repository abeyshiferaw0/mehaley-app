import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/business_logic/blocs/home_page_bloc/home_page_bloc.dart';
import 'package:mehaley/business_logic/cubits/bottom_bar_cubit/bottom_bar_cubit.dart';
import 'package:mehaley/business_logic/cubits/bottom_bar_cubit/bottom_bar_home_cubit.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/api_response/home_page_data.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/group.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_error.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/app_subscribe_card.dart';
import 'package:mehaley/ui/common/no_internet_header.dart';
import 'package:mehaley/ui/screens/home/widgets/home_categories.dart';
import 'package:mehaley/ui/screens/home/widgets/home_featured_albums.dart';
import 'package:mehaley/ui/screens/home/widgets/home_featured_playlists.dart';
import 'package:mehaley/ui/screens/home/widgets/home_featured_songs.dart';
import 'package:mehaley/ui/screens/home/widgets/home_groups.dart';
import 'package:mehaley/ui/screens/home/widgets/home_recently_played.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, RouteAware {
  @override
  void didChangeDependencies() {
    ///SUBSCRIBE TO ROUTH OBSERVER
    AppRouterPaths.routeObserver.subscribe(this, ModalRoute.of(context)!);

    ///CANCEL PAGE REQUEST
    BlocProvider.of<HomePageBloc>(context).add(CancelHomePageRequestEvent());
    super.didChangeDependencies();
  }

  @override
  void didPopNext() {
    BlocProvider.of<BottomBarCubit>(context).changeScreen(BottomBarPages.HOME);
    BlocProvider.of<BottomBarHomeCubit>(context).setPageShowing(true);
  }

  @override
  void didPushNext() {
    BlocProvider.of<BottomBarHomeCubit>(context).setPageShowing(false);
    super.didPushNext();
  }

  @override
  void didPop() {
    BlocProvider.of<BottomBarHomeCubit>(context).setPageShowing(false);
    super.didPop();
  }

  @override
  void initState() {
    BlocProvider.of<HomePageBloc>(context).add(LoadHomePageEvent());
    super.initState();
  }

  @override
  void dispose() {
    AppRouterPaths.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.pagesBgColor,
        appBar: buildAppBar(),
        body: BlocBuilder<HomePageBloc, HomePageState>(
          builder: (context, state) {
            if (state is HomePageLoaded) {
              return buildHomePageLoaded(homePageData: state.homePageData);
            }
            if (state is HomePageLoading) {
              return AppLoading(size: AppValues.loadingWidgetSize);
            }
            if (state is HomePageLoadingError) {
              return AppError(
                bgWidget: AppLoading(size: AppValues.loadingWidgetSize),
                onRetry: () {
                  BlocProvider.of<HomePageBloc>(context).add(
                    LoadHomePageEvent(),
                  );
                },
              );
            }
            return AppLoading(size: AppValues.loadingWidgetSize);
          },
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      toolbarHeight: AppIconSizes.icon_size_64,
      leadingWidth: AppIconSizes.icon_size_64 + AppMargin.margin_16,
      leading: Row(
        children: [
          SizedBox(
            width: AppMargin.margin_16,
          ),
          Image.asset(
            AppAssets.icAppFullIcon,
            fit: BoxFit.contain,
            width: AppIconSizes.icon_size_64,
            height: AppIconSizes.icon_size_64,
          ),
        ],
      ),
      systemOverlayStyle: PagesUtilFunctions.getStatusBarStyle(),
      backgroundColor: AppColors.transparent,
      shadowColor: AppColors.transparent,
      actions: [
        AppBouncingButton(
          onTap: () {
            PagesUtilFunctions.goToWalletPage(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.padding_8),
            child: Icon(
              FlutterRemix.wallet_3_line,
              size: AppIconSizes.icon_size_24,
              color: AppColors.black,
            ),
          ),
        ),
        SizedBox(
          width: AppPadding.padding_16,
        ),
        AppBouncingButton(
          onTap: () {
            Navigator.pushNamed(context, AppRouterPaths.settingRoute);
          },
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.padding_8),
            child: Icon(
              FlutterRemix.settings_4_line,
              size: AppIconSizes.icon_size_24,
              color: AppColors.black,
            ),
          ),
        ),
        SizedBox(
          width: AppPadding.padding_4,
        ),
      ],
    );
  }

  SingleChildScrollView buildHomePageLoaded(
      {required HomePageData homePageData}) {
    //GROUPS CONCATENATE
    List<Group> groups = [];
    groups.addAll(homePageData.autogeneratedGroups);
    groups.addAll(homePageData.adminGroups);

    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: AppMargin.margin_32),

          ///APP BAR
          //HomeAppBar(),
          //SizedBox(height: AppMargin.margin_32),

          ///NO INTERNET HEADER
          NoInternetHeader(),

          ///BUILD RECENTLY PLAYED LIST
          HomeRecentlyPlayed(recentlyPlayed: homePageData.recentlyPlayed),

          ///BUILD HOME CATEGORIES
          HomeCategories(categories: homePageData.categories),
          SizedBox(height: AppMargin.margin_32),

          ///BUILD USER LIBRARY GRIDS
          HomeFeaturedSongs(featuredSongs: homePageData.featuredSongs),
          SizedBox(height: AppMargin.margin_32),

          Container(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.padding_16),
            child: AppSubscribeCard(),
          ),

          SizedBox(height: AppMargin.margin_32),

          ///BUILD FEATURED ALBUMS
          HomeFeaturedAlbums(
            featuredAlbums: homePageData.featuredAlbums,
          ),

          ///BUILD HOME PAGE GROUPS
          buildGroupsListView(groups),

          ///BUILD FEATURED PLAYLISTS
          HomeFeaturedPlaylists(
            featuredPlaylists: homePageData.featuredPlaylist,
          ),
        ],
      ),
    );
  }

  ListView buildGroupsListView(List<Group> groups) {
    return ListView.builder(
      itemCount: groups.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (groups[index].groupItems.length > 0 && groups[index].isVisible) {
          return HomeGroups(
            groupId: groups[index].groupId,
            groupTitle:
                L10nUtil.translateLocale(groups[index].groupTitleText, context),
            groupSubTitle: groups[index].groupSubTitleText != null
                ? L10nUtil.translateLocale(
                    groups[index].groupSubTitleText!, context)
                : null,
            groupHeaderImageUrl: groups[index].headerImageId != null
                ? AppApi.baseUrl + groups[index].headerImageId!.imageSmallPath
                : null,
            groupUiType: groups[index].groupUiType,
            groupItems: groups[index].groupItems,
            groupType: groups[index].groupType,
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
