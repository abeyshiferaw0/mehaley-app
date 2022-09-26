import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/data_providers/settings_data_provider.dart';
import 'package:mehaley/data/models/audio_file.dart';
import 'package:mehaley/data/models/payment/iap_product.dart';
import 'package:mehaley/data/models/remote_image.dart';
import 'package:mehaley/data/models/sync/song_sync.dart';
import 'package:mehaley/data/models/text_lan.dart';
import 'package:mehaley/util/download_util.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:uuid/uuid.dart';

part 'song.g.dart';

@HiveType(typeId: 7)
class Song extends Equatable {
  @HiveField(0)
  final int songId;
  @HiveField(1)
  final TextLan songName;
  @HiveField(2)
  final RemoteImage albumArt;
  @HiveField(3)
  final AudioFile audioFile;
  @HiveField(4)
  final List<TextLan> artistsName;
  @HiveField(5)
  final bool lyricIncluded;
  @HiveField(6)
  final double priceEtb;
  @HiveField(7)
  final IapProduct priceDollar;
  @HiveField(8)
  final bool isFree;
  @HiveField(9)
  final bool isBought;
  @HiveField(10)
  final bool isDiscountAvailable;
  @HiveField(12)
  final double discountPercentage;
  @HiveField(13)
  final bool isOnlyOnElf;
  @HiveField(14)
  final String performedBy;
  @HiveField(15)
  final String writtenByText;
  @HiveField(16)
  final String producedBy;
  @HiveField(17)
  final String source;
  @HiveField(18)
  final String? youtubeUrl;
  @HiveField(19)
  final bool isLiked;
  @HiveField(20)
  final DateTime releasedDate;
  @HiveField(21)
  final DateTime songCreatedDate;
  @HiveField(22)
  final DateTime songUpdatedDated;

  const Song({
    required this.isBought,
    required this.isDiscountAvailable,
    required this.discountPercentage,
    required this.songId,
    required this.songName,
    //required this.songBgVideo,
    required this.albumArt,
    required this.audioFile,
    required this.artistsName,
    required this.lyricIncluded,
    required this.priceEtb,
    required this.priceDollar,
    required this.isFree,
    required this.isOnlyOnElf,
    required this.performedBy,
    required this.writtenByText,
    required this.producedBy,
    required this.source,
    required this.isLiked,
    required this.youtubeUrl,
    required this.releasedDate,
    required this.songCreatedDate,
    required this.songUpdatedDated,
  });

  @override
  List<Object?> get props => [
        songId,
        songName,
        isBought,
        //songBgVideo,
        albumArt,
        audioFile,
        artistsName,
        lyricIncluded,
        priceEtb,
        priceDollar,
        isFree,
        isDiscountAvailable,
        discountPercentage,
        isOnlyOnElf,
        performedBy,
        writtenByText,
        producedBy,
        source,
        youtubeUrl,
        isLiked,
        releasedDate,
        songCreatedDate,
        songUpdatedDated,
      ];

