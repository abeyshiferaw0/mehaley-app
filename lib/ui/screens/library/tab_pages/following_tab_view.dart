import 'package:elf_play/business_logic/blocs/library_page_bloc/followed_artist_bloc/followed_artists_bloc.dart';
import 'package:elf_play/business_logic/blocs/library_page_bloc/followed_playlist_bloc/followed_playlists_bloc.dart';
import 'package:elf_play/business_logic/cubits/library/following_tab_pages_cubit.dart';
import 'package:elf_play/config/app_repositories.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/screens/library/tab_pages/tab_pages/followed_artists_page.dart';
import 'package:elf_play/ui/screens/library/tab_pages/tab_pages/followed_playlists_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

import '../widgets/library_icon_button.dart';
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
      child: RefreshIndicator(
        onRefresh: () async {},
        color: AppColors.darkGreen,
        edgeOffset: AppMargin.margin_16,
        child: Container(
          color: AppColors.black,
          height: double.infinity,
          padding: EdgeInsets.only(left: AppPadding.padding_16),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: AppMargin.margin_8),
                buildSubTabs(),
                BlocBuilder<FollowingTabPagesCubit, AppFollowedPageItemTypes>(
                  builder: (context, state) {
                    if (state == AppFollowedPageItemTypes.ARTIST) {
                      return FollowedArtistsPage();
                    } else if (state == AppFollowedPageItemTypes.PLAYLISTS) {
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
                      text: "ARTISTS",
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
                      text: "PLAYLISTS",
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
            LibraryIconButton(
              onTap: () {},
              iconColor: AppColors.white,
              icon: PhosphorIcons.shuffle_light,
            )
          ],
        );
      },
    );
  }
}
