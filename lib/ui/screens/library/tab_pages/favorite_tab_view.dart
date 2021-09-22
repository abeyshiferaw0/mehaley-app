import 'package:elf_play/business_logic/blocs/library_page_bloc/favorite_album_bloc/favorite_albums_bloc.dart';
import 'package:elf_play/business_logic/blocs/library_page_bloc/favorite_songs_bloc/favorite_songs_bloc.dart';
import 'package:elf_play/business_logic/cubits/library/favorite_tab_pages_cubit.dart';
import 'package:elf_play/config/app_repositories.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/screens/library/tab_pages/tab_pages/favorite_albums_page.dart';
import 'package:elf_play/ui/screens/library/tab_pages/tab_pages/favorite_songs_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

import '../widgets/library_icon_button.dart';
import '../widgets/library_sub_tab_button.dart';

class FavoriteTabView extends StatefulWidget {
  const FavoriteTabView({Key? key}) : super(key: key);

  @override
  _FavoriteTabViewState createState() => _FavoriteTabViewState();
}

class _FavoriteTabViewState extends State<FavoriteTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FavoriteTabPagesCubit(),
        ),
        BlocProvider(
          create: (context) => FavoriteSongsBloc(
            libraryPageDataRepository:
                AppRepositories.libraryPageDataRepository,
          ),
        ),
        BlocProvider(
          create: (context) => FavoriteAlbumsBloc(
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
                BlocBuilder<FavoriteTabPagesCubit, AppFavoritePageItemTypes>(
                  builder: (context, state) {
                    if (state == AppFavoritePageItemTypes.SONGS) {
                      return FavoriteSongsPage();
                    } else if (state == AppFavoritePageItemTypes.ALBUMS) {
                      return FavoriteAlbumsPage();
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
    return BlocBuilder<FavoriteTabPagesCubit, AppFavoritePageItemTypes>(
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
                      text: "MEZMURS",
                      isSelected: state == AppFavoritePageItemTypes.SONGS,
                      onTap: () {
                        if (!(state == AppFavoritePageItemTypes.SONGS))
                          BlocProvider.of<FavoriteTabPagesCubit>(context)
                              .changePage(
                            AppFavoritePageItemTypes.SONGS,
                          );
                      },
                      hasLeftMargin: false,
                    ),
                    LibraryPageSubTabButton(
                      text: "ALBUMS",
                      isSelected: state == AppFavoritePageItemTypes.ALBUMS,
                      onTap: () {
                        if (!(state == AppFavoritePageItemTypes.ALBUMS))
                          BlocProvider.of<FavoriteTabPagesCubit>(context)
                              .changePage(
                            AppFavoritePageItemTypes.ALBUMS,
                          );
                      },
                      hasLeftMargin: true,
                    ),
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
