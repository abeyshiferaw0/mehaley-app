import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';

part 'app_start_event.dart';
part 'app_start_state.dart';

class AppStartBloc extends Bloc<AppStartEvent, AppStartState> {
  AppStartBloc() : super(AppStartInitial());

  @override
  Stream<AppStartState> mapEventToState(
    AppStartEvent event,
  ) async* {
    if (event is IsAppFirstLaunchEvent) {
      //CHECK IF APP IS FIRST TIME
      final bool contains = AppHiveBoxes.instance.userBox.containsKey(
        AppValues.isFirstTimeKey,
      );
      if (contains) {
        final bool isFirstTime = AppHiveBoxes.instance.userBox.get(
          AppValues.isFirstTimeKey,
        );
        yield IsAppFirstLaunchState(isFirstTime: isFirstTime);
      } else {
        yield IsAppFirstLaunchState(isFirstTime: true);
      }
    } else if (event is SetAppFirstLaunchEvent) {
      AppHiveBoxes.instance.userBox.put(
        AppValues.isFirstTimeKey,
        event.isFirstTime,
      );
      yield IsAppFirstLaunchState(isFirstTime: event.isFirstTime);
    }
  }
}
