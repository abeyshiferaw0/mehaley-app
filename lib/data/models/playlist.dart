import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:mehaley/data/models/enums/playlist_created_by.dart';
import 'package:mehaley/data/models/payment/iap_product.dart';
import 'package:mehaley/data/models/remote_image.dart';
import 'package:mehaley/data/models/text_lan.dart';

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
  final IapProduct priceDollar;
  @HiveField(8)
  final bool isFree;
  @HiveField(9)
  final bool isDiscountAvailable;
  @HiveField(10)
  final bool isBought;
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

  const Playlist({
    required this.isBought,
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
        isBought,
        isDiscountAvailable,
        discountPercentage,
        isFeatured,
        createdBy,
        createdById,
        isFollowed,
        playlistDateCreated,
        playlistDateUpdated,
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
      priceEtb: map['price_etb'] as double,
      priceDollar: IapProduct.fromJson(map['price_dollar']),
      isFree: map['is_free'] == 1 ? true : false,
      isBought: map['is_bought'] == 1 ? true : false,
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
      'is_free': this.isFree,
      'is_bought': this.isBought,
      'is_discount_available': this.isDiscountAvailable,
      'discount_percentage': this.discountPercentage,
      'created_by_id': this.createdById,
      'is_followed': this.isFollowed,
      'playlist_date_created': this.playlistDateCreated,
      'playlist_date_updated': this.playlistDateUpdated,
    } as Map<String, dynamic>;
  }

  Playlist copyWith({
    int? playlistId,
    TextLan? playlistNameText,
    TextLan? playlistDescriptionText,
    RemoteImage? playlistImage,
    bool? isVerified,
    bool? isFeatured,
    double? priceEtb,
    IapProduct? priceDollar,
    bool? isFree,
    bool? isDiscountAvailable,
    bool? isBought,
    double? discountPercentage,
    PlaylistCreatedBy? createdBy,
    String? createdById,
    bool? isFollowed,
    DateTime? playlistDateCreated,
    DateTime? playlistDateUpdated,
  }) {
    return Playlist(
      isBought: isBought ?? this.isBought,
      playlistId: playlistId ?? this.playlistId,
      playlistNameText: playlistNameText ?? this.playlistNameText,
      playlistDescriptionText:
          playlistDescriptionText ?? this.playlistDescriptionText,
      playlistImage: playlistImage ?? this.playlistImage,
      isVerified: isVerified ?? this.isVerified,
      isFeatured: isFeatured ?? this.isFeatured,
      priceEtb: priceEtb ?? this.priceEtb,
      priceDollar: priceDollar ?? this.priceDollar,
      isFree: isFree ?? this.isFree,
      isDiscountAvailable: isDiscountAvailable ?? this.isDiscountAvailable,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      createdBy: createdBy ?? this.createdBy,
      createdById: createdById ?? this.createdById,
      isFollowed: isFollowed ?? this.isFollowed,
      playlistDateCreated: playlistDateCreated ?? this.playlistDateCreated,
      playlistDateUpdated: playlistDateUpdated ?? this.playlistDateUpdated,
    );
  }
}
