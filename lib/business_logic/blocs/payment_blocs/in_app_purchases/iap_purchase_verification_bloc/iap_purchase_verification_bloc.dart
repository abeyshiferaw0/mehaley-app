import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/repositories/iap_purchase_repository.dart';

part 'iap_purchase_verification_event.dart';
part 'iap_purchase_verification_state.dart';

class IapPurchaseVerificationBloc
    extends Bloc<IapPurchaseVerificationEvent, IapPurchaseVerificationState> {
  IapPurchaseVerificationBloc({required this.iapPurchaseRepository})
      : super(IapPurchaseVerificationInitial());

  final IapPurchaseRepository iapPurchaseRepository;

  @override
  Stream<IapPurchaseVerificationState> mapEventToState(
      IapPurchaseVerificationEvent event) async* {
    if (event is IapPurchaseVerifyEvent) {
      yield IapPurchaseVerificationLoadingState();

      try {
        ///VERIFY PURCHASE IN SERVER AND STORE
        bool isValid = await iapPurchaseRepository.verifyItem(
          event.itemId,
          event.appPurchasedItemType,
          event.purchaseToken,
        );

        if (isValid) {
          ///
          yield IapPurchaseVerificationLoadedState(
            isValid: true,
          );
        } else {
          yield IapPurchaseVerificationLoadedState(
            isValid: false,
          );
        }
      } catch (e) {
        yield IapPurchaseVerificationLoadingErrorState(error: e.toString());
      }
    }
  }
}
