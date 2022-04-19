import 'package:bloc/bloc.dart';
import 'package:mehaley/data/models/enums/enums.dart';

class HomePageTabsChangeListenerCubit extends Cubit<HomePageTabs?> {
  HomePageTabsChangeListenerCubit() : super(null);

  tabChanged(HomePageTabs homePageTabs) async {
    emit(homePageTabs);
  }
}
