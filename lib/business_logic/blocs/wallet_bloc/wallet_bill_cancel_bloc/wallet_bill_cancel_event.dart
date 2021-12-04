part of 'wallet_bill_cancel_bloc.dart';

abstract class WalletBillCancelEvent extends Equatable {
  const WalletBillCancelEvent();
}

class CancelWalletBillEvent extends WalletBillCancelEvent {
  final WebirrBill oldBill;

  CancelWalletBillEvent({required this.oldBill});

  @override
  List<Object?> get props => [oldBill];
}
