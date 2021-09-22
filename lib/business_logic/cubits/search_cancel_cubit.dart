import 'package:bloc/bloc.dart';

class SearchCancelCubit extends Cubit<bool> {
  SearchCancelCubit() : super(false);

  changeSearchingState({required bool cancelSearchingView}) {
    emit(cancelSearchingView);
  }
}
