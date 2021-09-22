import 'package:elf_play/business_logic/blocs/library_page_bloc/purchased_albums_bloc/purchased_albums_bloc.dart';
import 'package:elf_play/business_logic/blocs/library_page_bloc/purchased_all_songs_bloc/purchased_all_songs_bloc.dart';
import 'package:elf_play/business_logic/blocs/library_page_bloc/purchased_playlist_bloc/purchased_playlist_bloc.dart';
import 'package:elf_play/business_logic/blocs/library_page_bloc/purchased_songs_bloc/purchased_songs_bloc.dart';
import 'package:elf_play/business_logic/cubits/library/purchased_tab_pages_cubit.dart';
import 'package:elf_play/config/app_repositories.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/screens/library/tab_pages/tab_pages/purchased_albums_page.dart';
import 'package:elf_play/ui/screens/library/tab_pages/tab_pages/purchased_all_songs_page.dart';
import 'package:elf_play/ui/screens/library/tab_pages/tab_pages/purchased_playlists_page.dart';
import 'package:elf_play/ui/screens/library/tab_pages/tab_pages/purchased_songs_page.dart';
import 'package:elf_play/ui/screens/library/widgets/library_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

import '../widgets/library_sub_tab_button.dart';

class PurchasedTabView extends StatefulWidget {
  const PurchasedTabView({Key? key}) : super(key: key);

  @override
  _PurchasedTabViewState createState() => _PurchasedTabViewState();
}

class _PurchasedTabViewState extends State<PurchasedTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PurchasedTabPagesCubit(),
        ),
        BlocProvider(
          create: (context) => PurchasedAllSongsBloc(
            libraryPageDataRepository:
                AppRepositories.libraryPageDataRepository,
          ),
        ),
        BlocProvider(
          create: (context) => PurchasedSongsBloc(
            libraryPageDataRepository:
                AppRepositories.libraryPageDataRepository,
          ),
        ),
        BlocProvider(
          create: (context) => PurchasedAlbumsBloc(
            libraryPageDataRepository:
                AppRepositories.libraryPageDataRepository,
          ),
        ),
        BlocProvider(
          create: (context) => PurchasedPlaylistBloc(
            libraryPageDataRepository:
                AppRepositories.libraryPageDataRepository,
          ),
        )
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
                BlocBuilder<PurchasedTabPagesCubit, AppPurchasedPageItemTypes>(
                  builder: (context, state) {
                    if (state == AppPurchasedPageItemTypes.ALL_SONGS) {
                      return PurchasedAllSongsPage();
                    } else if (state == AppPurchasedPageItemTypes.SONGS) {
                      return PurchasedSongsPage();
                    } else if (state == AppPurchasedPageItemTypes.ALBUMS) {
                      return PurchasedAlbumsPage();
                    } else if (state == AppPurchasedPageItemTypes.PLAYLISTS) {
                      return PurchasedPlaylistsPage();
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
    return BlocBuilder<PurchasedTabPagesCubit, AppPurchasedPageItemTypes>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: Row(
                  children: [
                    LibraryPageSubTabButton(
                      text: "ALL",
                      isSelected: state == AppPurchasedPageItemTypes.ALL_SONGS,
                      onTap: () {
                        if (!(state == AppPurchasedPageItemTypes.ALL_SONGS))
                          BlocProvider.of<PurchasedTabPagesCubit>(context)
                              .changePage(
                            AppPurchasedPageItemTypes.ALL_SONGS,
                          );
                      },
                      hasLeftMargin: false,
                    ),
                    LibraryPageSubTabButton(
                      text: "MEZMURS",
                      isSelected: state == AppPurchasedPageItemTypes.SONGS,
                      onTap: () {
                        if (!(state == AppPurchasedPageItemTypes.SONGS))
                          BlocProvider.of<PurchasedTabPagesCubit>(context)
                              .changePage(
                            AppPurchasedPageItemTypes.SONGS,
                          );
                      },
                      hasLeftMargin: true,
                    ),
                    LibraryPageSubTabButton(
                      text: "ALBUMS",
                      isSelected: state == AppPurchasedPageItemTypes.ALBUMS,
                      onTap: () {
                        if (!(state == AppPurchasedPageItemTypes.ALBUMS))
                          BlocProvider.of<PurchasedTabPagesCubit>(context)
                              .changePage(
                            AppPurchasedPageItemTypes.ALBUMS,
                          );
                      },
                      hasLeftMargin: true,
                    ),
                    LibraryPageSubTabButton(
                      text: "PLAYLISTS",
                      isSelected: state == AppPurchasedPageItemTypes.PLAYLISTS,
                      onTap: () {
                        if (!(state == AppPurchasedPageItemTypes.PLAYLISTS))
                          BlocProvider.of<PurchasedTabPagesCubit>(context)
                              .changePage(
                            AppPurchasedPageItemTypes.PLAYLISTS,
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
              icon: PhosphorIcons.sort_ascending_light,
            ),
            LibraryIconButton(
              onTap: () {},
              iconColor: AppColors.white,
              icon: PhosphorIcons.shuffle_light,
            ),
          ],
        );
      },
    );
  }
}
