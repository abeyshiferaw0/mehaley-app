import 'package:bloc/bloc.dart';
import 'package:mehaley/config/enums.dart';

class BottomBarCubit extends Cubit<BottomBarPages> {
  BottomBarCubit() : super(BottomBarPages.HOME);

  void changeScreen(BottomBarPages bottomBarPages) {
    emit(bottomBarPages);
  }

  // void navigatorPush(int currentIndex) {
  //   List<int> pages = [];
  //   pages.addAll(state);
  //   pages.add(currentIndex);
  //   emit(pages);
  // }
  //
  // void navigatorPop() {
  //   List<int> pages = [];
  //   pages.addAll(state);
  //   pages.removeLast();
  //   emit(pages);
  // }
}
