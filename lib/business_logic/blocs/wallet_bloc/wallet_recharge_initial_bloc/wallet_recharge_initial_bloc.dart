import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/api_response/wallet_page_data.dart';
import 'package:mehaley/data/repositories/wallet_data_repository.dart';

part 'wallet_recharge_initial_event.dart';
part 'wallet_recharge_initial_state.dart';

class WalletRechargeInitialBloc
    extends Bloc<WalletRechargeInitialEvent, WalletRechargeInitialState> {
  WalletRechargeInitialBloc({required this.walletDataRepository})
      : super(WalletRechargeInitialInitial());

  final WalletDataRepository walletDataRepository;

  @override
  Stream<WalletRechargeInitialState> mapEventToState(
    WalletRechargeInitialEvent event,
  ) async* {
    if (event is CheckShouldWalletRechargeEvent) {
      yield WalletRechargeInitialLoadingState();
      try {
        final WalletPageData walletPageData =
            await walletDataRepository.checkBillStatus();

        yield WalletRechargeInitialLoadedState(
          walletPageData: walletPageData,
          showFreshBillDialog: walletPageData.freshBill != null ? true : false,
        );
      } catch (error) {
        yield WalletRechargeInitialLoadingErrorState(error: error.toString());
      }
    }
  }
}
