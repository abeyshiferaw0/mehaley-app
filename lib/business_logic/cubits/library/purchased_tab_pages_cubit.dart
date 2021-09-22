import 'package:bloc/bloc.dart';
import 'package:elf_play/config/enums.dart';

class PurchasedTabPagesCubit extends Cubit<AppPurchasedPageItemTypes> {
  PurchasedTabPagesCubit() : super(AppPurchasedPageItemTypes.ALL_SONGS);

  changePage(AppPurchasedPageItemTypes appPurchasedPageItemTypes) {
    emit(appPurchasedPageItemTypes);
  }
}
