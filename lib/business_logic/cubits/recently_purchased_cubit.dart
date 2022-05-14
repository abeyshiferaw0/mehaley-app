import 'package:bloc/bloc.dart';

class RecentlyPurchasedCubit extends Cubit<bool?> {
  RecentlyPurchasedCubit() : super(null);

  setRecentlyPurchased(bool? isRecentlyPurchased) async {
    emit(isRecentlyPurchased);
  }
}
