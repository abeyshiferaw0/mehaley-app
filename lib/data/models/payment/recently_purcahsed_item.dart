import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:mehaley/data/models/enums/enums.dart';

part 'recently_purcahsed_item.g.dart';

@HiveType(typeId: 14)
class RecentlyPurchasedItem extends Equatable {
  @HiveField(0)
  final int itemId;
  @HiveField(1)
  final AppPurchasedItemType appPurchasedItemType;
  @HiveField(2)
  final int millisecondsSinceEpoch;

  RecentlyPurchasedItem({
    required this.itemId,
    required this.appPurchasedItemType,
    required this.millisecondsSinceEpoch,
  });

  @override
  List<Object?> get props => [
        itemId,
        appPurchasedItemType,
        millisecondsSinceEpoch,
      ];

//

}
