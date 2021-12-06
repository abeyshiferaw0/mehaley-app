part of 'wallet_recharge_bloc.dart';

abstract class WalletRechargeState extends Equatable {
  const WalletRechargeState();
}

class WalletRecharge extends WalletRechargeState {
  @override
  List<Object> get props => [];
}

class WalletRechargeLoadingState extends WalletRechargeState {
  @override
  List<Object?> get props => [];
}

class WalletRechargeLoadingErrorState extends WalletRechargeState {
  final String error;

  WalletRechargeLoadingErrorState({required this.error});
  @override
  List<Object?> get props => [error];
}

class WalletRechargeLoadedState extends WalletRechargeState {
  final WalletPageData walletPageData;
  final bool showFreshBillDialog;

  WalletRechargeLoadedState(
      {required this.showFreshBillDialog, required this.walletPageData});

  @override
  List<Object?> get props => [walletPageData, showFreshBillDialog];
}
