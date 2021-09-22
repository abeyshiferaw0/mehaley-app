import 'package:bloc/bloc.dart';

class SearchInputIsSearchingCubit extends Cubit<bool> {
  SearchInputIsSearchingCubit() : super(false);

  changeIsSearching(bool isSearching) {
    emit(isSearching);
  }
}
