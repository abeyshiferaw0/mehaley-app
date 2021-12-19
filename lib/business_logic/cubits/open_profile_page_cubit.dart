import 'package:bloc/bloc.dart';

class OpenProfilePageCubit extends Cubit<int> {
  OpenProfilePageCubit() : super(DateTime.now().millisecondsSinceEpoch);

  openPage() {
    emit(DateTime.now().millisecondsSinceEpoch);
  }
}
