part of 'telebirr_generate_checkout_url_bloc.dart';

abstract class TelebirrGenerateCheckoutUrlEvent extends Equatable {
  const TelebirrGenerateCheckoutUrlEvent();
}

class GenerateCheckoutUrlEvent extends TelebirrGenerateCheckoutUrlEvent {
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
