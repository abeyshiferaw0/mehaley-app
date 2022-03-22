import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/downloading_song_bloc/downloading_song_bloc.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_circular_progress_indicator.dart';
import 'package:mehaley/ui/common/dialog/dialog_delete_song.dart';
import 'package:mehaley/util/download_util.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:sizer/sizer.dart';

import '../app_snack_bar.dart';

class SongDownloadIndicator extends StatefulWidget {
  SongDownloadIndicator({
    Key? key,
    required this.song,
    required this.isForPlayerPage,
    required this.downloadingColor,
    required this.downloadedColor,
    required this.downloadingFailedColor,
  }) : super(key: key);

  final Song song;
  final bool isForPlayerPage;
  final Color downloadingColor;
  final Color downloadedColor;
  final Color downloadingFailedColor;

  @override
  _SongDownloadIndicatorState createState() => _SongDownloadIndicatorState();
}

class _SongDownloadIndicatorState extends State<SongDownloadIndicator> {
  final DownloadUtil downloadUtil = DownloadUtil();

  ///
  bool showDownloading = false;

  bool showDownloaded = false;

  bool showDownloadFailed = false;

  bool showEmpty = false;

  double downloadingProgress = 0;

  @override
  void initState() {
    BlocProvider.of<DownloadingSongBloc>(context).add(
      IsSongDownloadedEvent(
        song: widget.song,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DownloadingSongBloc, DownloadingSongState>(
      listener: (context, state) {
        if (state is DownloadingSongsRunningState) {
          if (state.song != null) {
            if (state.song!.songId == widget.song.songId) {
              setState(() {
                showDownloading = true;
                showDownloaded = false;
                showDownloadFailed = false;
                showEmpty = false;
                downloadingProgress = state.progress.toDouble();
                print("state.progress => ${state.progress}");
              });
            }
          }
        }
        if (state is DownloadingSongsCompletedState) {
          if (state.song != null) {
            if (state.song!.songId == widget.song.songId) {
              setState(() {
                showDownloading = false;
                showDownloaded = true;
                showDownloadFailed = false;
                showEmpty = false;
              });
            }
          }
        }
        if (state is DownloadingSongsFailedState) {
          if (state.song != null) {
            if (state.song!.songId == widget.song.songId) {
              setState(() {
                showDownloading = false;
                showDownloaded = false;
                showDownloadFailed = true;
                showEmpty = false;
              });
            }
          }
        }
        if (state is DownloadingSongDeletedState) {
          if (state.song.songId == widget.song.songId) {
            setState(() {
              showDownloading = false;
              showDownloaded = false;
              showDownloadFailed = false;
              showEmpty = true;
            });
          }
        }
        if (state is SongIsDownloadedState) {
          if (state.song.songId == widget.song.songId) {
            setState(() {
              showInitialStatus(state.downloadTaskStatus);
            });
          }
        }
      },
      child: Row(
        children: [
          buildDownloadingIndicator(),
          buildSongDownloadedButton(context),
          buildSongDownloadFailedButton(context),
          buildDownloadButton(),
          widget.isForPlayerPage
              ? SizedBox(
                  width: AppMargin.margin_8,
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Visibility buildSongDownloadedButton(context) {
    return Visibility(
      visible: showDownloaded,
      child: AppBouncingButton(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return Center(
                child: DialogDeleteSong(
                  mainButtonText: AppLocale.of().delete.toUpperCase(),
                  cancelButtonText: AppLocale.of().cancel,
                  titleText: AppLocale.of().areYouSureUwantDeleteFromDownloads(
                      songName: L10nUtil.translateLocale(
                          widget.song.songName, context)),
                  onDelete: () {
                    BlocProvider.of<DownloadingSongBloc>(context).add(
                      DeleteDownloadedSongEvent(song: widget.song),
                    );
                  },
                ),
              );
            },
          );
        },
        child: Padding(
          padding: EdgeInsets.all(AppPadding.padding_8),
          child: Row(
            children: [
              Icon(
                FlutterRemix.arrow_down_circle_fill,
                color: widget.downloadedColor,
                size: widget.isForPlayerPage
                    ? AppIconSizes.icon_size_20
                    : AppIconSizes.icon_size_24,
              ),
              widget.isForPlayerPage
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: AppPadding.padding_8,
                      ),
                      child: Text(
                        AppLocale.of().deleteMezmur,
                        style: TextStyle(
                          fontSize: AppFontSizes.font_size_8.sp,
                          color: ColorMapper.getWhite().withOpacity(0.7),
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Visibility buildSongDownloadFailedButton(context) {
    return Visibility(
      visible: showDownloadFailed,
      child: AppBouncingButton(
        onTap: () {
          EasyDebounce.debounce(
            'DOWNLOAD_BUTTON',
            Duration(milliseconds: 0),
            () {
              ///SHOW RETRYING MESSAGE
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: ColorMapper.getBlack().withOpacity(0.9),
                  isFloating: true,
                  msg: AppLocale.of().retryingDownloadMsg,
                  txtColor: ColorMapper.getWhite(),
                ),
              );

              BlocProvider.of<DownloadingSongBloc>(context).add(
                RetryDownloadSongEvent(
                  song: widget.song,
                  notificationTitle: AppLocale.of().downloading(
                    songName: L10nUtil.translateLocale(
                      widget.song.songName,
                      context,
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Padding(
          padding: EdgeInsets.all(
            AppPadding.padding_8,
          ),
          child: Row(
            children: [
              Icon(
                FlutterRemix.error_warning_fill,
                color: widget.downloadingFailedColor,
                size: widget.isForPlayerPage
                    ? AppIconSizes.icon_size_20
                    : AppIconSizes.icon_size_20,
              ),
              widget.isForPlayerPage
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: AppPadding.padding_8,
                      ),
                      child: Text(
                        AppLocale.of().retryDownload,
                        style: TextStyle(
                          fontSize: AppFontSizes.font_size_8.sp,
                          color: ColorMapper.getWhite().withOpacity(0.7),
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Visibility buildDownloadingIndicator() {
    return Visibility(
      visible: showDownloading,
      child: Container(
        margin: EdgeInsets.all(AppPadding.padding_8),
        child: Row(
          children: [
            Container(
              width: widget.isForPlayerPage
                  ? AppIconSizes.icon_size_24
                  : AppIconSizes.icon_size_16,
              height: widget.isForPlayerPage
                  ? AppIconSizes.icon_size_24
                  : AppIconSizes.icon_size_16,
              child: AppCircularProgressIndicator(
                progress: downloadingProgress,
                color: widget.downloadingColor,
              ),
            ),
            widget.isForPlayerPage
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: AppPadding.padding_8,
                    ),
                    child: Text(
                      AppLocale.of().downloadingStr,
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_8.sp,
                        color: ColorMapper.getWhite().withOpacity(0.7),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Visibility buildDownloadButton() {
    return Visibility(
        visible: showEmpty,
        child: widget.song.isBought
            ? AppBouncingButton(
                onTap: () {
                  ///SHOW DOWNLOAD STARTED MESSAGE
                  ScaffoldMessenger.of(context).showSnackBar(
                    buildAppSnackBar(
                      bgColor: ColorMapper.getBlack().withOpacity(0.9),
                      isFloating: true,
                      msg: AppLocale.of().downloadStartedMsg,
                      txtColor: ColorMapper.getWhite(),
                    ),
                  );

                  EasyDebounce.debounce(
                    'DOWNLOAD_BUTTON',
                    Duration(milliseconds: 0),
                    () {
                      BlocProvider.of<DownloadingSongBloc>(context).add(
                        DownloadSongEvent(
                          song: widget.song,
                          notificationTitle: AppLocale.of().downloading(
                            songName: L10nUtil.translateLocale(
                              widget.song.songName,
                              context,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(AppPadding.padding_8),
                  child: Icon(
                    FlutterRemix.arrow_down_circle_line,
                    color: widget.downloadingColor,
                    size: widget.isForPlayerPage
                        ? AppIconSizes.icon_size_28
                        : AppIconSizes.icon_size_24,
                  ),
                ),
              )
            : SizedBox());
  }

  void showInitialStatus(DownloadTaskStatus downloadTaskStatus) async {
    if (downloadTaskStatus == DownloadTaskStatus.running ||
        downloadTaskStatus == DownloadTaskStatus.enqueued) {
      showDownloading = true;
      showDownloaded = false;
      showDownloadFailed = false;
      showEmpty = false;
    } else if (downloadTaskStatus == DownloadTaskStatus.complete) {
      showDownloading = false;
      showDownloaded = true;
      showDownloadFailed = false;
      showEmpty = false;
    } else if (downloadTaskStatus == DownloadTaskStatus.failed) {
      showDownloading = false;
      showDownloaded = false;
      showDownloadFailed = true;
      showEmpty = false;
    } else {
      showDownloading = false;
      showDownloaded = false;
      showDownloadFailed = false;
      showEmpty = true;
    }
  }
}
