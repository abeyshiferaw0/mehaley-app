import 'package:elf_play/business_logic/cubits/library/following_tab_pages_cubit.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/library_my_playlist_item.dart';
import '../widgets/library_sub_tab_button.dart';

class MyPlaylistTabView extends StatefulWidget {
  const MyPlaylistTabView({Key? key, required this.onGoToFollowedPlaylist})
      : super(key: key);

  final VoidCallback onGoToFollowedPlaylist;

  @override
  _MyPlaylistTabViewState createState() => _MyPlaylistTabViewState();
}

class _MyPlaylistTabViewState extends State<MyPlaylistTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {},
      color: AppColors.darkGreen,
      edgeOffset: AppMargin.margin_16,
      child: Container(
        color: AppColors.black,
        padding: EdgeInsets.only(left: AppPadding.padding_16),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: AppMargin.margin_8),
              buildSubTabs(),
              SizedBox(height: AppMargin.margin_8),
              ListView.separated(
                itemCount: 30,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) {
                  return SizedBox(height: AppMargin.margin_16);
                },
                itemBuilder: (context, index) {
                  return LibraryMyPlaylistItem(
                    isCreatePlaylistButton: index == 0 ? true : false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  SingleChildScrollView buildSubTabs() {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          LibraryPageSubTabButton(
            text: "MY PLAYLISTS",
            isSelected: true,
            onTap: () {},
            hasLeftMargin: false,
          ),
          LibraryPageSubTabButton(
            text: "FOLLOWING",
            isSelected: false,
            onTap: () {
              widget.onGoToFollowedPlaylist();
              BlocProvider.of<FollowingTabPagesCubit>(context).changePage(
                AppFollowedPageItemTypes.PLAYLISTS,
              );
            },
            hasLeftMargin: true,
          ),
        ],
      ),
    );
  }
}
