import 'package:bloc/bloc.dart';

class TodayHolidayToastCubit extends Cubit<bool> {
  TodayHolidayToastCubit() : super(false);

  showToast(bool show) async {
    emit(show);
  }
}
