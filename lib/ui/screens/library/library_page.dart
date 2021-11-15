import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:mehaley/business_logic/cubits/app_user_widgets_cubit.dart';
import 'package:mehaley/business_logic/cubits/bottom_bar_cubit/bottom_bar_cubit.dart';
import 'package:mehaley/business_logic/cubits/bottom_bar_cubit/bottom_bar_library_cubit.dart';
import 'package:mehaley/business_logic/cubits/library/following_tab_pages_cubit.dart';
import 'package:mehaley/business_logic/cubits/library/library_tab_pages_cubit.dart';
import 'package:mehaley/business_logic/cubits/library/purchased_tab_pages_cubit.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/app_user.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/user_profile_pic.dart';
import 'package:mehaley/ui/screens/library/tab_pages/favorite_tab_view.dart';
import 'package:mehaley/ui/screens/library/tab_pages/following_tab_view.dart';
import 'package:mehaley/ui/screens/library/tab_pages/my_playlist_tab_view.dart';
import 'package:mehaley/ui/screens/library/tab_pages/offline_tab_view.dart';
import 'package:mehaley/ui/screens/library/tab_pages/purchased_tab_view.dart';
import 'package:mehaley/ui/screens/library/widgets/library_persistant_header.dart';
import 'package:mehaley/util/auth_util.dart';
import 'package:sizer/sizer.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({
    Key? key,
    required this.isFromOffline,
    this.isLibraryForProfile,
    this.profileListTypes,
  }) : super(key: key);

  final bool isFromOffline;
  final bool? isLibraryForProfile;
  final ProfileListTypes? profileListTypes;

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
  }

  @override
  void didPushNext() {
    BlocProvider.of<BottomBarLibraryCubit>(context).setPageShowing(false);
    super.didPushNext();
  }

  @override
  void didPop() {
    BlocProvider.of<BottomBarLibraryCubit>(context).setPageShowing(false);
    super.didPop();
  }

  @override
  void dispose() {
    AppRouterPaths.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void initState() {
    ///INIT TAB CONTROLLER
    _tabController = new TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      BlocProvider.of<LibraryTabPagesCubit>(context).tabChanged(
        _tabController.index,
      );
    });

    ///CHECK IF FROM PROFILE PAGE AND NAVIGATE
    checkFromProfilePage();

    super.initState();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();

    ///NAVIGATE TO OFFLINE TAB IF TRUE
    if (widget.isFromOffline) {
      _tabController.animateTo(1, duration: Duration(milliseconds: 300));
    }

    ///NAVIGATE TO APPROPRIATE TABS IF COMING FROM PROFILE PAGE
    if (widget.isLibraryForProfile != null && widget.profileListTypes != null) {
      if (widget.isLibraryForProfile!) {
        if (widget.profileListTypes! == ProfileListTypes.PURCHASED_SONGS ||
            widget.profileListTypes! == ProfileListTypes.PURCHASED_PLAYLISTS ||
            widget.profileListTypes! == ProfileListTypes.PURCHASED_ALBUMS) {
          _tabController.animateTo(0, duration: Duration(milliseconds: 300));
        }
        if (widget.profileListTypes! == ProfileListTypes.FOLLOWED_PLAYLISTS ||
            widget.profileListTypes! == ProfileListTypes.FOLLOWED_ARTISTS) {
          _tabController.animateTo(4, duration: Duration(milliseconds: 300));
        }
        if (widget.profileListTypes! == ProfileListTypes.OTHER) {
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
      backgroundColor: AppColors.lightGrey,
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
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
      backgroundColor: AppColors.lightGrey,
      shadowColor: AppColors.transparent,
      floating: true,
      pinned: false,
      leadingWidth: 80,
      leading: Center(
        child: AppBouncingButton(
          onTap: () {
            Navigator.pushNamed(context, AppRouterPaths.profileRoute);
          },
          child: Stack(
            children: [
              UserProfilePic(
                size: AppIconSizes.icon_size_20 * 2,
                fontSize: AppFontSizes.font_size_12.sp,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Icon(
                  PhosphorIcons.gear_six_bold,
                  size: AppIconSizes.icon_size_12,
                  color: AppColors.black,
                ),
              )
            ],
          ),
        ),
      ),
      title: BlocBuilder<AppUserWidgetsCubit, AppUser>(
        builder: (context, state) {
          return Text(
            AuthUtil.getUserName(state),
            style: TextStyle(
              fontSize: AppFontSizes.font_size_16,
              fontWeight: FontWeight.w600,
            ),
          );
        },
      ),
      actions: [
        // IconButton(
        //   onPressed: () {},
        //   icon: Icon(
        //     PhosphorIcons.bell_simple_light,
        //     color: AppColors.white,
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

  void checkFromProfilePage() {
    if (widget.isLibraryForProfile != null && widget.profileListTypes != null) {
      if (widget.isLibraryForProfile!) {
        if (widget.profileListTypes! == ProfileListTypes.PURCHASED_SONGS) {
          ///OPEN PURCHASED SONGS PAGE
          BlocProvider.of<PurchasedTabPagesCubit>(context).changePage(
            AppPurchasedPageItemTypes.SONGS,
          );
        }
        if (widget.profileListTypes! == ProfileListTypes.PURCHASED_PLAYLISTS) {
          ///OPEN PURCHASED PLAYLISTS PAGE
          BlocProvider.of<PurchasedTabPagesCubit>(context).changePage(
            AppPurchasedPageItemTypes.PLAYLISTS,
          );
        }
        if (widget.profileListTypes! == ProfileListTypes.PURCHASED_ALBUMS) {
          ///OPEN PURCHASED ALBUMS PAGE
          BlocProvider.of<PurchasedTabPagesCubit>(context).changePage(
            AppPurchasedPageItemTypes.ALBUMS,
          );
        }
        if (widget.profileListTypes! == ProfileListTypes.FOLLOWED_PLAYLISTS) {
          ///OPEN PURCHASED PLAYLISTS PAGE
          BlocProvider.of<FollowingTabPagesCubit>(context).changePage(
            AppFollowedPageItemTypes.PLAYLISTS,
          );
        }
        if (widget.profileListTypes! == ProfileListTypes.FOLLOWED_ARTISTS) {
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
