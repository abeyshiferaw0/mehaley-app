part of 'wallet_recharge_initial_bloc.dart';

abstract class WalletRechargeInitialState extends Equatable {
  const WalletRechargeInitialState();
}

class WalletRechargeInitialInitial extends WalletRechargeInitialState {
  @override
  List<Object> get props => [];
}

class WalletRechargeInitialLoadingState extends WalletRechargeInitialState {
  @override
  List<Object?> get props => [];
}

class WalletRechargeInitialLoadingErrorState
    extends WalletRechargeInitialState {
  final String error;

  WalletRechargeInitialLoadingErrorState({required this.error});
  @override
  List<Object?> get props => [error];
}

class WalletRechargeInitialLoadedState extends WalletRechargeInitialState {
  final WalletPageData walletPageData;
  final bool showFreshBillDialog;

  WalletRechargeInitialLoadedState(
      {required this.showFreshBillDialog, required this.walletPageData});

  @override
  List<Object?> get props => [walletPageData, showFreshBillDialog];
}
