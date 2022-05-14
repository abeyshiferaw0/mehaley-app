part of 'credit_card_generate_checkout_url_bloc.dart';

abstract class CreditCardGenerateCheckoutUrlEvent extends Equatable {
  const CreditCardGenerateCheckoutUrlEvent();
}

class GenerateCheckoutUrlEvent extends CreditCardGenerateCheckoutUrlEvent {
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
