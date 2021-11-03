import 'package:bloc/bloc.dart';

class BottomBarLibraryCubit extends Cubit<bool> {
  BottomBarLibraryCubit() : super(false);

  void setPageShowing(bool isShowing) {
    emit(isShowing);
  }
}
