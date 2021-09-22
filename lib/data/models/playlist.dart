import 'package:elf_play/data/models/enums/playlist_created_by.dart';
import 'package:elf_play/data/models/remote_image.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/data/models/text_lan.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'playlist.g.dart';

@HiveType(typeId: 5)
class Playlist extends Equatable {
  @HiveField(0)
  final int playlistId;
  @HiveField(1)
  final TextLan playlistNameText;
  @HiveField(2)
  final TextLan playlistDescriptionText;
  @HiveField(3)
  final RemoteImage playlistImage;
  @HiveField(4)
  final bool isVerified;
  @HiveField(5)
  final bool isFeatured;
  @HiveField(6)
  final double priceEtb;
  @HiveField(7)
  final double priceDollar;
  @HiveField(8)
  final bool isFree;
  @HiveField(9)
  final bool isForSale;
  @HiveField(10)
  final bool isDiscountAvailable;
  @HiveField(11)
  final double discountPercentage;
  @HiveField(12)
  final PlaylistCreatedBy createdBy;
  @HiveField(13)
  final String createdById;
  @HiveField(14)
  final bool? isFollowed;
  @HiveField(15)
  final DateTime playlistDateCreated;
  @HiveField(16)
  final DateTime playlistDateUpdated;
  @HiveField(17)
  final List<Song>? songs;

  const Playlist({
    required this.songs,
    required this.playlistId,
    required this.playlistNameText,
    required this.playlistDescriptionText,
    required this.playlistImage,
    required this.isVerified,
    required this.isFeatured,
    required this.priceEtb,
    required this.priceDollar,
    required this.isForSale,
    required this.isFree,
    required this.isDiscountAvailable,
    required this.discountPercentage,
    required this.createdBy,
    required this.createdById,
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
        isVerified,
        priceEtb,
        priceDollar,
        isFree,
        isForSale,
        isDiscountAvailable,
        discountPercentage,
        isFeatured,
        createdBy,
        createdById,
        isFollowed,
        playlistDateCreated,
        playlistDateUpdated,
        songs,
      ];

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return new Playlist(
      playlistId: map['playlist_id'] as int,
      playlistNameText: TextLan.fromMap(
        map['playlist_name_text_id'],
      ),
      playlistDescriptionText: TextLan.fromMap(
        map['playlist_description_text_id'],
      ),
      playlistImage: RemoteImage.fromMap(
        map['playlist_image_id'],
      ),
      songs: map['songs'] != null
          ? (map['songs'] as List).map((song) => Song.fromMap(song)).toList()
          : null,
      priceEtb: map['price_etb'] as double,
      priceDollar: map['price_dollar'] as double,
      isFree: map['is_free'] == 1 ? true : false,
      isForSale: map['is_for_sale'] == 1 ? true : false,
      isDiscountAvailable: map['is_discount_available'] == 1 ? true : false,
      discountPercentage: map['discount_percentage'] as double,
      isVerified: map['is_verified'] == 1 ? true : false,
      isFeatured: map['is_featured'] == 1 ? true : false,
      isFollowed: map['is_followed'] != null
          ? (map['is_followed'] == 1 ? true : false)
          : null,
      createdBy: EnumToString.fromString(
        PlaylistCreatedBy.values,
        map['created_by'],
      ) as PlaylistCreatedBy,
      createdById: map['created_by_id'] as String,
      playlistDateCreated: DateTime.parse(
        map['playlist_date_created'],
      ),
      playlistDateUpdated: DateTime.parse(
        map['playlist_date_updated'],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'playlist_id': this.playlistId,
      'playlist_name_text': this.playlistNameText,
      'playlist_description_text': this.playlistDescriptionText,
      'playlist_image': this.playlistImage,
      'is_verified': this.isVerified,
      'is_featured': this.isFeatured,
      'created_by': this.createdBy,
      'price_etb': this.priceEtb,
      'price_dollar': this.priceDollar,
      'is_for_sale': this.isForSale,
      'is_free': this.isFree,
      'is_discount_available': this.isDiscountAvailable,
      'discount_percentage': this.discountPercentage,
      'created_by_id': this.createdById,
      'is_followed': this.isFollowed,
      'playlist_date_created': this.playlistDateCreated,
      'playlist_date_updated': this.playlistDateUpdated,
    } as Map<String, dynamic>;
  }
}
