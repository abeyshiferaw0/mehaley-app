part of 'wallet_page_bloc.dart';

abstract class WalletPageEvent extends Equatable {
  const WalletPageEvent();
}

class LoadWalletPageEvent extends WalletPageEvent {
  @override
  List<Object?> get props => [];
}

class RefreshWalletPageEvent extends WalletPageEvent {
  @override
  List<Object?> get props => [];
}

class UpdateWalletPageEvent extends WalletPageEvent {
  final WalletPageData walletPageData;

  UpdateWalletPageEvent({required this.walletPageData});
  @override
  List<Object?> get props => [walletPageData];
}
