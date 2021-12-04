import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/api_response/wallet_page_data.dart';
import 'package:mehaley/data/models/payment/webirr_bill.dart';
import 'package:mehaley/data/repositories/wallet_data_repository.dart';

part 'wallet_bill_cancel_event.dart';
part 'wallet_bill_cancel_state.dart';

class WalletBillCancelBloc
    extends Bloc<WalletBillCancelEvent, WalletBillCancelState> {
  WalletBillCancelBloc({required this.walletDataRepository})
      : super(WalletBillCancelInitial());

  final WalletDataRepository walletDataRepository;

  @override
  Stream<WalletBillCancelState> mapEventToState(
    WalletBillCancelEvent event,
  ) async* {
    if (event is CancelWalletBillEvent) {
      yield CancelWalletBillLoadingState();

      try {
        final WalletPageData walletPageData =
            await walletDataRepository.cancelBill();

        yield CancelWalletBillLoadedState(
          walletPageData: walletPageData,
          showFreshBillDialog: walletPageData.freshBill != null ? true : false,
          oldBill: event.oldBill,
        );
      } catch (error) {
        yield CancelWalletBillLoadingErrorState(error: error.toString());
      }
    }
  }
}
