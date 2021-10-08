import 'package:bloc/bloc.dart';
import 'package:elf_play/config/app_hive_boxes.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/data/models/app_user.dart';

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
