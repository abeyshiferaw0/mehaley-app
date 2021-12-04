part of 'wallet_bill_status_bloc.dart';

abstract class WalletBillStatusEvent extends Equatable {
  const WalletBillStatusEvent();
}

class CheckWalletBillStatusEvent extends WalletBillStatusEvent {
  @override
  List<Object?> get props => [];
}
