import 'package:elf_play/business_logic/blocs/page_dominant_color_bloc/pages_dominant_color_bloc.dart';
import 'package:elf_play/business_logic/blocs/profile_page/profile_page_bloc.dart';
import 'package:elf_play/business_logic/cubits/app_user_widgets_cubit.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/api_response/profile_page_data.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/app_error.dart';
import 'package:elf_play/ui/common/app_loading.dart';
import 'package:elf_play/ui/screens/profile/widgets/profile_lists.dart';
import 'package:elf_play/ui/screens/profile/widgets/profile_page_header_deligate.dart';
import 'package:elf_play/ui/screens/profile/widgets/profile_page_tabs_deligate.dart';
import 'package:elf_play/util/auth_util.dart';
import 'package:elf_play/util/color_util.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //NOTIFIER FOR DOTED INDICATOR
  final ValueNotifier<int> pageNotifier = new ValueNotifier<int>(0);

  //DOMINANT COLOR INIT
  Color dominantColor = AppColors.appGradientDefaultColorBlack;

  @override
  void initState() {
    ///LOAD PROFILE DATA
    BlocProvider.of<ProfilePageBloc>(context).add(
      LoadProfilePageEvent(),
    );

    ///CHANGE DOMINANT COLOR
    BlocProvider.of<PagesDominantColorBloc>(context).add(
      UserProfilePageDominantColorChanged(
        dominantColor: AuthUtil.getDominantColor(BlocProvider.of<AppUserWidgetsCubit>(context).state),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
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
          PhosphorIcons.cube_thin,
          color: AppColors.white.withOpacity(0.2),
          size: AppIconSizes.icon_size_32,
        ),
        SizedBox(height: AppMargin.margin_8),
        Text(
          AppLocalizations.of(context)!.notingToShow,
          style: TextStyle(
            color: AppColors.txtGrey,
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
      children: [
        SizedBox(
          height: AppMargin.margin_32,
        ),
        profilePageData.boughtSongs.length > 0
            ? buildProfileListHeader(
                title: AppLocalizations.of(context)!.purchasedMezmurs,
                actionTitle: AppLocalizations.of(context)!.seeAll,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRouterPaths.libraryRoute,
                    arguments: ScreenArguments(
                      args: {
                        AppValues.isLibraryForOffline: false,
                        AppValues.isLibraryForProfile: true,
                        AppValues.profileListTypes: ProfileListTypes.PURCHASED_SONGS,
                      },
                    ),
                  );
                },
              )
            : SizedBox(),
        ProfileLists(
          profileListTypes: ProfileListTypes.PURCHASED_SONGS,
          profilePageData: profilePageData,
        ),
        profilePageData.boughtAlbums.length > 0
            ? buildProfileListHeader(
                title: AppLocalizations.of(context)!.purchasedAlbums,
                actionTitle: AppLocalizations.of(context)!.seeAll,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRouterPaths.libraryRoute,
                    arguments: ScreenArguments(
                      args: {
                        AppValues.isLibraryForOffline: false,
                        AppValues.isLibraryForProfile: true,
                        AppValues.profileListTypes: ProfileListTypes.PURCHASED_ALBUMS,
                      },
                    ),
                  );
                },
              )
            : SizedBox(),
        ProfileLists(
          profileListTypes: ProfileListTypes.PURCHASED_ALBUMS,
          profilePageData: profilePageData,
        ),
        profilePageData.boughtPlaylists.length > 0
            ? buildProfileListHeader(
                title: AppLocalizations.of(context)!.purchasedPlaylists,
                actionTitle: AppLocalizations.of(context)!.seeAll,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRouterPaths.libraryRoute,
                    arguments: ScreenArguments(
                      args: {
                        AppValues.isLibraryForOffline: false,
                        AppValues.isLibraryForProfile: true,
                        AppValues.profileListTypes: ProfileListTypes.PURCHASED_PLAYLISTS,
                      },
                    ),
                  );
                },
              )
            : SizedBox(),
        ProfileLists(
          profileListTypes: ProfileListTypes.PURCHASED_PLAYLISTS,
          profilePageData: profilePageData,
        ),
        profilePageData.followedArtists.length > 0
            ? buildProfileListHeader(
                title: AppLocalizations.of(context)!.followedArtists,
                actionTitle: AppLocalizations.of(context)!.seeAll,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRouterPaths.libraryRoute,
                    arguments: ScreenArguments(
                      args: {
                        AppValues.isLibraryForOffline: false,
                        AppValues.isLibraryForProfile: true,
                        AppValues.profileListTypes: ProfileListTypes.FOLLOWED_ARTISTS,
                      },
                    ),
                  );
                },
              )
            : SizedBox(),
        ProfileLists(
          profileListTypes: ProfileListTypes.FOLLOWED_ARTISTS,
          profilePageData: profilePageData,
        ),
        profilePageData.followedPlaylists.length > 0
            ? buildProfileListHeader(
                title: AppLocalizations.of(context)!.followedPlaylists,
                actionTitle: AppLocalizations.of(context)!.seeAll,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRouterPaths.libraryRoute,
                    arguments: ScreenArguments(
                      args: {
                        AppValues.isLibraryForOffline: false,
                        AppValues.isLibraryForProfile: true,
                        AppValues.profileListTypes: ProfileListTypes.FOLLOWED_PLAYLISTS,
                      },
                    ),
                  );
                },
              )
            : SizedBox(),
        ProfileLists(
          profileListTypes: ProfileListTypes.FOLLOWED_PLAYLISTS,
          profilePageData: profilePageData,
        ),
        SizedBox(
          height: AppMargin.margin_16,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: AppFontSizes.font_size_12.sp,
                color: AppColors.lightGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: AppMargin.margin_8,
            ),
            Icon(
              PhosphorIcons.caret_right_light,
              color: AppColors.lightGrey,
              size: AppIconSizes.icon_size_12,
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
