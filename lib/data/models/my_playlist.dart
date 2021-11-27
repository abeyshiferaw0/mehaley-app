import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:mehaley/data/models/remote_image.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/models/text_lan.dart';

part 'my_playlist.g.dart';

@HiveType(typeId: 13)
class MyPlaylist extends Equatable {
  @HiveField(0)
  final int playlistId;
  @HiveField(1)
  final TextLan playlistNameText;
  @HiveField(2)
  final TextLan playlistDescriptionText;
  @HiveField(3)
  final RemoteImage? playlistImage;
  @HiveField(4)
  final List<RemoteImage> gridSongImages;
  @HiveField(5)
  final bool isVerified;
  @HiveField(6)
  final bool isFeatured;
  @HiveField(7)
  final double priceEtb;
  @HiveField(8)
  final double priceDollar;
  @HiveField(9)
  final bool isFree;
  @HiveField(10)
  final bool isDiscountAvailable;
  @HiveField(11)
  final double discountPercentage;
  @HiveField(12)
  final bool? isFollowed;
  @HiveField(13)
  final DateTime playlistDateCreated;
  @HiveField(14)
  final DateTime playlistDateUpdated;
  @HiveField(15)
  final List<Song>? songs;
  @HiveField(16)
  final int numberOfSongs;

  const MyPlaylist({
    required this.numberOfSongs,
    required this.gridSongImages,
    required this.songs,
    required this.playlistId,
    required this.playlistNameText,
    required this.playlistDescriptionText,
    required this.playlistImage,
    required this.isVerified,
    required this.isFeatured,
    required this.priceEtb,
    required this.priceDollar,
    required this.isFree,
    required this.isDiscountAvailable,
    required this.discountPercentage,
    required this.isFollowed,
    required this.playlistDateCreated,
    required this.playlistDateUpdated,
  });

  @override
  List<Object?> get props => [
        playlistId,
        playlistNameText,
        playlistDescriptionText,
        playlistImage,
        gridSongImages,
        isVerified,
        priceEtb,
        priceDollar,
        isFree,
        isDiscountAvailable,
        discountPercentage,
        isFeatured,
        isFollowed,
        playlistDateCreated,
        playlistDateUpdated,
        songs,
        numberOfSongs,
      ];

  factory MyPlaylist.fromMap(Map<String, dynamic> map) {
    return new MyPlaylist(
      playlistId: map['playlist_id'] as int,
      playlistNameText: TextLan.fromMap(
        map['playlist_name_text_id'],
      ),
      playlistDescriptionText: TextLan.fromMap(
        map['playlist_description_text_id'],
      ),
      playlistImage: map['playlist_image_id'] != null
          ? RemoteImage.fromMap(
              map['playlist_image_id'],
            )
          : null,
      gridSongImages: (map['grid_song_images'] as List)
          .map((remoteImage) =>
              RemoteImage.fromMap(remoteImage['song']['album_art_id']))
          .toList(),
      songs: map['songs'] != null
          ? (map['songs'] as List).map((song) => Song.fromMap(song)).toList()
          : null,
      priceEtb: map['price_etb'] as double,
      priceDollar: map['price_dollar'] as double,
      isFree: map['is_free'] == 1 ? true : false,
      isDiscountAvailable: map['is_discount_available'] == 1 ? true : false,
      discountPercentage: map['discount_percentage'] as double,
      isVerified: map['is_verified'] == 1 ? true : false,
      isFeatured: map['is_featured'] == 1 ? true : false,
      isFollowed: map['is_followed'] != null
          ? (map['is_followed'] == 1 ? true : false)
          : null,
      playlistDateCreated: DateTime.parse(
        map['playlist_date_created'],
      ),
      playlistDateUpdated: DateTime.parse(
        map['playlist_date_updated'],
      ),
      numberOfSongs: map['number_of_songs'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'playlist_id': this.playlistId,
      'playlist_name_text': this.playlistNameText,
      'playlist_description_text': this.playlistDescriptionText,
      'playlist_image': this.playlistImage,
      'playlist_placeholder_image_id': this.gridSongImages,
      'is_verified': this.isVerified,
      'is_featured': this.isFeatured,
      'price_etb': this.priceEtb,
      'price_dollar': this.priceDollar,
      'is_free': this.isFree,
      'is_discount_available': this.isDiscountAvailable,
      'discount_percentage': this.discountPercentage,
      'is_followed': this.isFollowed,
      'playlist_date_created': this.playlistDateCreated,
      'playlist_date_updated': this.playlistDateUpdated,
      'number_of_songs': this.numberOfSongs,
    } as Map<String, dynamic>;
  }
}
