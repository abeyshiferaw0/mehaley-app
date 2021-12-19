import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/repositories/app_version_repository.dart';
import 'package:mehaley/util/app_version_util.dart';

part 'app_min_version_event.dart';
part 'app_min_version_state.dart';

class AppMinVersionBloc extends Bloc<AppMinVersionEvent, AppMinVersionState> {
  AppMinVersionBloc({required this.appVersionRepository})
      : super(AppMinVersionInitial());

  final AppVersionRepository appVersionRepository;

  @override
  Stream<AppMinVersionState> mapEventToState(
    AppMinVersionEvent event,
  ) async* {
    if (event is CheckAppMinVersionEvent) {
      yield CheckAppMinVersionLoadingState();
      try {
        ///FIRST CHECK FROM LOCAL CACHE
        String newVersion = AppVersionUtil.getNewVersion();
        String currentVersion = await AppVersionUtil.getCurrentVersion();
        bool isAppBelowMinVersionOne =
            await AppVersionUtil.isAppBelowMinVersion();

        yield CheckAppMinVersionLoadedState(
          minAppVersion: newVersion,
          newVersion: newVersion,
          currentVersion: currentVersion,
          shouldGoToHomePage: false,
          isAppBelowMinVersion: isAppBelowMinVersionOne,
        );

        yield CheckAppMinVersionLoadingState();

        ///THEN TRY WITH API
        String minAppVersion = await appVersionRepository.getMinAppVersion();

        if (minAppVersion.split('.').length > 2) {
          await appVersionRepository.saveMinAppVersion(minAppVersion);
        }

        bool isAppBelowMinVersionTwo =
            await AppVersionUtil.isAppBelowMinVersion();

        yield CheckAppMinVersionLoadedState(
          minAppVersion: minAppVersion,
          newVersion: newVersion,
          shouldGoToHomePage:
              (isAppBelowMinVersionOne && !isAppBelowMinVersionTwo)
                  ? true
                  : false,
          currentVersion: currentVersion,
          isAppBelowMinVersion: isAppBelowMinVersionTwo,
        );
      } catch (e) {
        yield CheckAppMinVersionLoadingErrorState(
          error: e.toString(),
        );
      }
    }
  }
}
