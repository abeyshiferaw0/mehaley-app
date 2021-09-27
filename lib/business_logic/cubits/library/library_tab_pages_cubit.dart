import 'package:bloc/bloc.dart';

class LibraryTabPagesCubit extends Cubit<int> {
  LibraryTabPagesCubit() : super(0);

  tabChanged(int index) {
    emit(index);
  }
}
