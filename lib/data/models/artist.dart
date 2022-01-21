import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:mehaley/data/models/remote_image.dart';
import 'package:mehaley/data/models/text_lan.dart';

part 'artist.g.dart';

@HiveType(typeId: 1)
class Artist extends Equatable {
  @HiveField(0)
  final int artistId;
  @HiveField(1)
  final TextLan artistName;
  @HiveField(2)
  final TextLan artistAboutBiography;
  @HiveField(3)
  final List<RemoteImage> artistImages;
  @HiveField(4)
  final bool isVerified;
  @HiveField(5)
  final bool isSuggested;
  @HiveField(7)
  final bool? isFollowed;
  @HiveField(8)
  final DateTime artistDateCreated;
  @HiveField(9)
  final DateTime artistDateUpdated;

  const Artist({
    required this.artistId,
    required this.artistName,
    required this.artistAboutBiography,
    required this.artistImages,
    required this.isVerified,
    required this.isSuggested,
    required this.isFollowed,
    required this.artistDateCreated,
    required this.artistDateUpdated,
  });

  @override
  List<Object?> get props => [
        artistId,
        artistName,
        artistAboutBiography,
        artistImages,
        isVerified,
        isSuggested,
        isFollowed,
        artistDateCreated,
        artistDateUpdated,
      ];

  factory Artist.fromMap(Map<String, dynamic> map) {
    return new Artist(
      artistId: map['artist_id'] as int,
      artistName: TextLan.fromMap(map['artist_name_text_id']),
      artistAboutBiography:
          TextLan.fromMap(map['artist_about_biography_text_id']),
      artistImages: (map['artist_images'] as List).length > 0
          ? (map['artist_images'] as List)
              .map((remoteImage) => RemoteImage.fromMap(remoteImage))
              .toList()
          : [RemoteImage.emptyRemoteImage()],
      isVerified: map['is_verified'] == 1 ? true : false,
      isSuggested: map['is_suggested'] == 1 ? true : false,
      isFollowed: map['is_followed'] != null
          ? (map['is_followed'] == 1 ? true : false)
          : null,
      artistDateCreated: DateTime.parse(map['artist_date_created']),
      artistDateUpdated: DateTime.parse(map['artist_date_updated']),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'artist_id': this.artistId,
      'artist_name_text_id': this.artistName.toMap(),
      'artist_about_biography_text_id': this.artistAboutBiography.toMap(),
      'artist_images': getRemoteImagesListMap(this.artistImages),
      'is_verified': this.isVerified ? '1' : '0',
      'is_suggested': this.isSuggested ? '1' : '0',
      'is_followed': this.isFollowed != null
          ? this.isFollowed!
              ? '1'
              : '0'
          : null,
      'artist_date_created': this.artistDateCreated.toString(),
      'artist_date_updated': this.artistDateUpdated.toString(),
    } as Map<String, dynamic>;
  }

  dynamic getRemoteImagesListMap(List<RemoteImage> remoteImages) {
    List<Map<String, dynamic>> mapItems = [];
    remoteImages.forEach((element) {
      mapItems.add(element.toMap());
    });
    return mapItems;
  }
}
