import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'remote_image.g.dart';

@HiveType(typeId: 6)
class RemoteImage extends Equatable {
  @HiveField(0)
  final int imageId;
  @HiveField(1)
  final String imageSmallPath;
  @HiveField(2)
  final String imageMediumPath;
  @HiveField(3)
  final String imageLargePath;
  @HiveField(4)
  final int smallImageWidth;
  @HiveField(5)
  final int smallImageHeight;
  @HiveField(6)
  final int mediumImageWidth;
  @HiveField(7)
  final int mediumImageHeight;
  @HiveField(8)
  final int largeImageWidth;
  @HiveField(9)
  final int largeImageHeight;
  @HiveField(10)
  final String primaryColorHex;

  const RemoteImage({
    required this.primaryColorHex,
    required this.imageId,
    required this.imageSmallPath,
    required this.imageMediumPath,
    required this.imageLargePath,
    required this.smallImageWidth,
    required this.smallImageHeight,
    required this.mediumImageWidth,
    required this.mediumImageHeight,
    required this.largeImageWidth,
    required this.largeImageHeight,
  });

  @override
  List<Object?> get props => [
        imageId,
        imageSmallPath,
        imageMediumPath,
        imageLargePath,
        smallImageWidth,
        smallImageHeight,
        mediumImageWidth,
        mediumImageHeight,
        largeImageWidth,
        largeImageHeight,
        primaryColorHex,
      ];

  factory RemoteImage.fromMap(Map<String, dynamic> map) {
    return new RemoteImage(
      imageId: map['image_id'] as int,
      imageSmallPath: map['image_small_path'] as String,
      imageMediumPath: map['image_medium_path'] as String,
      imageLargePath: map['image_large_path'] as String,
      smallImageWidth: map['small_image_width'] as int,
      smallImageHeight: map['small_image_height'] as int,
      mediumImageWidth: map['medium_image_width'] as int,
      mediumImageHeight: map['medium_image_height'] as int,
      largeImageWidth: map['large_image_width'] as int,
      largeImageHeight: map['large_image_height'] as int,
      primaryColorHex: map['primary_color_hex'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'image_id': this.imageId,
      'image_small_path': this.imageSmallPath,
      'image_medium_path': this.imageMediumPath,
      'image_large_path': this.imageLargePath,
      'small_image_width': this.smallImageWidth,
      'small_image_height': this.smallImageHeight,
      'medium_image_width': this.mediumImageWidth,
      'medium_image_height': this.mediumImageHeight,
      'large_image_width': this.largeImageWidth,
      'large_image_height': this.largeImageHeight,
      'primary_color_hex': this.primaryColorHex,
    } as Map<String, dynamic>;
  }
}
