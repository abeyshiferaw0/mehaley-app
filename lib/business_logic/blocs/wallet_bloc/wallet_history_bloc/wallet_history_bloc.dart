import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/payment/wallet_history.dart';
import 'package:mehaley/data/repositories/wallet_data_repository.dart';

part 'wallet_history_event.dart';
part 'wallet_history_state.dart';

class WalletHistoryBloc extends Bloc<WalletHistoryEvent, WalletHistoryState> {
  WalletHistoryBloc({required this.walletDataRepository})
      : super(WalletHistoryInitial());

  final WalletDataRepository walletDataRepository;

  @override
  Future<void> close() {
    walletDataRepository.cancelDio();
    return super.close();
  }

  @override
  Stream<WalletHistoryState> mapEventToState(
    WalletHistoryEvent event,
  ) async* {
    if (event is LoadWalletHistoryPaginatedEvent) {
      yield WalletHistoryPaginatedLoading();
      try {
        List<WalletHistory> walletHistoryList =
            await walletDataRepository.getWalletHistory(
          event.page,
          event.pageSize,
        );

        yield WalletHistoryPaginatedLoaded(
          walletHistoryList: walletHistoryList,
          page: event.page,
        );
      } catch (e) {
        yield WalletHistoryPaginatedLoadingError(error: e.toString());
      }
    }
  }
}
