part of 'wallet_page_bloc.dart';

abstract class WalletPageState extends Equatable {
  const WalletPageState();
}

class WalletPageInitial extends WalletPageState {
  @override
  List<Object> get props => [];
}

class WalletPageLoadingState extends WalletPageState {
  @override
  List<Object?> get props => [];
}

class WalletPageLoadingErrorState extends WalletPageState {
  final String error;

  WalletPageLoadingErrorState({required this.error});
  @override
  List<Object?> get props => [error];
}

class WalletPageLoadedState extends WalletPageState {
  final WalletPageData walletPageData;
  final bool showFreshBillDialog;

  WalletPageLoadedState(
      {required this.showFreshBillDialog, required this.walletPageData});

  @override
  List<Object?> get props => [walletPageData, showFreshBillDialog];
}
