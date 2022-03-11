part of 'yenepay_generate_checkout_url_bloc.dart';

abstract class YenepayGenerateCheckoutUrlEvent extends Equatable {
  const YenepayGenerateCheckoutUrlEvent();
}

class GenerateCheckoutUrlEvent extends YenepayGenerateCheckoutUrlEvent {
  const GenerateCheckoutUrlEvent({
    required this.appPurchasedSources,
    required this.itemId,
    required this.appPurchasedItemType,
    required this.isFromSelfPage,
  });

  final int itemId;
  final AppPurchasedSources appPurchasedSources;
  final AppPurchasedItemType appPurchasedItemType;
  final bool isFromSelfPage;

  @override
  List<Object?> get props => [
        itemId,
        appPurchasedItemType,
        appPurchasedSources,
        isFromSelfPage,
      ];
}