  factory Song.fromMap(Map<String, dynamic> map) {
    return new Song(
      songId: map['song_id'] as int,
      songName: TextLan.fromMap(map['song_name_text_id']),
      //songBgVideo: BgVideo.fromMap(map['song_bg_video_id']),
      albumArt: RemoteImage.fromMap(map['album_art_id']),
      audioFile: AudioFile.fromMap(map['audio_file_id']),
      artistsName: (map['artists'] as List)
          .map((name) => TextLan.fromMap(name['artist_name_text_id']))
          .toList(),
      lyricIncluded: map['lyric_included'] == 1 ? true : false,
      priceEtb: map['price_etb'] as double,
      priceDollar: IapProduct.fromJson(map['price_dollar']),
      isFree: map['is_free'] == 1 ? true : false,
      isBought: map['is_bought'] == 1 ? true : false,
      isOnlyOnElf: map['is_only_on_elf'] == 1 ? true : false,
      performedBy: map['performed_by'] as String,
      writtenByText: map['written_by_text'] as String,
      producedBy: map['produced_by'] as String,
      source: map['source'] as String,
      youtubeUrl:
          map['youtube_url'] != null ? map['youtube_url'] as String : null,
      isLiked: map['is_liked'] == 1 ? true : false,
      releasedDate: DateTime.parse(map['released_date']),
      songCreatedDate: DateTime.parse(map['song_created_date']),
      songUpdatedDated: DateTime.parse(map['song_updated_dated']),
      isDiscountAvailable: map['is_discount_available'] == 1 ? true : false,
      discountPercentage: map['discount_percentage'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'song_id': this.songId,
      'song_name_text_id': this.songName.toMap(),
      //'song_bg_video_id': this.songBgVideo,
      'album_art_id': this.albumArt.toMap(),
      'audio_file_id': this.audioFile.toMap(),
      'artists': getTextLanListMap(this.artistsName),
      'lyric_included': this.lyricIncluded ? 1 : 0,
      'price_etb': this.priceEtb,
      'price_dollar': this.priceDollar.toJson(),
      'is_free': this.isFree ? 1 : 0,
      'is_bought': this.isBought ? 1 : 0,
      'is_only_on_elf': this.isOnlyOnElf ? 1 : 0,
      'performed_by': this.performedBy,
      'written_by_text': this.writtenByText,
      'produced_by': this.producedBy,
      'source': this.source,
      'youtube_url': this.youtubeUrl,
      'is_liked': this.isLiked ? 1 : 0,
      'released_date': this.releasedDate.toString(),
      'song_created_date': this.songCreatedDate.toString(),
      'song_updated_dated': this.songUpdatedDated.toString(),
      'is_discount_available': this.isDiscountAvailable ? 1 : 0,
      'discount_percentage': this.discountPercentage,
    };
  }

  Song copyWith({
    int? songI,
    TextLan? songName,
    RemoteImage? albumArt,
    AudioFile? audioFile,
    List<TextLan>? artistsName,
    bool? lyricIncluded,
    double? priceEtb,
    IapProduct? priceDollar,
    bool? isFree,
    bool? isBought,
    bool? isDiscountAvailable,
    double? discountPercentage,
    bool? isOnlyOnElf,
    String? performedBy,
    String? writtenByText,
    String? producedBy,
    String? source,
    String? youtubeUrl,
    bool? isLiked,
    DateTime? releasedDate,
    DateTime? songCreatedDate,
    DateTime? songUpdatedDated,
  }) {
    return Song(
      isBought: isBought ?? this.isBought,
      isDiscountAvailable: isDiscountAvailable ?? this.isDiscountAvailable,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      songId: songI ?? this.songId,
      songName: songName ?? this.songName,
      albumArt: albumArt ?? this.albumArt,
      audioFile: audioFile ?? this.audioFile,
      artistsName: artistsName ?? this.artistsName,
      lyricIncluded: lyricIncluded ?? this.lyricIncluded,
      priceEtb: priceEtb ?? this.priceEtb,
      priceDollar: priceDollar ?? this.priceDollar,
      isFree: isFree ?? this.isFree,
      isOnlyOnElf: isOnlyOnElf ?? this.isOnlyOnElf,
      performedBy: performedBy ?? this.performedBy,
      writtenByText: writtenByText ?? this.writtenByText,
      producedBy: producedBy ?? this.producedBy,
      source: source ?? this.source,
      isLiked: isLiked ?? this.isLiked,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      releasedDate: releasedDate ?? this.releasedDate,
      songCreatedDate: songCreatedDate ?? this.songCreatedDate,
      songUpdatedDated: songUpdatedDated ?? this.songUpdatedDated,
    );
  }

  dynamic getTextLanListMap(List<TextLan> items) {
    List<Map<String, dynamic>> mapItems = [];
    items.forEach((element) {
      mapItems.add({'artist_name_text_id': element.toMap()});
    });
    return mapItems;
  }

  static Future<List<AudioSource>> toListAudioSourceStreamUri(
    DownloadUtil downloadUtil,
    List<Song> songs,
    PlayingFrom playingFrom,
    BuildContext context,
    SettingsDataProvider settingsDataProvider,
  ) async {
    List<AudioSource> audioSources = [];

    ///IS USER SUBSCRIBED
    final bool isUserSubscribed = PagesUtilFunctions.isUserSubscribed();

    ///GET ALL DOWNLOADS SONGS AND TASKS
    List<DownloadedTaskWithSong> allDownloads =
        await downloadUtil.getAllDownloadedSongs();

    for (var song in songs) {
      ///CHECK IF DOWNLOADED
      DownloadedTaskWithSong? downloadedTaskWithSong =
          downloadUtil.isSongDownloaded(song, allDownloads);

      ///GENERATE SONG SYNC OBJECT
      var uuid = Uuid();
      SongSync songSync = SongSync(
        songId: song.songId,
        uuid: uuid.v5(
          Uuid.NAMESPACE_NIL,
          "${DateTime.now().toString()}_${song.songId}",
        ),
        playedFrom: playingFrom.songSyncPlayedFrom,
        playedFromId: playingFrom.songSyncPlayedFromId,
        isPreview: song.isFree
            ? false
            : song.isBought
                ? false
                : isUserSubscribed
                    ? false
                    : true,
        isPurchased: song.isBought,
        isOffline: downloadedTaskWithSong != null ? true : false,
        listenDate: DateFormat("yyyy/MM/dd HH:mm:ss").format(DateTime.now()),
        secondsPlayed: null,
        isUserSubscribed: isUserSubscribed,
        isLocalSubscription: getIsUserLocalSubscribed(),
      );

      if (downloadedTaskWithSong == null) {
        ///SONG IS NOT DOWNLOADED
        ClippingAudioSource clippingAudioSource;

        ///TAG MEDIA
        MediaItem tag = MediaItem(
          id: song.songId.toString(),
          title: L10nUtil.translateLocale(song.songName, context),
          artist: PagesUtilFunctions.getArtistsNames(song.artistsName, context),
          duration: Duration(
            seconds: song.audioFile.audioDurationSeconds.toInt(),
          ),
          artUri: Uri.parse(song.albumArt.imageLargePath),
          extras: {
            AppValues.songExtraStr: song.toMap(),
            AppValues.songSyncExtraStr: songSync.toMap(),
          },
        );

        HlsAudioSource hlsAudioSource = HlsAudioSource(
          Uri.parse(
            (settingsDataProvider.isDataSaverTurnedOn()
                ? song.audioFile.audio64KpsStreamPath
                : song.audioFile.audio96KpsStreamPath),
          ),
          tag: tag,
        );

        ///CHECK IF SONG BOUGHT
        if (PagesUtilFunctions.isNotFreeBoughtAndSubscribed(song)) {
          ///CLIP IF NOT BOUGHT OR NOT SUBSCRIBED OR NOT FREE
          clippingAudioSource = ClippingAudioSource(
            child: hlsAudioSource,
            tag: tag,
            start: song.audioFile.audioPreviewStartTime,
            end: Duration(
              seconds: (song.audioFile.audioPreviewDurationSeconds.toInt() +
                      song.audioFile.audioPreviewStartTime.inSeconds) +
                  2,
            ),
          );
          audioSources.add(
            clippingAudioSource,
          );
        } else {
          audioSources.add(hlsAudioSource);
        }
      } else {
        Uri t = Uri.file(
            "${downloadedTaskWithSong.task.savedDir}/${downloadedTaskWithSong.task.filename}");
        File f = File.fromUri(t);

        print("Uri.file=> ${f.existsSync()}");
        print(
            "Uri.file=> ${Uri.file("${downloadedTaskWithSong.task.savedDir}${Platform.pathSeparator}${downloadedTaskWithSong.task.filename}")}");

        ///SONG IS DOWNLOADED
        AudioSource audioSource = AudioSource.uri(
          Uri.file(
              "${downloadedTaskWithSong.task.savedDir}${Platform.pathSeparator}${downloadedTaskWithSong.task.filename}"),
          tag: MediaItem(
            id: song.songId.toString(),
            title: L10nUtil.translateLocale(song.songName, context),
            artist:
                PagesUtilFunctions.getArtistsNames(song.artistsName, context),
            duration: Duration(
              seconds: song.audioFile.audioDurationSeconds.toInt(),
            ),
            artUri: Uri.parse(song.albumArt.imageLargePath),
            extras: {
              AppValues.songExtraStr: song.toMap(),
              AppValues.songSyncExtraStr: songSync.toMap(),
            },
          ),
        );
        audioSources.add(audioSource);
      }
    }
    return audioSources;
  }

  // static Future<AudioSource> toAudioSourceStreamUri(
  //   DownloadUtil downloadUtil,
  //   Song song,
  //   PlayingFrom playingFrom,
  //   BuildContext context,
  //   SettingsDataProvider settingsDataProvider,
  // ) async {
  //   ///IS USER SUBSCRIBED
  //   final bool isUserSubscribed = PagesUtilFunctions.isUserSubscribed();
  //
  //   ///GET ALL DOWNLOADS SONGS AND TASKS
  //   List<DownloadedTaskWithSong> allDownloads =
  //       await downloadUtil.getAllDownloadedSongs();
  //
  //   ///CHECK IF DOWNLOADED
  //   DownloadedTaskWithSong? downloadedTaskWithSong =
  //       downloadUtil.isSongDownloaded(song, allDownloads);
  //
  //   ///GENERATE SONG SYNC OBJECT
  //   var uuid = Uuid();
  //   SongSync songSync = SongSync(
  //     songId: song.songId,
  //     uuid: uuid.v5(
  //       Uuid.NAMESPACE_NIL,
  //       "${DateTime.now().toString()}_${song.songId}",
  //     ),
  //     playedFrom: playingFrom.songSyncPlayedFrom,
  //     playedFromId: playingFrom.songSyncPlayedFromId,
  //     isPreview: song.isFree
  //         ? false
  //         : song.isBought
  //             ? false
  //             : isUserSubscribed
  //                 ? false
  //                 : true,
  //     isOffline: downloadedTaskWithSong != null ? true : false,
  //     listenDate: DateFormat("yyyy/MM/dd HH:mm:ss").format(DateTime.now()),
  //     secondsPlayed: null,
  //     isUserSubscribed: isUserSubscribed,
  //   );
  //
  //   if (downloadedTaskWithSong == null) {
  //     ///SONG IS NOT DOWNLOADED
  //     ClippingAudioSource clippingAudioSource;
  //
  //     ///TAG MEDIA
  //     MediaItem tag = MediaItem(
  //       id: song.songId.toString(),
  //       title: L10nUtil.translateLocale(song.songName, context),
  //       artist: PagesUtilFunctions.getArtistsNames(song.artistsName, context),
  //       duration: Duration(
  //         seconds: song.audioFile.audioDurationSeconds.toInt(),
  //       ),
  //       artUri: Uri.parse(song.albumArt.imageLargePath),
  //       extras: {
  //         AppValues.songExtraStr: song.toMap(),
  //         AppValues.songSyncExtraStr: songSync.toMap(),
  //       },
  //     );
  //
  //     ///CHECK IF SONG BOUGHT
  //     HlsAudioSource hlsAudioSource = HlsAudioSource(
  //       Uri.parse(
  //         (settingsDataProvider.isDataSaverTurnedOn()
  //             ? song.audioFile.audio64KpsStreamPath
  //             : song.audioFile.audio96KpsStreamPath),
  //       ),
  //       tag: tag,
  //     );
  //
  //     if (!song.isBought && !song.isFree && !isUserSubscribed) {
  //       ///CLIP IF NOT BOUGHT OR NOT SUBSCRIBED OR NOT FREE
  //       clippingAudioSource = ClippingAudioSource(
  //         child: hlsAudioSource,
  //         tag: tag,
  //         start: song.audioFile.audioPreviewStartTime,
  //         end: Duration(
  //           seconds: (song.audioFile.audioPreviewDurationSeconds.toInt() +
  //                   song.audioFile.audioPreviewStartTime.inSeconds) +
  //               2,
  //         ),
  //       );
  //       return clippingAudioSource;
  //     } else {
  //       return hlsAudioSource;
  //     }
  //   } else {
  //     ///SONG IS DOWNLOADED
  //     AudioSource audioSource = AudioSource.uri(
  //       Uri.file(
  //           "${downloadedTaskWithSong.task.savedDir}${downloadedTaskWithSong.task.filename}"),
  //       tag: MediaItem(
  //         id: song.songId.toString(),
  //         title: L10nUtil.translateLocale(song.songName, context),
  //         artist: PagesUtilFunctions.getArtistsNames(song.artistsName, context),
  //         duration: Duration(
  //           seconds: song.audioFile.audioDurationSeconds.toInt(),
  //         ),
  //         artUri: Uri.parse(song.albumArt.imageLargePath),
  //         extras: {
  //           AppValues.songExtraStr: song.toMap(),
  //           AppValues.songSyncExtraStr: songSync.toMap(),
  //         },
  //       ),
  //     );
  //     return audioSource;
  //   }
  // }

  static String toBase64Str(Song song) {
    ///CONVERT JSON TO STRING
    String str = json.encode(song.toMap());
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(str);
    return encoded;
  }

  static Song fromBase64(String song) {
    ///CONVERT JSON TO STRING
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String decode = stringToBase64.decode(song);
    return Song.fromMap(json.decode(decode));
  }

  static getIsUserLocalSubscribed() {
    return PagesUtilFunctions.isUserLocalSubscribed();
  }
}
