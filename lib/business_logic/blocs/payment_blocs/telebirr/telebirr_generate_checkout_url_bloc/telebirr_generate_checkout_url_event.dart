part of 'telebirr_generate_checkout_url_bloc.dart';

abstract class TelebirrGenerateCheckoutUrlEvent extends Equatable {
  const TelebirrGenerateCheckoutUrlEvent();
}

class GenerateCheckoutUrlEvent extends TelebirrGenerateCheckoutUrlEvent {
  const GenerateCheckoutUrlEvent({
    required this.itemId,
    required this.purchasedItemType,
  });

  final int itemId;
  final PurchasedItemType purchasedItemType;

  @override
  List<Object?> get props => [
        itemId,
        purchasedItemType,
      ];
}
