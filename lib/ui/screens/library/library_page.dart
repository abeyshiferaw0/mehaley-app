import 'package:elf_play/business_logic/cubits/bottom_bar_cubit/bottom_bar_cubit.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/screens/library/tab_pages/favorite_tab_view.dart';
import 'package:elf_play/ui/screens/library/tab_pages/following_tab_view.dart';
import 'package:elf_play/ui/screens/library/tab_pages/my_playlist_tab_view.dart';
import 'package:elf_play/ui/screens/library/tab_pages/offline_tab_view.dart';
import 'package:elf_play/ui/screens/library/tab_pages/purchased_tab_view.dart';
import 'package:elf_play/ui/screens/library/widgets/library_header_persistant_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({
    Key? key,
    required this.isFromOffline,
  }) : super(key: key);

  final bool isFromOffline;

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with TickerProviderStateMixin, RouteAware {
  ///TAB CONTROLLER
  late TabController _tabController;

  @override
  void didPopNext() {
    BlocProvider.of<BottomBarCubit>(context).changeScreen(
      BottomBarPages.LIBRARY,
    );
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
    super.initState();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();

    ///NAVIGATE TO OFFLINE TAB IF TRUE
    if (widget.isFromOffline) {
      _tabController.animateTo(1, duration: Duration(milliseconds: 300));
    }

    ///SUBSCRIBE TO ROUTH OBSERVER
    AppRouterPaths.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGrey,
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
          key: Key("PurchasedTabView"),
        ),
        OfflineTabView(
          key: Key("OfflineTabView"),
        ),
        MyPlaylistTabView(
          key: Key(
            "MyPlaylistTabView",
          ),
          onGoToFollowedPlaylist: () {
            _tabController.animateTo(4);
          },
        ),
        FavoriteTabView(
          key: Key("FavoriteTabView"),
        ),
        FollowingTabView(
          key: Key("FollowingTabView"),
        ),
      ],
    );
  }

  SliverAppBar buildAppBar() {
    return SliverAppBar(
      brightness: Brightness.dark,
      backgroundColor: AppColors.darkGrey,
      shadowColor: AppColors.transparent,
      floating: true,
      pinned: false,
      leadingWidth: 80,
      leading: Center(
        child: Stack(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.blue,
              radius: 18,
              child: Text(
                "a",
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_16,
                  color: AppColors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Icon(
                PhosphorIcons.gear_six_bold,
                size: AppIconSizes.icon_size_12,
                color: AppColors.white,
              ),
            )
          ],
        ),
      ),
      title: Text(
        "abey shiferaw",
        style: TextStyle(
          fontSize: AppFontSizes.font_size_16,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            PhosphorIcons.bell_simple_light,
            color: AppColors.white,
            size: AppIconSizes.icon_size_24,
          ),
        )
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
