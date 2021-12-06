part of 'wallet_history_bloc.dart';

abstract class WalletHistoryEvent extends Equatable {
  const WalletHistoryEvent();
}

class LoadWalletHistoryPaginatedEvent extends WalletHistoryEvent {
  final int pageSize;
  final int page;

  LoadWalletHistoryPaginatedEvent({required this.page, required this.pageSize});

  @override
  List<Object?> get props => [page, pageSize];
}
