import 'package:elf_play/data/models/remote_image.dart';
import 'package:elf_play/data/models/text_lan.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'category_shortcut.g.dart';

@HiveType(typeId: 21)
class CategoryShortcut extends Equatable {
  @HiveField(0)
  final int categoryId;
  @HiveField(1)
  final TextLan categoryNameText;
  @HiveField(2)
  final RemoteImage categoryImage;

  const CategoryShortcut({
    required this.categoryId,
    required this.categoryNameText,
    required this.categoryImage,
  });

  @override
  List<Object?> get props => [
        categoryId,
        categoryNameText,
        categoryImage,
      ];

  factory CategoryShortcut.fromMap(Map<String, dynamic> map) {
    return new CategoryShortcut(
      categoryId: map['category_id'] as int,
      categoryNameText: TextLan.fromMap(map['category_name_text_id']),
      categoryImage: RemoteImage.fromMap(map['category_image_id']),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'category_id': this.categoryId,
      'category_name_text': this.categoryNameText,
      'category_image': this.categoryImage,
    } as Map<String, dynamic>;
  }
}
