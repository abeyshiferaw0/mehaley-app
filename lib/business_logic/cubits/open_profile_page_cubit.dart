import 'package:bloc/bloc.dart';

class OpenProfilePageCubit extends Cubit<bool> {
  OpenProfilePageCubit() : super(false);

  openPage(bool open) {
    emit(open);
  }
}
