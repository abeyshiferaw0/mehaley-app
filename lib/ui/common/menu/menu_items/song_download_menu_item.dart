import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/downloading_song_bloc/downloading_song_bloc.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/common/dialog/dialog_delete_song.dart';
import 'package:mehaley/ui/common/dialog/dialog_song_preview_mode.dart';
import 'package:mehaley/ui/common/menu/menu_items/menu_item.dart';
import 'package:mehaley/util/download_util.dart';
import 'package:mehaley/util/l10n_util.dart';

class SongDownloadMenuItem extends StatefulWidget {
  SongDownloadMenuItem({
    Key? key,
    required this.song,
    required this.downloadingColor,
    required this.downloadedColor,
    required this.downloadingFailedColor,
  }) : super(key: key);

  final Song song;
  final Color downloadingColor;
  final Color downloadedColor;
  final Color downloadingFailedColor;

  @override
  _SongDownloadMenuItemState createState() => _SongDownloadMenuItemState();
}

class _SongDownloadMenuItemState extends State<SongDownloadMenuItem> {
  final DownloadUtil downloadUtil = DownloadUtil();

  ///
  bool showDownloading = false;

  bool showDownloaded = false;

  bool showDownloadFailed = false;

  bool showEmpty = false;

  @override
  void initState() {
    BlocProvider.of<DownloadingSongBloc>(context).add(
      IsSongDownloadedEvent(
        song: widget.song,
      ),
    );
    if (widget.song.isBought || widget.song.isFree) {
      showEmpty = true;
    }
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
          buildSongNotDownloaded(),
        ],
      ),
    );
  }

  Visibility buildSongDownloadedButton(context) {
    return Visibility(
        visible: showDownloaded,
        child: MenuItem(
          isDisabled: false,
          hasTopMargin: true,
          iconColor: widget.downloadedColor,
          icon: FlutterRemix.arrow_down_circle_fill,
          title: AppLocale.of().deleteMezmur,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return Center(
                  child: DialogDeleteSong(
                    mainButtonText: AppLocale.of().delete.toUpperCase(),
                    cancelButtonText: AppLocale.of().cancel.toUpperCase(),
                    titleText:
                        AppLocale.of().areUSureYouWantToDeleteFromDownloads(
                      songName: L10nUtil.translateLocale(
                        widget.song.songName,
                        context,
                      ),
                    ),
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
        ));
  }

  Visibility buildSongDownloadFailedButton(context) {
    return Visibility(
      visible: showDownloadFailed,
      child: MenuItem(
        isDisabled: false,
        hasTopMargin: true,
        iconColor: widget.downloadingFailedColor,
        icon: FlutterRemix.error_warning_fill,
        title: AppLocale.of().retryDownload,
        onTap: () {
          EasyDebounce.debounce('DOWNLOAD_BUTTON', Duration(milliseconds: 0),
              () {
            ///SHOW RETRYING MESSAGE
            ScaffoldMessenger.of(context).showSnackBar(
              buildAppSnackBar(
                bgColor: AppColors.black.withOpacity(0.9),
                isFloating: true,
                msg: AppLocale.of().retryingDownloadMsg,
                txtColor: AppColors.white,
              ),
            );

            BlocProvider.of<DownloadingSongBloc>(context).add(
              RetryDownloadSongEvent(
                song: widget.song,
                notificationTitle: AppLocale.of().downloading(
                  songName:
                      L10nUtil.translateLocale(widget.song.songName, context),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Visibility buildDownloadingIndicator() {
    return Visibility(
      visible: showDownloading,
      child: MenuItem(
        isDisabled: false,
        hasTopMargin: true,
        iconColor: AppColors.errorRed,
        icon: FlutterRemix.error_warning_fill,
        hasLeadingWidget: true,
        leadingWidget: Container(
          width: AppIconSizes.icon_size_24,
          height: AppIconSizes.icon_size_24,
          child: CircularProgressIndicator(
            color: widget.downloadingColor,
            strokeWidth: 2,
          ),
        ),
        title: AppLocale.of().downloadProgressing,
        onTap: () {},
      ),
    );
  }

  Visibility buildSongNotDownloaded() {
    return Visibility(
      visible: showEmpty,
      child: MenuItem(
        isDisabled: false,
        hasTopMargin: true,
        iconColor: AppColors.grey.withOpacity(0.6),
        icon: FlutterRemix.arrow_down_circle_line,
        title: AppLocale.of().downloadMezmur,
        onTap: () {
          if (widget.song.isBought || widget.song.isFree) {
            ///SHOW DOWNLOAD STARTED MESSAGE
            ScaffoldMessenger.of(context).showSnackBar(
              buildAppSnackBar(
                bgColor: AppColors.black.withOpacity(0.9),
                isFloating: true,
                msg: AppLocale.of().downloadStartedMsg,
                txtColor: AppColors.white,
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
                          widget.song.songName, context),
                    ),
                  ),
                );
              },
            );
          } else {
            ///SHOW BUY OR PURCHASE DIALOG
            showDialog(
              context: context,
              builder: (context) {
                return Center(
                  child: DialogSongPreviewMode(
                    isForDownload: true,
                    isForPlaying: false,
                    song: widget.song,
                  ),
                );
              },
            );
          }
        },
      ),
    );
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
