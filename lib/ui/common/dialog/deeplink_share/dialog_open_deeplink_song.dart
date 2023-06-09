import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/share_bloc/deeplink_song_bloc/deep_link_song_bloc.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/widget_error_widget.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

import '../../app_loading.dart';
import '../../app_top_header_with_icon.dart';

class DialogDeeplinkSong extends StatefulWidget {
  const DialogDeeplinkSong({
    Key? key,
    required this.songId,
    required this.onSongFetched,
  }) : super(key: key);

  final int songId;
  final Function(Song song) onSongFetched;

  @override
  State<DialogDeeplinkSong> createState() => _DialogDeeplinkSongState();
}

class _DialogDeeplinkSongState extends State<DialogDeeplinkSong> {
  @override
  void initState() {
    BlocProvider.of<DeepLinkSongBloc>(context).add(
      LoadDeepLinkSongEvent(songId: widget.songId),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Wrap(
          children: [
            Container(
              width: ScreenUtil(context: context).getScreenWidth() * 0.8,
              decoration: BoxDecoration(
                color: ColorMapper.getWhite(),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ///TOP HEADER
                  AppTopHeaderWithIcon(),
                  BlocConsumer<DeepLinkSongBloc, DeepLinkSongState>(
                    listener: (context, state) {
                      if (state is DeepLinkSongLoaded) {
                        Navigator.pop(context);
                        widget.onSongFetched(state.song);
                      }
                    },
                    builder: (context, state) {
                      if (state is DeepLinkSongLoading) {
                        return buildBuyingLoading();
                      }
                      if (state is DeepLinkSongLoadingError) {
                        return buildError();
                      }
                      if (state is DeepLinkSongLoaded) {
                        return buildBuyingLoading();
                      }
                      return buildBuyingLoading();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBuyingLoading() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: AppMargin.margin_32,
          ),
          AppLoading(
            size: AppValues.loadingWidgetSize * 0.8,
          ),
          SizedBox(
            height: AppMargin.margin_32,
          ),
          Text(
            AppLocale.of().openingSong.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w400,
              color: ColorMapper.getBlack(),
            ),
          ),
          SizedBox(
            height: AppMargin.margin_32,
          ),
        ],
      ),
    );
  }

  Widget buildError() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppPadding.padding_32),
      child: WidgetErrorWidget(
        title: AppLocale.of().noInternetMsg,
        subTitle: AppLocale.of().checkYourInternetConnection,
        onRetry: () {
          BlocProvider.of<DeepLinkSongBloc>(context).add(
            LoadDeepLinkSongEvent(songId: widget.songId),
          );
        },
      ),
    );
  }
}
