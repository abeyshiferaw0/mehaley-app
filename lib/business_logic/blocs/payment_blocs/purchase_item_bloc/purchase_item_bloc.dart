import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/api_response/purchase_item_status_data.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/repositories/payment_repository.dart';

part 'purchase_item_event.dart';
part 'purchase_item_state.dart';

class PurchaseItemBloc extends Bloc<PurchaseItemEvent, PurchaseItemState> {
  PurchaseItemBloc({required this.paymentRepository})
      : super(PurchaseItemInitial());

  final PaymentRepository paymentRepository;

  @override
  Future<void> close() {
    paymentRepository.cancelDio();
    return super.close();
  }

  @override
  Stream<PurchaseItemState> mapEventToState(PurchaseItemEvent event) async* {
    if (event is PurchaseItemStatusEvent) {
      yield PurchaseItemLoadingState();

      try {
        final PurchaseItemStatusData purchaseItemStatusData =
            await paymentRepository.purchaseItem(
          event.itemId,
          event.purchasedItemType,
        );

        yield PurchaseItemLoadedState(
          purchaseItemStatusData: purchaseItemStatusData,
          purchasedItemType: event.purchasedItemType,
        );
      } catch (error) {
        yield PurchaseItemLoadingErrorState(error: error.toString());
      }
    }
  }
}
