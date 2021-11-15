import 'package:bloc/bloc.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/app_user.dart';

class AppUserWidgetsCubit extends Cubit<AppUser> {
  AppUserWidgetsCubit()
      : super(
          AppHiveBoxes.instance.userBox.get(
            AppValues.loggedInUserKey,
          ),
        );

  updateAppUser(AppUser appUser) async {
    emit(appUser);
  }
}
