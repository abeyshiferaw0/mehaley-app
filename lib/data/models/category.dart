import 'package:elf_play/data/models/remote_image.dart';
import 'package:elf_play/data/models/text_lan.dart';
import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int categoryId;
  final TextLan categoryNameText;
  final TextLan categoryDescriptionText;
  final RemoteImage categoryImage;
  final DateTime categoryDateCreated;
  final DateTime categoryDateUpdated;

  const Category({
    required this.categoryId,
    required this.categoryNameText,
    required this.categoryDescriptionText,
    required this.categoryImage,
    required this.categoryDateCreated,
    required this.categoryDateUpdated,
  });

  @override
  List<Object?> get props => [
        categoryId,
        categoryNameText,
        categoryDescriptionText,
        categoryImage,
        categoryDateCreated,
        categoryDateUpdated,
      ];

  factory Category.fromMap(Map<String, dynamic> map) {
    return new Category(
      categoryId: map['category_id'] as int,
      categoryNameText: TextLan.fromMap(map['category_name_text_id']),
      categoryDescriptionText:
          TextLan.fromMap(map['category_description_text_id']),
      categoryImage: RemoteImage.fromMap(map['category_image_id']),
      categoryDateCreated: DateTime.parse(map['category_date_created']),
      categoryDateUpdated: DateTime.parse(map['category_date_updated']),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'category_id': this.categoryId,
      'category_name_text': this.categoryNameText,
      'category_description_text': this.categoryDescriptionText,
      'category_image': this.categoryImage,
      'category_date_created': this.categoryDateCreated,
      'category_date_updated': this.categoryDateUpdated,
    } as Map<String, dynamic>;
  }
}
