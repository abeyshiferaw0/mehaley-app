import 'package:bloc/bloc.dart';

class BottomBarProfileCubit extends Cubit<bool> {
  BottomBarProfileCubit() : super(false);

  void setPageShowing(bool isShowing) {
    emit(isShowing);
  }
}
