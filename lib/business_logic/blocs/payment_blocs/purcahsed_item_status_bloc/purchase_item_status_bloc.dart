import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/api_response/cart_check_out_status_data.dart';
import 'package:mehaley/data/models/api_response/purchase_item_status_data.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/repositories/payment_repository.dart';

part 'purchase_item_status_event.dart';
part 'purchase_item_status_state.dart';

class PurchaseItemStatusBloc
    extends Bloc<PurchaseItemStatusEvent, PurchaseItemStatusState> {
  PurchaseItemStatusBloc({required this.paymentRepository})
      : super(PurchaseItemStatusInitial());

  final PaymentRepository paymentRepository;

  @override
  Future<void> close() {
    paymentRepository.cancelDio();
    return super.close();
  }

  @override
  Stream<PurchaseItemStatusState> mapEventToState(
      PurchaseItemStatusEvent event) async* {
    if (event is CheckItemPurchaseStatusEvent) {
      yield PurchaseItemStatusLoadingState();

      try {
        final PurchaseItemStatusData purchaseItemStatusData =
            await paymentRepository.checkPurchaseItemStatus(
          event.itemId,
          event.purchasedItemType,
        );

        yield PurchaseItemStatusLoadedState(
          purchaseItemStatusData: purchaseItemStatusData,
          itemImageUrl: event.itemImageUrl,
          itemTitle: event.itemTitle,
          itemSubTitle: event.itemSubTitle,
          purchasedItemType: event.purchasedItemType,
        );
      } catch (error) {
        yield PurchaseItemStatusLoadingErrorState(error: error.toString());
      }
    } else if (event is CheckCartCheckOutStatusEvent) {
      yield CartCheckoutStatusLoadingState();

      try {
        final CartCheckOutStatusData cartCheckOutStatusData =
            await paymentRepository.checkCartCheckOutStatusData();

        yield CartCheckoutStatusLoadedState(
          cartCheckOutStatusData: cartCheckOutStatusData,
        );
      } catch (error) {
        yield CartCheckoutStatusLoadingErrorState(error: error.toString());
      }
    }
  }
}
