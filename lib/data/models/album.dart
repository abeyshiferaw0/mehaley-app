import 'package:elf_play/data/models/artist.dart';
import 'package:elf_play/data/models/remote_image.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/data/models/text_lan.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'album.g.dart';

@HiveType(typeId: 0)
class Album extends Equatable {
  @HiveField(0)
  final int albumId;
  @HiveField(1)
  final TextLan albumTitle;
  @HiveField(2)
  final TextLan albumDescription;
  @HiveField(3)
  final List<RemoteImage> albumImages;
  @HiveField(4)
  final List<Song>? songs;
  @HiveField(5)
  final Artist artist;
  @HiveField(6)
  final double priceEtb;
  @HiveField(7)
  final double priceDollar;
  @HiveField(8)
  final bool isFree;
  @HiveField(9)
  final bool isDiscountAvailable;
  @HiveField(10)
  final bool isBought;
  @HiveField(11)
  final double discountPercentage;
  @HiveField(12)
  final bool isOnlyOnElf;
  @HiveField(13)
  final bool isFeatured;
  @HiveField(14)
  final bool isLiked;
  @HiveField(15)
  final DateTime albumReleaseDate;
  @HiveField(16)
  final DateTime albumDateCreated;
  @HiveField(17)
  final DateTime albumDateUpdated;

  const Album({
    required this.isBought,
    required this.albumId,
    required this.albumTitle,
    required this.albumDescription,
    required this.albumImages,
    required this.songs,
    required this.artist,
    required this.priceEtb,
    required this.priceDollar,
    required this.isFree,
    required this.isDiscountAvailable,
    required this.discountPercentage,
    required this.isOnlyOnElf,
    required this.isFeatured,
    required this.isLiked,
    required this.albumReleaseDate,
    required this.albumDateCreated,
    required this.albumDateUpdated,
  });

  @override
  List<Object?> get props => [
        albumId,
        albumTitle,
        albumDescription,
        albumImages,
        songs,
        artist,
        priceEtb,
        priceDollar,
        isFree,
        isBought,
        isDiscountAvailable,
        discountPercentage,
        isOnlyOnElf,
        isFeatured,
        isLiked,
        albumReleaseDate,
        albumDateCreated,
        albumDateUpdated,
      ];

  factory Album.fromMap(Map<String, dynamic> map) {
    return new Album(
      albumId: map['album_id'] as int,
      albumTitle: TextLan.fromMap(map['album_title_text_id']),
      albumDescription: TextLan.fromMap(map['album_description_text_id']),
      albumImages: (map['album_images'] as List)
          .map((remoteImage) => RemoteImage.fromMap(remoteImage))
          .toList(),
      songs: map['songs'] != null
          ? (map['songs'] as List).map((song) => Song.fromMap(song)).toList()
          : null,
      artist: Artist.fromMap(map['artist_id']),
      priceEtb: map['price_etb'] as double,
      priceDollar: map['price_dollar'] as double,
      isFree: map['is_free'] == 1 ? true : false,
      isBought: map['is_bought'] == 1 ? true : false,
      isDiscountAvailable: map['is_discount_available'] == 1 ? true : false,
      discountPercentage: map['discount_percentage'] as double,
      isOnlyOnElf: map['is_only_on_elf'] == 1 ? true : false,
      isFeatured: map['is_featured'] == 1 ? true : false,
      isLiked: map['is_liked'] == 1 ? true : false,
      albumReleaseDate: DateTime.parse(map['album_release_date']),
      albumDateCreated: DateTime.parse(map['album_date_created']),
      albumDateUpdated: DateTime.parse(map['album_date_updated']),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'album_id': this.albumId,
      'album_title_text': this.albumTitle,
      'album_description_text': this.albumDescription,
      'album_images': this.albumImages,
      'songs': this.songs,
      'artist': this.artist,
      'price_etb': this.priceEtb,
      'price_dollar': this.priceDollar,
      'is_free': this.isFree,
      'is_bought': this.isBought,
      'is_discount_available': this.isDiscountAvailable,
      'discount_percentage': this.discountPercentage,
      'is_only_on_elf': this.isOnlyOnElf,
      'is_featured': this.isFeatured,
      'is_liked': this.isLiked,
      'album_release_date': this.albumReleaseDate,
      'album_date_created': this.albumDateCreated,
      'album_date_updated': this.albumDateUpdated,
    } as Map<String, dynamic>;
  }
}
