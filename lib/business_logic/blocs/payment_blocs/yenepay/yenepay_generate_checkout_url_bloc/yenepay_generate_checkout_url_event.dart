part of 'yenepay_generate_checkout_url_bloc.dart';

abstract class YenepayGenerateCheckoutUrlEvent extends Equatable {
  const YenepayGenerateCheckoutUrlEvent();
}

class GenerateCheckoutUrlEvent extends YenepayGenerateCheckoutUrlEvent {
  const GenerateCheckoutUrlEvent(
      {required this.itemId,
      required this.itemNameEn,
      required this.appPurchasedItemType,
      required this.price});

  final int itemId;
  final String itemNameEn;
  final AppPurchasedItemType appPurchasedItemType;
  final double price;

  @override
  List<Object?> get props => [
        itemId,
        itemNameEn,
        appPurchasedItemType,
        price,
      ];
}
