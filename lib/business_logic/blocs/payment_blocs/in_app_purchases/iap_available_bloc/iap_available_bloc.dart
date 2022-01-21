import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:mehaley/data/repositories/iap_purchase_repository.dart';

part 'iap_available_event.dart';
part 'iap_available_state.dart';

class IapAvailableBloc extends Bloc<IapAvailableEvent, IapAvailableState> {
  IapAvailableBloc({required this.iapPurchaseRepository})
      : super(IapAvailableInitial());

  final IapPurchaseRepository iapPurchaseRepository;

  @override
  Stream<IapAvailableState> mapEventToState(IapAvailableEvent event) async* {
    if (event is CheckIapAvailabilityEvent) {
      try {
        await iapPurchaseRepository.getAvailablePurchases();
        await iapPurchaseRepository.setIsIapAvailable(true);
        yield IapAvailabilityCheckedState();
      } catch (e) {
        if (e is PlatformException) {
          if (e.message ==
              'IAP not prepared. Check if Google Play service is available.') {
            await iapPurchaseRepository.setIsIapAvailable(false);
            print("errorrr => ${e.message}");
          }
        }
        yield IapAvailabilityCheckedState();
      }
    }
  }
}
