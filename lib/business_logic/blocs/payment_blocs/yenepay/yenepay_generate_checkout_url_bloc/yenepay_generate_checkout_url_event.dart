part of 'yenepay_generate_checkout_url_bloc.dart';

abstract class YenepayGenerateCheckoutUrlEvent extends Equatable {
  const YenepayGenerateCheckoutUrlEvent();
}

class GenerateCheckoutUrlEvent extends YenepayGenerateCheckoutUrlEvent {
  const GenerateCheckoutUrlEvent({
    required this.itemId,
    required this.appPurchasedItemType,
  });

  final int itemId;

  final AppPurchasedItemType appPurchasedItemType;

  @override
  List<Object?> get props => [
        itemId,
        appPurchasedItemType,
      ];
}
