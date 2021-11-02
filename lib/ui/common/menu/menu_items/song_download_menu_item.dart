import 'package:easy_debounce/easy_debounce.dart';
import 'package:elf_play/business_logic/blocs/downloading_song_bloc/downloading_song_bloc.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/ui/common/dialog/dialog_delete_song.dart';
import 'package:elf_play/ui/common/dialog/dialog_song_preview_mode.dart';
import 'package:elf_play/ui/common/menu/menu_items/menu_item.dart';
import 'package:elf_play/util/download_util.dart';
import 'package:elf_play/util/l10n_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class SongDownloadMenuItem extends StatefulWidget {
  SongDownloadMenuItem({
    Key? key,
    required this.song,
  }) : super(key: key);

  final Song song;

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
          hasTopMargin: false,
          iconColor: AppColors.green,
          icon: PhosphorIcons.arrow_circle_down_fill,
          title: AppLocalizations.of(context)!.deleteMezmur,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return Center(
                  child: DialogDeleteSong(
                    mainButtonText: 'DELETE'.toUpperCase(),
                    cancelButtonText: 'CANCEL',
                    titleText:
                        'Are you sure you want to Delete ${L10nUtil.translateLocale(widget.song.songName, context)} from downloads?',
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
        hasTopMargin: false,
        iconColor: AppColors.yellow,
        icon: PhosphorIcons.warning_fill,
        title: AppLocalizations.of(context)!.retryDownload,
        onTap: () {
          EasyDebounce.debounce("DOWNLOAD_BUTTON", Duration(milliseconds: 300),
              () {
            BlocProvider.of<DownloadingSongBloc>(context).add(
              RetryDownloadSongEvent(
                song: widget.song,
                notificationTitle:
                    "Downloading ${L10nUtil.translateLocale(widget.song.songName, context)}",
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
        hasTopMargin: false,
        iconColor: AppColors.errorRed,
        icon: PhosphorIcons.warning_fill,
        hasLeadingWidget: true,
        leadingWidget: Container(
          width: AppIconSizes.icon_size_24,
          height: AppIconSizes.icon_size_24,
          child: CircularProgressIndicator(
            color: AppColors.green,
            strokeWidth: 2,
          ),
        ),
        title: AppLocalizations.of(context)!.downloading,
        onTap: () {},
      ),
    );
  }

  Visibility buildSongNotDownloaded() {
    return Visibility(
      visible: showEmpty,
      child: MenuItem(
        isDisabled: false,
        hasTopMargin: false,
        iconColor: AppColors.grey.withOpacity(0.6),
        icon: PhosphorIcons.arrow_circle_down,
        title: AppLocalizations.of(context)!.downloadMezmur,
        onTap: () {
          if (widget.song.isBought || widget.song.isFree) {
            EasyDebounce.debounce(
                "DOWNLOAD_BUTTON", Duration(milliseconds: 300), () {
              BlocProvider.of<DownloadingSongBloc>(context).add(
                DownloadSongEvent(
                  song: widget.song,
                  notificationTitle:
                      "Downloading ${L10nUtil.translateLocale(widget.song.songName, context)}",
                ),
              );
            });
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
