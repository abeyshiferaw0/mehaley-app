import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/library_page_bloc/followed_artist_bloc/followed_artists_bloc.dart';
import 'package:mehaley/business_logic/blocs/library_page_bloc/followed_playlist_bloc/followed_playlists_bloc.dart';
import 'package:mehaley/business_logic/cubits/library/following_tab_pages_cubit.dart';
import 'package:mehaley/business_logic/cubits/library/library_tab_pages_cubit.dart';
import 'package:mehaley/config/app_repositories.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/screens/library/tab_pages/tab_pages/followed_artists_page.dart';
import 'package:mehaley/ui/screens/library/tab_pages/tab_pages/followed_playlists_page.dart';

import '../widgets/library_sub_tab_button.dart';

class FollowingTabView extends StatefulWidget {
  const FollowingTabView({Key? key}) : super(key: key);

  @override
  _FollowingTabViewState createState() => _FollowingTabViewState();
}

class _FollowingTabViewState extends State<FollowingTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FollowedArtistsBloc(
            libraryPageDataRepository:
                AppRepositories.libraryPageDataRepository,
          ),
        ),
        BlocProvider(
          create: (context) => FollowedPlaylistsBloc(
            libraryPageDataRepository:
                AppRepositories.libraryPageDataRepository,
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          return RefreshIndicator(
            onRefresh: () async {
              if (BlocProvider.of<LibraryTabPagesCubit>(context).state == 3) {
                refreshPage(context);
              }
            },
            color: AppColors.darkOrange,
            edgeOffset: AppMargin.margin_16,
            child: Container(
              height: double.infinity,
              padding: EdgeInsets.only(left: AppPadding.padding_16),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: AppMargin.margin_8),
                    buildSubTabs(),
                    BlocBuilder<FollowingTabPagesCubit,
                        AppFollowedPageItemTypes>(
                      builder: (context, state) {
                        if (state == AppFollowedPageItemTypes.ARTIST) {
                          return FollowedArtistsPage();
                        } else if (state ==
                            AppFollowedPageItemTypes.PLAYLISTS) {
                          return FollowedPlaylistsPage();
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  BlocBuilder buildSubTabs() {
    return BlocBuilder<FollowingTabPagesCubit, AppFollowedPageItemTypes>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                physics: BouncingScrollPhysics(),
                child: Row(
                  children: [
                    LibraryPageSubTabButton(
                      text: AppLocale.of().artists.toUpperCase(),
                      isSelected: state == AppFollowedPageItemTypes.ARTIST,
                      onTap: () {
                        if (!(state == AppFollowedPageItemTypes.ARTIST))
                          BlocProvider.of<FollowingTabPagesCubit>(context)
                              .changePage(
                            AppFollowedPageItemTypes.ARTIST,
                          );
                      },
                      hasLeftMargin: false,
                    ),
                    LibraryPageSubTabButton(
                      text: AppLocale.of().playlists.toUpperCase(),
                      isSelected: state == AppFollowedPageItemTypes.PLAYLISTS,
                      onTap: () {
                        if (!(state == AppFollowedPageItemTypes.PLAYLISTS))
                          BlocProvider.of<FollowingTabPagesCubit>(context)
                              .changePage(
                            AppFollowedPageItemTypes.PLAYLISTS,
                          );
                      },
                      hasLeftMargin: true,
                    )
                  ],
                ),
              ),
            ),
            // LibraryIconButton(
            //   onTap: () {},
            //   iconColor: AppColors.white,
            //   icon: FlutterRemix.shuffle_line,
            // )
          ],
        );
      },
    );
  }

  Future<void> refreshPage(BuildContext builderContext) async {
    AppFollowedPageItemTypes appFollowedPageItemTypes =
        BlocProvider.of<FollowingTabPagesCubit>(builderContext).state;
    if (appFollowedPageItemTypes == AppFollowedPageItemTypes.PLAYLISTS) {
      BlocProvider.of<FollowedPlaylistsBloc>(builderContext).add(
        RefreshFollowedPlaylistsEvent(),
      );
      await BlocProvider.of<FollowedPlaylistsBloc>(context).stream.first;
    }
    if (appFollowedPageItemTypes == AppFollowedPageItemTypes.ARTIST) {
      BlocProvider.of<FollowedArtistsBloc>(builderContext).add(
        RefreshFollowedArtistsEvent(),
      );
      await BlocProvider.of<FollowedArtistsBloc>(context).stream.first;
    }
  }
}
