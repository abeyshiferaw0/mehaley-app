import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/enums/enums.dart';

class YenepayPaymentStatus extends Equatable {
  final int itemId;
  final YenepayPaymentReturnType yenepayPaymentReturnType;
  final PurchasedItemType purchasedItemType;
  final AppPurchasedSources appPurchasedSources;
  final bool isFromSelfPage;

  YenepayPaymentStatus({
    required this.itemId,
    required this.yenepayPaymentReturnType,
    required this.purchasedItemType,
    required this.appPurchasedSources,
    required this.isFromSelfPage,
  });

  factory YenepayPaymentStatus.fromJson(Map<String, dynamic> json) {
    return YenepayPaymentStatus(
      itemId: int.parse(json["item_id"]),
      yenepayPaymentReturnType: EnumToString.fromString(
          YenepayPaymentReturnType.values, json["return_type"])!,
      purchasedItemType:
          EnumToString.fromString(PurchasedItemType.values, json["item_type"])!,
      appPurchasedSources: EnumToString.fromString(
          AppPurchasedSources.values, json["app_purchased_sources"])!,
      isFromSelfPage: json["is_from_self_page"] == 'true' ? true : false,
    );
  }

  @override
  List<Object?> get props => [
        itemId,
        yenepayPaymentReturnType,
        purchasedItemType,
        appPurchasedSources,
        isFromSelfPage,
      ];
}
