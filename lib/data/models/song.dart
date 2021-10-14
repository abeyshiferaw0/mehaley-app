import 'dart:convert';

import 'package:elf_play/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/data/models/audio_file.dart';
import 'package:elf_play/data/models/remote_image.dart';
import 'package:elf_play/data/models/sync/song_sync.dart';
import 'package:elf_play/data/models/text_lan.dart';
import 'package:elf_play/util/download_util.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
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
  final double priceDollar;
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
  final bool isLiked;
  @HiveField(19)
  final bool isInCart;
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
    required this.isInCart,
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
        isLiked, isInCart,
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
      priceDollar: map['price_dollar'] as double,
      isFree: map['is_free'] == 1 ? true : false,
      isBought: map['is_bought'] == 1 ? true : false,
      isOnlyOnElf: map['is_only_on_elf'] == 1 ? true : false,
      performedBy: map['performed_by'] as String,
      writtenByText: map['written_by_text'] as String,
      producedBy: map['produced_by'] as String,
      source: map['source'] as String,
      isLiked: map['is_liked'] == 1 ? true : false,
      isInCart: map['is_in_cart'] == 1 ? true : false,
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
      'price_dollar': this.priceDollar,
      'is_free': this.isFree ? 1 : 0,
      'is_bought': this.isBought ? 1 : 0,
      'is_only_on_elf': this.isOnlyOnElf ? 1 : 0,
      'performed_by': this.performedBy,
      'written_by_text': this.writtenByText,
      'produced_by': this.producedBy,
      'source': this.source,
      'is_liked': this.isLiked ? 1 : 0,
      'is_in_cart': this.isInCart ? 1 : 0,
      'released_date': this.releasedDate.toString(),
      'song_created_date': this.songCreatedDate.toString(),
      'song_updated_dated': this.songUpdatedDated.toString(),
      'is_discount_available': this.isDiscountAvailable ? 1 : 0,
      'discount_percentage': this.discountPercentage,
    };
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
  ) async {
    List<AudioSource> audioSources = [];

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
        uuid: uuid.v5(
            Uuid.NAMESPACE_NIL, "${DateTime.now().toString()}_${song.songId}"),
        playedFrom: playingFrom.songSyncPlayedFrom,
        playedFromId: playingFrom.songSyncPlayedFromId,
        isPreview: song.isFree || song.isBought,
        listenDate: DateTime.now(),
        secondsPlayed: null,
      );

      if (downloadedTaskWithSong == null) {
        ///SONG IS NOT DOWNLOADED
        ClippingAudioSource clippingAudioSource;

        ///TAG MEDIA
        MediaItem tag = MediaItem(
          id: song.songId.toString(),
          title: song.songName.textAm,
          artist: PagesUtilFunctions.getArtistsNames(song.artistsName),
          duration: Duration(
            seconds: song.audioFile.audioDurationSeconds.toInt(),
          ),
          artUri: Uri.parse(AppApi.baseFileUrl + song.albumArt.imageSmallPath),
          extras: {
            AppValues.songExtraStr: song.toMap(),
            AppValues.songSyncExtraStr: songSync.toMap(),
          },
        );

        ///CHECK IF SONG BOUGHT
        HlsAudioSource hlsAudioSource = HlsAudioSource(
          Uri.parse(AppApi.baseFileUrl + song.audioFile.audio128KpsStreamPath),
          tag: tag,
        );
        print("song.isBought => ${song.isBought} ${song.isFree}");
        if (!song.isBought && !song.isFree) {
          ///CLIP IF NOT BOUGHT
          clippingAudioSource = ClippingAudioSource(
            child: hlsAudioSource,
            tag: tag,
            start: Duration(seconds: AppValues.playerPreviewStartSecond),
            end: Duration(
              seconds: song.audioFile.audioPreviewDurationSeconds.toInt() +
                  AppValues.playerPreviewStartSecond,
            ),
          );
          audioSources.add(clippingAudioSource);
        } else {
          audioSources.add(hlsAudioSource);
        }
      } else {
        ///SONG IS DOWNLOADED
        AudioSource audioSource = AudioSource.uri(
          Uri.file(
              "${downloadedTaskWithSong.task.savedDir}${downloadedTaskWithSong.task.filename}"),
          tag: MediaItem(
            id: song.songId.toString(),
            title: song.songName.textAm,
            artist: PagesUtilFunctions.getArtistsNames(song.artistsName),
            duration: Duration(
              seconds: song.audioFile.audioDurationSeconds.toInt(),
            ),
            artUri:
                Uri.parse(AppApi.baseFileUrl + song.albumArt.imageSmallPath),
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
}
