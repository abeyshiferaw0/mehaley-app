import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/api_response/wallet_page_data.dart';
import 'package:mehaley/data/repositories/wallet_data_repository.dart';

part 'wallet_recharge_event.dart';
part 'wallet_recharge_state.dart';

class WalletRechargeBloc
    extends Bloc<WalletRechargeEvent, WalletRechargeState> {
  WalletRechargeBloc({required this.walletDataRepository})
      : super(WalletRecharge());

  final WalletDataRepository walletDataRepository;

  @override
  Stream<WalletRechargeState> mapEventToState(
    WalletRechargeEvent event,
  ) async* {
    if (event is RechargeWalletEvent) {
      yield WalletRechargeLoadingState();
      try {
        final WalletPageData walletPageData =
            await walletDataRepository.createBill(
          event.selectedAmount,
          event.shouldCancelPreviousBill,
        );

        yield WalletRechargeLoadedState(
          walletPageData: walletPageData,
          showFreshBillDialog: walletPageData.freshBill != null ? true : false,
        );
      } catch (error) {
        yield WalletRechargeLoadingErrorState(error: error.toString());
      }
    }
  }
}
