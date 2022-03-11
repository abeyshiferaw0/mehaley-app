import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/business_logic/blocs/home_page_bloc/home_page_bloc.dart';
import 'package:mehaley/business_logic/cubits/bottom_bar_cubit/bottom_bar_cubit.dart';
import 'package:mehaley/business_logic/cubits/bottom_bar_cubit/bottom_bar_home_cubit.dart';
import 'package:mehaley/business_logic/cubits/today_holiday_toast_cubit.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/api_response/home_page_data.dart';
import 'package:mehaley/data/models/enums/app_languages.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/group.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_error.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/app_subscribe_card.dart';
import 'package:mehaley/ui/common/no_internet_header.dart';
import 'package:mehaley/ui/common/subscribed_tag.dart';
import 'package:mehaley/ui/screens/home/widgets/home_categories.dart';
import 'package:mehaley/ui/screens/home/widgets/home_featured_albums.dart';
import 'package:mehaley/ui/screens/home/widgets/home_featured_playlists.dart';
import 'package:mehaley/ui/screens/home/widgets/home_featured_songs.dart';
import 'package:mehaley/ui/screens/home/widgets/home_groups.dart';
import 'package:mehaley/ui/screens/home/widgets/home_page_carousel.dart';
import 'package:mehaley/ui/screens/home/widgets/home_recently_played.dart';
import 'package:mehaley/ui/screens/home/widgets/ite_home_page_ad.dart';
import 'package:mehaley/util/api_util.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

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
    super.didChangeDependencies();
  }

  @override
  void didPopNext() {
    BlocProvider.of<BottomBarCubit>(context).changeScreen(BottomBarPages.HOME);
    BlocProvider.of<BottomBarHomeCubit>(context).setPageShowing(true);
    if (ApiUtil.isRecentlyPurchasedWasMade()) {
      BlocProvider.of<HomePageBloc>(context).add(LoadHomePageEvent());
      ApiUtil.setRecentlyPurchased(true);
    }
  }

  @override
  void didPushNext() {
    BlocProvider.of<BottomBarHomeCubit>(context).setPageShowing(false);

    ///CANCEL PAGE REQUEST
    BlocProvider.of<HomePageBloc>(context).add(CancelHomePageRequestEvent());
    super.didPushNext();
  }

  @override
  void didPop() {
    BlocProvider.of<BottomBarHomeCubit>(context).setPageShowing(false);

    ///CANCEL PAGE REQUEST
    BlocProvider.of<HomePageBloc>(context).add(CancelHomePageRequestEvent());
    super.didPop();
  }

  @override
  void initState() {
    BlocProvider.of<BottomBarCubit>(context).changeScreen(BottomBarPages.HOME);
    BlocProvider.of<BottomBarHomeCubit>(context).setPageShowing(true);
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
        backgroundColor: ColorMapper.getPagesBgColor(),
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
      leadingWidth: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AppAssets.icAppWordIcon,
            fit: BoxFit.cover,
            height: AppIconSizes.icon_size_20,
          ),

          ///SUBSCRIBED CARD
          SubscribedTag(
            color: ColorMapper.getDarkOrange(),
          ),

          ///
          Expanded(
            child: SizedBox(),
          ),
        ],
      ),
      systemOverlayStyle: PagesUtilFunctions.getStatusBarStyle(),
      backgroundColor: AppColors.transparent,
      shadowColor: AppColors.transparent,
      actions: [
        AppBouncingButton(
          onTap: () {
            BlocProvider.of<TodayHolidayToastCubit>(context).showToast(true);
            BlocProvider.of<TodayHolidayToastCubit>(context).showToast(false);
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppPadding.padding_8,
                horizontal: AppPadding.padding_4,
              ),
              child: Text(
                L10nUtil.getCurrentLocale() == AppLanguage.AMHARIC
                    ? "የዛሬ ወርሃዊ በዓላት"
                    : "Today's holidays".toUpperCase(),
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_10.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorMapper.getBlack(),
                ),
              ),
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
              color: ColorMapper.getBlack(),
            ),
          ),
        ),
        SizedBox(
          width: AppPadding.padding_8,
        ),
      ],
    );
  }

  SingleChildScrollView buildHomePageLoaded(
      {required HomePageData homePageData}) {
    //GROUPS CONCATENATE
    List<Group> autoGroups = [];
    List<Group> adminGroups = [];
    autoGroups.addAll(homePageData.autogeneratedGroups);
    adminGroups.addAll(homePageData.adminGroups);

    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
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
          SizedBox(height: AppMargin.margin_48),

          ///BUILD USER LIBRARY GRIDS
          HomeFeaturedSongs(featuredSongs: homePageData.featuredSongs),

          ///BUILD FEATURED ALBUMS
          HomeFeaturedAlbums(
            featuredAlbums: homePageData.featuredAlbums,
          ),

          ///BUILD FEATURED PLAYLISTS
          HomeFeaturedPlaylists(
            featuredPlaylists: homePageData.featuredPlaylist,
          ),

          ///SONGS WITH VIDEOS
          HomePageVideoCarousel(
            songVideos: homePageData.videoSongs,
          ),

          ///SUBSCRIBE CARD
          AppSubscribeCard(
            topMargin: AppMargin.margin_48,
            bottomMargin: AppMargin.margin_8,
          ),

          ///BUILD HOME PAGE AD
          ItemHomePageAd(appAddEmbedPlace: AppAddEmbedPlace.HOME_PAGE_TOP),

          ///BUILD HOME PAGE AUTO GROUPS
          buildGroupsListView(autoGroups),

          ///BUILD HOME PAGE AD
          ItemHomePageAd(appAddEmbedPlace: AppAddEmbedPlace.HOME_PAGE_MIDDLE),

          ///BUILD HOME PAGE ADMIN GROUPS
          buildGroupsListView(adminGroups),

          ///BUILD HOME PAGE AD
          ItemHomePageAd(appAddEmbedPlace: AppAddEmbedPlace.HOME_PAGE_BOTTOM),
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
        if (groups[index].groupItems.length > 3 && groups[index].isVisible) {
          return HomeGroups(
            groupId: groups[index].groupId,
            groupTitle:
                L10nUtil.translateLocale(groups[index].groupTitleText, context),
            groupSubTitle: groups[index].groupSubTitleText != null
                ? L10nUtil.translateLocale(
                    groups[index].groupSubTitleText!, context)
                : null,
            groupHeaderImageUrl: groups[index].headerImageId != null
                ? groups[index].headerImageId!.imageSmallPath
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
