part of 'wallet_history_bloc.dart';

abstract class WalletHistoryState extends Equatable {
  const WalletHistoryState();
}

class WalletHistoryInitial extends WalletHistoryState {
  @override
  List<Object> get props => [];
}

class WalletHistoryPaginatedLoading extends WalletHistoryState {
  @override
  List<Object?> get props => [];
}

class WalletHistoryPaginatedLoaded extends WalletHistoryState {
  final List<WalletHistory> walletHistoryList;
  final int page;

  WalletHistoryPaginatedLoaded(
      {required this.page, required this.walletHistoryList});

  @override
  List<Object?> get props => [walletHistoryList,page];
}

class WalletHistoryPaginatedLoadingError extends WalletHistoryState {
  final String error;

  WalletHistoryPaginatedLoadingError({required this.error});

  @override
  List<Object?> get props => [error];
}
