import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/business_logic/blocs/home_page_blocs/all_artists_page_bloc/all_artists_page_bloc.dart';
import 'package:mehaley/business_logic/blocs/home_page_blocs/all_playlists_page_bloc/all_playlists_page_bloc.dart';
import 'package:mehaley/business_logic/blocs/home_page_blocs/all_songs_page_bloc/all_songs_page_bloc.dart';
import 'package:mehaley/business_logic/blocs/home_page_blocs/discover_page_bloc/home_page_bloc.dart';
import 'package:mehaley/business_logic/cubits/bottom_bar_cubit/bottom_bar_cubit.dart';
import 'package:mehaley/business_logic/cubits/bottom_bar_cubit/bottom_bar_home_cubit.dart';
import 'package:mehaley/business_logic/cubits/home_page_tabs_change_cubit.dart';
import 'package:mehaley/business_logic/cubits/home_page_tabs_change_listner_cubit.dart';
import 'package:mehaley/business_logic/cubits/today_holiday_toast_cubit.dart';
import 'package:mehaley/config/app_repositories.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/app_languages.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/subscribed_tag.dart';
import 'package:mehaley/ui/screens/home/tab_pages/all_albums_tab_page.dart';
import 'package:mehaley/ui/screens/home/tab_pages/all_artists_tab_page.dart';
import 'package:mehaley/ui/screens/home/tab_pages/all_songs_tab_page.dart';
import 'package:mehaley/ui/screens/home/tab_pages/dicover_tab_page.dart';
import 'package:mehaley/ui/screens/home/widgets/home_page_header_tabs_deligate.dart';
import 'package:mehaley/util/api_util.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

import '../../../business_logic/blocs/home_page_blocs/all_albums_page_bloc/all_albums_page_bloc.dart';
import 'tab_pages/all_playlists_tab_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, RouteAware {
  ///TAB CONTROLLER
  late TabController _tabController;

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
      _tabController.animateTo(0);
      ApiUtil.setRecentlyPurchased(true);
    }
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
    BlocProvider.of<BottomBarCubit>(context).changeScreen(BottomBarPages.HOME);
    BlocProvider.of<BottomBarHomeCubit>(context).setPageShowing(true);

    ///INIT TAB CONTROLLER
    _tabController = new TabController(length: 5, vsync: this);

    _tabController.addListener(
      () {
        if (_tabController.index == 0) {
          ///UPDATE HomePageTabsChangeListenerCubit THAT TAB IS CHANGED
          BlocProvider.of<HomePageTabsChangeListenerCubit>(context)
              .tabChanged(HomePageTabs.EXPLORE);
        } else if (_tabController.index == 1) {
          ///UPDATE HomePageTabsChangeListenerCubit THAT TAB IS CHANGED
          BlocProvider.of<HomePageTabsChangeListenerCubit>(context)
              .tabChanged(HomePageTabs.ALL_SONGS);
        } else if (_tabController.index == 2) {
          ///UPDATE HomePageTabsChangeListenerCubit THAT TAB IS CHANGED
          BlocProvider.of<HomePageTabsChangeListenerCubit>(context)
              .tabChanged(HomePageTabs.ALL_ALBUMS);
        } else if (_tabController.index == 3) {
          ///UPDATE HomePageTabsChangeListenerCubit THAT TAB IS CHANGED
          BlocProvider.of<HomePageTabsChangeListenerCubit>(context)
              .tabChanged(HomePageTabs.ALL_ARTISTS);
        } else if (_tabController.index == 4) {
          ///UPDATE HomePageTabsChangeListenerCubit THAT TAB IS CHANGED
          BlocProvider.of<HomePageTabsChangeListenerCubit>(context)
              .tabChanged(HomePageTabs.ALL_PLAYLISTS);
        }
      },
    );

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
      child: BlocListener<HomePageTabsChangeCubit, GroupType?>(
        listener: (context, state) {
          if (state != null) {
            if (state == GroupType.SONG) {
              _tabController.animateTo(1);
            }
            if (state == GroupType.ALBUM) {
              _tabController.animateTo(2);
            }
            if (state == GroupType.ARTIST) {
              _tabController.animateTo(3);
            }
            if (state == GroupType.PLAYLIST) {
              _tabController.animateTo(4);
            }
          } else {
            _tabController.animateTo(0);
          }
        },
        child: Scaffold(
          backgroundColor: ColorMapper.getPagesBgColor(),
          appBar: buildAppBar(),
          body: buildHomePageSliverTabs(),
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
          Expanded(
            child: SubscribedTag(
              color: ColorMapper.getDarkOrange(),
            ),
          ),

          ///
          SizedBox(
            width: AppMargin.margin_12,
          )
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
                  fontSize: (AppFontSizes.font_size_8 + 1).sp,
                  fontWeight: FontWeight.w500,
                  color: ColorMapper.getBlack(),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: AppPadding.padding_12,
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

  buildHomePageSliverTabs() {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return <Widget>[
          SliverPersistentHeader(
            delegate: HomePageHeaderTabsDelegate(tabController: _tabController),
            floating: false,
            pinned: true,
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          BlocProvider(
            create: (context) => HomePageBloc(
              homeDataRepository: AppRepositories.homeDataRepository,
            ),
            child: DiscoverTabPage(),
          ),
          BlocProvider(
            create: (context) => AllSongsPageBloc(
              homeDataRepository: AppRepositories.homeDataRepository,
            ),
            child: AllSongsTabPage(),
          ),
          BlocProvider(
            create: (context) => AllAlbumsPageBloc(
              homeDataRepository: AppRepositories.homeDataRepository,
            ),
            child: AllAlbumsTabPage(),
          ),
          BlocProvider(
            create: (context) => AllArtistsPageBloc(
              homeDataRepository: AppRepositories.homeDataRepository,
            ),
            child: AllArtistsTabPage(),
          ),
          BlocProvider(
            create: (context) => AllPlaylistsPageBloc(
              homeDataRepository: AppRepositories.homeDataRepository,
            ),
            child: AllPlaylistsTabPage(),
          ),
        ],
      ),
    );
  }
}
