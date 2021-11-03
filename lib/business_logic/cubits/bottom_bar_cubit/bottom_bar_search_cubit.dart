import 'package:bloc/bloc.dart';

class BottomBarSearchCubit extends Cubit<bool> {
  BottomBarSearchCubit() : super(false);

  void setPageShowing(bool isShowing) {
    emit(isShowing);
  }
}
