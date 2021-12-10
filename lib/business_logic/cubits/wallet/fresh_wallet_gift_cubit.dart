import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mehaley/data/models/payment/wallet_gift.dart';

class FreshWalletGiftCubit extends Cubit<List<WalletGift>?> {
  FreshWalletGiftCubit() : super(null);

  showGiftReceived(List<WalletGift> walletGifts) async {
    emit(walletGifts);
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
