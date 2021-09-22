import 'package:elf_play/data/models/remote_image.dart';
import 'package:elf_play/data/models/text_lan.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

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
  @HiveField(6)
  final String artistAboutSocialLinks;
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
    required this.artistAboutSocialLinks,
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
        artistAboutSocialLinks,
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
      artistImages: (map['artist_images'] as List)
          .map((remoteImage) => RemoteImage.fromMap(remoteImage))
          .toList(),
      isVerified: map['is_verified'] == 1 ? true : false,
      isSuggested: map['is_suggested'] == 1 ? true : false,
      artistAboutSocialLinks: map['artist_about_social_links'] as String,
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
      'artist_name': this.artistName,
      'artist_about_biography': this.artistAboutBiography,
      'artist_images': this.artistImages,
      'is_verified': this.isVerified,
      'is_suggested': this.isSuggested,
      'artist_about_social_links': this.artistAboutSocialLinks,
      'is_followed': this.isFollowed,
      'artist_date_created': this.artistDateCreated,
      'artist_date_updated': this.artistDateUpdated,
    } as Map<String, dynamic>;
  }
}
