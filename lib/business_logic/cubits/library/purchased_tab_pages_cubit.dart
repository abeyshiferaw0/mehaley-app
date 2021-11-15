import 'package:bloc/bloc.dart';
import 'package:mehaley/config/enums.dart';

class PurchasedTabPagesCubit extends Cubit<AppPurchasedPageItemTypes> {
  PurchasedTabPagesCubit() : super(AppPurchasedPageItemTypes.ALL_SONGS);

  changePage(AppPurchasedPageItemTypes appPurchasedPageItemTypes) {
    emit(appPurchasedPageItemTypes);
  }
}
