import 'package:bloc/bloc.dart';

class BottomBarSubscriptionCubit extends Cubit<bool> {
  BottomBarSubscriptionCubit() : super(false);

  void setPageShowing(bool isShowing) {
    print("BottomBarSubscriptionCubit => setPageShowing ${isShowing}");
    emit(isShowing);
  }
}
