import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/business_logic/cubits/app_user_widgets_cubit.dart';
import 'package:mehaley/business_logic/cubits/bottom_bar_cubit/bottom_bar_cubit.dart';
import 'package:mehaley/business_logic/cubits/bottom_bar_cubit/bottom_bar_library_cubit.dart';
import 'package:mehaley/business_logic/cubits/library/following_tab_pages_cubit.dart';
import 'package:mehaley/business_logic/cubits/library/library_tab_pages_cubit.dart';
import 'package:mehaley/business_logic/cubits/library/purchased_tab_pages_cubit.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/app_user.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/user_profile_pic.dart';
import 'package:mehaley/ui/screens/library/tab_pages/favorite_tab_view.dart';
import 'package:mehaley/ui/screens/library/tab_pages/following_tab_view.dart';
import 'package:mehaley/ui/screens/library/tab_pages/my_playlist_tab_view.dart';
import 'package:mehaley/ui/screens/library/tab_pages/offline_tab_view.dart';
import 'package:mehaley/ui/screens/library/tab_pages/purchased_tab_view.dart';
import 'package:mehaley/ui/screens/library/widgets/library_persistant_header.dart';
import 'package:mehaley/util/auth_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({
    Key? key,
    required this.isFromOffline,
    this.isLibraryForOtherPage,
    this.libraryFromOtherPageTypes,
  }) : super(key: key);

  final bool isFromOffline;
  final bool? isLibraryForOtherPage;
  final LibraryFromOtherPageTypes? libraryFromOtherPageTypes;

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with TickerProviderStateMixin, RouteAware {
  ///TAB CONTROLLER
  late TabController _tabController;

  @override
  void didPopNext() {
    BlocProvider.of<BottomBarCubit>(context)
        .changeScreen(BottomBarPages.LIBRARY);
    BlocProvider.of<BottomBarLibraryCubit>(context).setPageShowing(true);
    //print("BottomBarProfileCubittt // didPopNext // true");
  }

  @override
  void didPushNext() {
    BlocProvider.of<BottomBarLibraryCubit>(context).setPageShowing(false);
    //print("BottomBarProfileCubittt // didPushNext // false");
    super.didPushNext();
  }

  @override
  void didPop() {
    BlocProvider.of<BottomBarLibraryCubit>(context).setPageShowing(false);
    //print("BottomBarProfileCubittt // didPop // false");
    super.didPop();
  }

  @override
  void dispose() {
    AppRouterPaths.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void initState() {
    BlocProvider.of<BottomBarCubit>(context)
        .changeScreen(BottomBarPages.LIBRARY);
    BlocProvider.of<BottomBarLibraryCubit>(context).setPageShowing(true);

    ///INIT TAB CONTROLLER
    _tabController = new TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      BlocProvider.of<LibraryTabPagesCubit>(context).tabChanged(
        _tabController.index,
      );
    });

    ///CHECK IF FROM OTHER PAGE AND NAVIGATE
    checkFromOtherPage();

    super.initState();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();

    ///NAVIGATE TO OFFLINE TAB IF TRUE
    if (widget.isFromOffline) {
      _tabController.animateTo(1, duration: Duration(milliseconds: 300));
    }

    ///NAVIGATE TO APPROPRIATE TABS IF COMING FROM OTHER PAGE
    if (widget.isLibraryForOtherPage != null &&
        widget.libraryFromOtherPageTypes != null) {
      if (widget.isLibraryForOtherPage!) {
        ///MAKE BOTTOM BAR LIBRARY ICON ACTIVE

        if (widget.libraryFromOtherPageTypes! ==
                LibraryFromOtherPageTypes.PURCHASED_SONGS ||
            widget.libraryFromOtherPageTypes! ==
                LibraryFromOtherPageTypes.PURCHASED_ALL_SONGS ||
            widget.libraryFromOtherPageTypes! ==
                LibraryFromOtherPageTypes.PURCHASED_PLAYLISTS ||
            widget.libraryFromOtherPageTypes! ==
                LibraryFromOtherPageTypes.PURCHASED_ALBUMS) {
          _tabController.animateTo(0, duration: Duration(milliseconds: 300));
        }
        if (widget.libraryFromOtherPageTypes! ==
                LibraryFromOtherPageTypes.FOLLOWED_PLAYLISTS ||
            widget.libraryFromOtherPageTypes! ==
                LibraryFromOtherPageTypes.FOLLOWED_ARTISTS) {
          _tabController.animateTo(4, duration: Duration(milliseconds: 300));
        }
        if (widget.libraryFromOtherPageTypes! ==
            LibraryFromOtherPageTypes.USER_PLAYLIST) {
          _tabController.animateTo(2, duration: Duration(milliseconds: 300));
        }
      }
    }

    ///SUBSCRIBE TO ROUTH OBSERVER
    AppRouterPaths.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorMapper.getPagesBgColor(),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              buildAppBar(),
              buildLibraryHeader(),
            ];
          },
          body: buildLibraryTabView(),
        ),
      ),
    );
  }

  TabBarView buildLibraryTabView() {
    return TabBarView(
      controller: _tabController,
      children: [
        PurchasedTabView(
          key: Key('PurchasedTabView'),
        ),
        OfflineTabView(
          key: Key('OfflineTabView'),
        ),
        MyPlaylistTabView(
          key: Key(
            'MyPlaylistTabView',
          ),
          onGoToFollowedPlaylist: () {
            _tabController.animateTo(4);
          },
        ),
        FavoriteTabView(
          key: Key('FavoriteTabView'),
        ),
        FollowingTabView(
          key: Key('FollowingTabView'),
        ),
      ],
    );
  }

  SliverAppBar buildAppBar() {
    return SliverAppBar(
      //brightness: Brightness.dark,
      systemOverlayStyle: PagesUtilFunctions.getStatusBarStyle(),
      backgroundColor: ColorMapper.getWhite(),
      shadowColor: AppColors.transparent,
      floating: true,
      pinned: false,
      leadingWidth: 80,
      leading: Center(
        child: AppBouncingButton(
          onTap: () {
            Navigator.pushNamed(context, AppRouterPaths.profileRoute);
          },
          child: UserProfilePic(
            size: AppIconSizes.icon_size_20 * 2,
            fontSize: AppFontSizes.font_size_12.sp,
          ),
        ),
      ),
      title: BlocBuilder<AppUserWidgetsCubit, AppUser>(
        builder: (context, state) {
          return Text(
            AuthUtil.getUserName(state),
            style: TextStyle(
              fontSize: AppFontSizes.font_size_12.sp,
              fontWeight: FontWeight.w600,
              color: ColorMapper.getBlack(),
            ),
          );
        },
      ),
      actions: [
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
          width: AppMargin.margin_16,
        ),
        // IconButton(
        //   onPressed: () {},
        //   icon: Icon(
        //     FlutterRemix.notifications_2_line,
        //     color: ColorMapper.getWhite(),
        //     size: AppIconSizes.icon_size_24,
        //   ),
        // )
      ],
      centerTitle: true,
    );
  }

  SliverPersistentHeader buildLibraryHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: LibraryHeaderDelegate(tabController: _tabController),
    );
  }

  void checkFromOtherPage() {
    if (widget.isLibraryForOtherPage != null &&
        widget.libraryFromOtherPageTypes != null) {
      if (widget.isLibraryForOtherPage!) {
        if (widget.libraryFromOtherPageTypes! ==
            LibraryFromOtherPageTypes.PURCHASED_SONGS) {
          ///OPEN PURCHASED SONGS PAGE
          BlocProvider.of<PurchasedTabPagesCubit>(context).changePage(
            AppPurchasedPageItemTypes.SONGS,
          );
        }
        if (widget.libraryFromOtherPageTypes! ==
            LibraryFromOtherPageTypes.PURCHASED_ALL_SONGS) {
          ///OPEN PURCHASED ALL SONGS PAGE
          BlocProvider.of<PurchasedTabPagesCubit>(context).changePage(
            AppPurchasedPageItemTypes.ALL_SONGS,
          );
        }
        if (widget.libraryFromOtherPageTypes! ==
            LibraryFromOtherPageTypes.PURCHASED_PLAYLISTS) {
          ///OPEN PURCHASED PLAYLISTS PAGE
          BlocProvider.of<PurchasedTabPagesCubit>(context).changePage(
            AppPurchasedPageItemTypes.PLAYLISTS,
          );
        }
        if (widget.libraryFromOtherPageTypes! ==
            LibraryFromOtherPageTypes.PURCHASED_ALBUMS) {
          ///OPEN PURCHASED ALBUMS PAGE
          BlocProvider.of<PurchasedTabPagesCubit>(context).changePage(
            AppPurchasedPageItemTypes.ALBUMS,
          );
        }
        if (widget.libraryFromOtherPageTypes! ==
            LibraryFromOtherPageTypes.FOLLOWED_PLAYLISTS) {
          ///OPEN PURCHASED PLAYLISTS PAGE
          BlocProvider.of<FollowingTabPagesCubit>(context).changePage(
            AppFollowedPageItemTypes.PLAYLISTS,
          );
        }
        if (widget.libraryFromOtherPageTypes! ==
            LibraryFromOtherPageTypes.FOLLOWED_ARTISTS) {
          ///OPEN PURCHASED ALBUMS PAGE
          BlocProvider.of<FollowingTabPagesCubit>(context).changePage(
            AppFollowedPageItemTypes.ARTIST,
          );
        }
      }
    }
  }
}

class LibraryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;

  LibraryHeaderDelegate({required this.tabController});

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return LibraryHeader(tabController: tabController);
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
