import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/api_response/wallet_page_data.dart';
import 'package:mehaley/data/repositories/wallet_data_repository.dart';

part 'wallet_bill_status_event.dart';
part 'wallet_bill_status_state.dart';

class WalletBillStatusBloc
    extends Bloc<WalletBillStatusEvent, WalletBillStatusState> {
  WalletBillStatusBloc({required this.walletDataRepository})
      : super(WalletBillStatusInitial());

  final WalletDataRepository walletDataRepository;

  @override
  Stream<WalletBillStatusState> mapEventToState(
    WalletBillStatusEvent event,
  ) async* {
    if (event is CheckWalletBillStatusEvent) {
      yield WalletBillStatusLoadingState();

      try {
        final WalletPageData walletPageData =
            await walletDataRepository.checkBillStatus();

        yield WalletBillStatusLoadedState(
          walletPageData: walletPageData,
          showFreshBillDialog: walletPageData.freshBill != null ? true : false,
        );
      } catch (error) {
        yield WalletBillStatusLoadingErrorState(error: error.toString());
      }
    }
  }
}
