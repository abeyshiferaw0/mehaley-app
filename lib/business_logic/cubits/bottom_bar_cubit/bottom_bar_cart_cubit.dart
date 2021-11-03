import 'package:bloc/bloc.dart';

class BottomBarCartCubit extends Cubit<bool> {
  BottomBarCartCubit() : super(false);

  void setPageShowing(bool isShowing) {
    emit(isShowing);
  }
}
