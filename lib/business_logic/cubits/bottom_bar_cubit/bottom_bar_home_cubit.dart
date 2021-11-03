import 'package:bloc/bloc.dart';

class BottomBarHomeCubit extends Cubit<bool> {
  BottomBarHomeCubit() : super(false);

  void setPageShowing(bool isShowing) {
    emit(isShowing);
  }
}
