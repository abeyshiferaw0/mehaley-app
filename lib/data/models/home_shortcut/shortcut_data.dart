import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'shortcut_data.g.dart';

@HiveType(typeId: 23)
class ShortcutData extends Equatable {
  @HiveField(0)
  final int purchasedCount;
  @HiveField(1)
  final int downloadCount;
  @HiveField(3)
  final List<dynamic> shortcuts;

  const ShortcutData({
    required this.purchasedCount,
    required this.downloadCount,
    required this.shortcuts,
  });

  @override
  List<Object?> get props => [
        purchasedCount,
        downloadCount,
        shortcuts,
      ];
}
