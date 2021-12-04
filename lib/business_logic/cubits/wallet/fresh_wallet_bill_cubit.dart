import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mehaley/data/models/payment/webirr_bill.dart';

class FreshWalletBillCubit extends Cubit<WebirrBill?> {
  FreshWalletBillCubit() : super(null);

  showPaymentConfirmed(WebirrBill? freshBill) async {
    emit(freshBill);
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
