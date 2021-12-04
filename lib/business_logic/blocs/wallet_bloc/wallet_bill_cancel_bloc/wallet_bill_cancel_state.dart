part of 'wallet_bill_cancel_bloc.dart';

abstract class WalletBillCancelState extends Equatable {
  const WalletBillCancelState();
}

class WalletBillCancelInitial extends WalletBillCancelState {
  @override
  List<Object> get props => [];
}

class CancelWalletBillLoadingState extends WalletBillCancelState {
  @override
  List<Object?> get props => [];
}

class CancelWalletBillLoadingErrorState extends WalletBillCancelState {
  final String error;

  CancelWalletBillLoadingErrorState({required this.error});
  @override
  List<Object?> get props => [error];
}

class CancelWalletBillLoadedState extends WalletBillCancelState {
  final WalletPageData walletPageData;
  final WebirrBill oldBill;
  final bool showFreshBillDialog;

  CancelWalletBillLoadedState({
    required this.showFreshBillDialog,
    required this.walletPageData,
    required this.oldBill,
  });

  @override
  List<Object?> get props => [walletPageData, showFreshBillDialog, oldBill];
}
