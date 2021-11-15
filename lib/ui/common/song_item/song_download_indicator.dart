import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/downloading_song_bloc/downloading_song_bloc.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/dialog/dialog_delete_song.dart';
import 'package:mehaley/util/download_util.dart';
import 'package:mehaley/util/l10n_util.dart';

class SongDownloadIndicator extends StatefulWidget {
  SongDownloadIndicator({
    Key? key,
    required this.song,
    required this.isForPlayerPage,
  }) : super(key: key);

  final Song song;
  final bool isForPlayerPage;

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
          buildSizedBox(),
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
          child: Icon(
            PhosphorIcons.arrow_circle_down_fill,
            color: AppColors.orange,
            size: widget.isForPlayerPage
                ? AppIconSizes.icon_size_28
                : AppIconSizes.icon_size_24,
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
            Duration(milliseconds: 300),
            () {
              BlocProvider.of<DownloadingSongBloc>(context).add(
                RetryDownloadSongEvent(
                  song: widget.song,
                  notificationTitle: AppLocale.of().downloading(
                    songName:
                        L10nUtil.translateLocale(widget.song.songName, context),
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
          child: Icon(
            PhosphorIcons.warning_fill,
            color: AppColors.yellow,
            size: widget.isForPlayerPage
                ? AppIconSizes.icon_size_24
                : AppIconSizes.icon_size_20,
          ),
        ),
      ),
    );
  }

  Visibility buildDownloadingIndicator() {
    return Visibility(
      visible: showDownloading,
      child: Container(
        width: widget.isForPlayerPage
            ? AppIconSizes.icon_size_24
            : AppIconSizes.icon_size_16,
        height: widget.isForPlayerPage
            ? AppIconSizes.icon_size_24
            : AppIconSizes.icon_size_16,
        margin: EdgeInsets.all(AppPadding.padding_8),
        child: CircularProgressIndicator(
          color: AppColors.orange,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Visibility buildSizedBox() {
    return Visibility(
        visible: showEmpty,
        child: widget.song.isBought
            ? AppBouncingButton(
                onTap: () {
                  EasyDebounce.debounce(
                    'DOWNLOAD_BUTTON',
                    Duration(milliseconds: 300),
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
                    PhosphorIcons.arrow_circle_down_light,
                    color: AppColors.darkGrey,
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
