part of 'wallet_bill_status_bloc.dart';

abstract class WalletBillStatusState extends Equatable {
  const WalletBillStatusState();
}

class WalletBillStatusInitial extends WalletBillStatusState {
  @override
  List<Object> get props => [];
}

class WalletBillStatusLoadingState extends WalletBillStatusState {
  @override
  List<Object?> get props => [];
}

class WalletBillStatusLoadingErrorState extends WalletBillStatusState {
  final String error;

  WalletBillStatusLoadingErrorState({required this.error});
  @override
  List<Object?> get props => [error];
}

class WalletBillStatusLoadedState extends WalletBillStatusState {
  final WalletPageData walletPageData;
  final bool showFreshBillDialog;

  WalletBillStatusLoadedState({
    required this.showFreshBillDialog,
    required this.walletPageData,
  });

  @override
  List<Object?> get props => [walletPageData, showFreshBillDialog];
}
