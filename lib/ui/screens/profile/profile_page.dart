import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/page_dominant_color_bloc/pages_dominant_color_bloc.dart';
import 'package:mehaley/business_logic/blocs/profile_page/profile_page_bloc.dart';
import 'package:mehaley/business_logic/cubits/app_user_widgets_cubit.dart';
import 'package:mehaley/business_logic/cubits/bottom_bar_cubit/bottom_bar_cubit.dart';
import 'package:mehaley/business_logic/cubits/bottom_bar_cubit/bottom_bar_profile_cubit.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/api_response/profile_page_data.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_error.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/app_subscribe_card.dart';
import 'package:mehaley/ui/common/app_subscription_active_card.dart';
import 'package:mehaley/ui/screens/profile/widgets/profile_lists.dart';
import 'package:mehaley/ui/screens/profile/widgets/profile_page_header_deligate.dart';
import 'package:mehaley/ui/screens/profile/widgets/profile_page_tabs_deligate.dart';
import 'package:mehaley/util/auth_util.dart';
import 'package:mehaley/util/color_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with RouteAware {
  //NOTIFIER FOR DOTED INDICATOR
  final ValueNotifier<int> pageNotifier = new ValueNotifier<int>(0);

  //DOMINANT COLOR INIT
  Color dominantColor = AppColors.appGradientDefaultColorBlack;

  ///IS USER SUBSCRIBED AND IAP AVAILABLE
  final bool isUsersSubscribed = PagesUtilFunctions.isUserSubscribed();

  void didChangeDependencies() {
    super.didChangeDependencies();
    //SUBSCRIBE TO ROUTH OBSERVER
    AppRouterPaths.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    if (isUsersSubscribed ) {
      BlocProvider.of<BottomBarCubit>(context)
          .changeScreen(BottomBarPages.PROFILE);
      BlocProvider.of<BottomBarProfileCubit>(context).setPageShowing(true);
    }
  }

  @override
  void didPushNext() {
    if (isUsersSubscribed ) {
      BlocProvider.of<BottomBarProfileCubit>(context).setPageShowing(false);
    }
    super.didPushNext();
  }

  @override
  void didPop() {
    if (isUsersSubscribed ) {
      BlocProvider.of<BottomBarProfileCubit>(context).setPageShowing(false);
    }
    super.didPop();
  }

  @override
  void dispose() {
    AppRouterPaths.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void initState() {
    if (isUsersSubscribed) {
      BlocProvider.of<BottomBarProfileCubit>(context).setPageShowing(true);

      ///CHANGE BOTTOM BAR TO SUBSCRIPTION PAGE
      BlocProvider.of<BottomBarCubit>(context).changeScreen(
        BottomBarPages.PROFILE,
      );
    }

    ///LOAD PROFILE DATA
    BlocProvider.of<ProfilePageBloc>(context).add(
      LoadProfilePageEvent(),
    );

    ///CHANGE DOMINANT COLOR
    BlocProvider.of<PagesDominantColorBloc>(context).add(
      UserProfilePageDominantColorChanged(
        dominantColor: AuthUtil.getDominantColor(
            BlocProvider.of<AppUserWidgetsCubit>(context).state),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorMapper.getPagesBgColor(),
      body: CustomScrollView(
        slivers: [
          BlocBuilder<PagesDominantColorBloc, PagesDominantColorState>(
            builder: (context, state) {
              if (state is ProfilePageDominantColorChangedState) {
                dominantColor = ColorUtil.changeColorSaturation(
                  state.color,
                  0.5,
                );
              }
              return SliverPersistentHeader(
                delegate: ProfilePageHeaderDelegate(
                  onBackPress: () {
                    Navigator.pop(context);
                  },
                  dominantColor: dominantColor,
                ),
                floating: false,
                pinned: true,
              );
            },
          ),
          SliverPersistentHeader(
            delegate: ProfilePageTabsDelegate(
              height: ScreenUtil(context: context).getScreenHeight() * 0.08,
            ),
            floating: false,
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: BlocBuilder<ProfilePageBloc, ProfilePageState>(
              builder: (context, state) {
                if (state is ProfilePageLoadingState) {
                  return buildPageLoading();
                }
                if (state is ProfilePageLoadedState) {
                  if (isDataEmpty(state.profilePageData)) {
                    return buildEmptyBox();
                  }
                  return buildPageLoaded(state.profilePageData);
                }
                if (state is ProfilePageLoadingErrorState) {
                  return buildPageError(context);
                }
                return buildPageLoading();
              },
            ),
          ),
        ],
      ),
    );
  }

  Column buildEmptyBox() {
    return Column(
      children: [
        SizedBox(height: AppMargin.margin_58),
        Icon(
          FlutterRemix.archive_line,
          color: ColorMapper.getBlack().withOpacity(0.2),
          size: AppIconSizes.icon_size_32,
        ),
        SizedBox(height: AppMargin.margin_8),
        Text(
          AppLocale.of().notingToShow,
          style: TextStyle(
            color: ColorMapper.getTxtGrey(),
            fontSize: AppFontSizes.font_size_10.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Container buildPageError(BuildContext context) {
    return Container(
      height: ScreenUtil(
            context: context,
          ).getScreenHeight() *
          0.32,
      child: AppError(
        onRetry: () {
          BlocProvider.of<ProfilePageBloc>(context).add(
            LoadProfilePageEvent(),
          );
        },
        bgWidget: buildPageLoading(),
      ),
    );
  }

  Column buildPageLoading() {
    return Column(
      children: [
        SizedBox(
          height: AppMargin.margin_32,
        ),
        AppLoading(
          size: AppValues.loadingWidgetSize / 2,
        ),
      ],
    );
  }

  Column buildPageLoaded(ProfilePageData profilePageData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///ACTIVE SUBSCRIPTION CARD
        AppSubscriptionActiveCard(
          topMargin: 0.0,
          bottomMargin: AppMargin.margin_24,
        ),

        // SizedBox(
        //   height: AppMargin.margin_16,
        // ),
        profilePageData.boughtSongs.length > 0
            ? buildProfileListHeader(
                title: AppLocale.of().purchasedMezmurs,
                actionTitle: AppLocale.of().seeAll,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRouterPaths.libraryRoute,
                    arguments: ScreenArguments(
                      args: {
                        AppValues.isLibraryForOffline: false,
                        AppValues.isLibraryForOtherPage: true,
                        AppValues.libraryFromOtherPageTypes:
                            LibraryFromOtherPageTypes.PURCHASED_SONGS,
                      },
                    ),
                  );
                },
              )
            : SizedBox(),
        ProfileLists(
          profileListTypes: LibraryFromOtherPageTypes.PURCHASED_SONGS,
          profilePageData: profilePageData,
        ),
        profilePageData.boughtAlbums.length > 0
            ? buildProfileListHeader(
                title: AppLocale.of().purchasedAlbums,
                actionTitle: AppLocale.of().seeAll,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRouterPaths.libraryRoute,
                    arguments: ScreenArguments(
                      args: {
                        AppValues.isLibraryForOffline: false,
                        AppValues.isLibraryForOtherPage: true,
                        AppValues.libraryFromOtherPageTypes:
                            LibraryFromOtherPageTypes.PURCHASED_ALBUMS,
                      },
                    ),
                  );
                },
              )
            : SizedBox(),
        ProfileLists(
          profileListTypes: LibraryFromOtherPageTypes.PURCHASED_ALBUMS,
          profilePageData: profilePageData,
        ),
        profilePageData.boughtPlaylists.length > 0
            ? buildProfileListHeader(
                title: AppLocale.of().purchasedPlaylists,
                actionTitle: AppLocale.of().seeAll,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRouterPaths.libraryRoute,
                    arguments: ScreenArguments(
                      args: {
                        AppValues.isLibraryForOffline: false,
                        AppValues.isLibraryForOtherPage: true,
                        AppValues.libraryFromOtherPageTypes:
                            LibraryFromOtherPageTypes.PURCHASED_PLAYLISTS,
                      },
                    ),
                  );
                },
              )
            : SizedBox(),
        ProfileLists(
          profileListTypes: LibraryFromOtherPageTypes.PURCHASED_PLAYLISTS,
          profilePageData: profilePageData,
        ),
        profilePageData.followedArtists.length > 0
            ? buildProfileListHeader(
                title: AppLocale.of().followedArtists,
                actionTitle: AppLocale.of().seeAll,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRouterPaths.libraryRoute,
                    arguments: ScreenArguments(
                      args: {
                        AppValues.isLibraryForOffline: false,
                        AppValues.isLibraryForOtherPage: true,
                        AppValues.libraryFromOtherPageTypes:
                            LibraryFromOtherPageTypes.FOLLOWED_ARTISTS,
                      },
                    ),
                  );
                },
              )
            : SizedBox(),
        ProfileLists(
          profileListTypes: LibraryFromOtherPageTypes.FOLLOWED_ARTISTS,
          profilePageData: profilePageData,
        ),
        profilePageData.followedPlaylists.length > 0
            ? buildProfileListHeader(
                title: AppLocale.of().followedPlaylists,
                actionTitle: AppLocale.of().seeAll,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRouterPaths.libraryRoute,
                    arguments: ScreenArguments(
                      args: {
                        AppValues.isLibraryForOffline: false,
                        AppValues.isLibraryForOtherPage: true,
                        AppValues.libraryFromOtherPageTypes:
                            LibraryFromOtherPageTypes.FOLLOWED_PLAYLISTS,
                      },
                    ),
                  );
                },
              )
            : SizedBox(),
        ProfileLists(
          profileListTypes: LibraryFromOtherPageTypes.FOLLOWED_PLAYLISTS,
          profilePageData: profilePageData,
        ),
        SizedBox(
          height: AppMargin.margin_16,
        ),

        ///SUBSCRIBE CARD
        AppSubscribeCard(
          topMargin: AppMargin.margin_24,
          bottomMargin: 0.0,
        ),
      ],
    );
  }

  AppBouncingButton buildProfileListHeader({
    required String title,
    required String actionTitle,
    required VoidCallback onTap,
  }) {
    return AppBouncingButton(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(
          left: AppPadding.padding_16,
          right: AppPadding.padding_16,
          top: AppPadding.padding_20 * 2,
          bottom: AppPadding.padding_16,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: AppFontSizes.font_size_12.sp,
                color: ColorMapper.getDarkGrey(),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: AppMargin.margin_4,
            ),
            Icon(
              FlutterRemix.arrow_right_s_line,
              color: ColorMapper.getDarkGrey(),
              size: AppIconSizes.icon_size_20,
            ),
          ],
        ),
      ),
    );
  }

  bool isDataEmpty(ProfilePageData profilePageData) {
    int total = profilePageData.followedArtists.length;
    total = total + profilePageData.followedPlaylists.length;
    total = total + profilePageData.boughtSongs.length;
    total = total + profilePageData.boughtAlbums.length;
    total = total + profilePageData.boughtPlaylists.length;

    return total > 0 ? false : true;
  }
}
