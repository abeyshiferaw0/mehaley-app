import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/repositories/app_version_repository.dart';
import 'package:new_version/new_version.dart';

part 'newer_version_event.dart';
part 'newer_version_state.dart';

class NewerVersionBloc extends Bloc<NewerVersionEvent, NewerVersionState> {
  NewerVersionBloc({required this.appVersionRepository})
      : super(NewerVersionInitial());

  final AppVersionRepository appVersionRepository;

  @override
  Stream<NewerVersionState> mapEventToState(NewerVersionEvent event) async* {
    if (event is ShouldShowNewVersionDialogEvent) {
      yield ShouldShowNewVersionLoadingState();
      try {
        VersionStatus versionStatus =
            await appVersionRepository.getVersionStatus();

        if (versionStatus.canUpdate) {
          ///FIRST CHECK IF LAST SHOWN IS MORE THAN A WEEK
          bool isLastShownMoreThanWeek =
              await appVersionRepository.isLastNewVersionShownMoreThanWeek();
          bool isLastShownVersionDiffThanNew = await appVersionRepository
              .isLastShownVersionDiffThanNewVersion(versionStatus);
          bool isDontAskAgainEnabled =
              await appVersionRepository.isDontAskAgainEnabled(versionStatus);
          if (isLastShownMoreThanWeek) {
            if (isLastShownVersionDiffThanNew) {
              ///UPDATE HIVE VARIABLES FIRST
              await appVersionRepository.updateNewVersionVariables(
                  versionStatus, true);
              yield ShouldShowNewVersionLoadedState(shouldShow: true);
            } else {
              if (!isDontAskAgainEnabled) {
                ///UPDATE HIVE VARIABLES FIRST
                await appVersionRepository.updateNewVersionVariables(
                    versionStatus, false);
                yield ShouldShowNewVersionLoadedState(shouldShow: true);
              }
            }
          }
        }
      } catch (e) {
        yield ShouldShowNewVersionLoadingErrorState(error: e.toString());
      }
    }
  }
}
