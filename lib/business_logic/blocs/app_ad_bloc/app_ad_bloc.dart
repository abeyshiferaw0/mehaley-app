import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/api_response/app_ad_data.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/repositories/app_ad_repository.dart';

part 'app_ad_event.dart';
part 'app_ad_state.dart';

class AppAdBloc extends Bloc<AppAdEvent, AppAdState> {
  AppAdBloc({required this.appAdDataRepository}) : super(AppAdInitial());

  final AppAdDataRepository appAdDataRepository;

  @override
  Stream<AppAdState> mapEventToState(
    AppAdEvent event,
  ) async* {
    if (event is LoadAppAdEvent) {
      yield AppAdLoadingState();
      try {
        //YIELD CACHE DATA
        final AppAdData appAdData = await appAdDataRepository
            .getAppAds(AppCacheStrategy.LOAD_CACHE_FIRST);

        yield AppAdLoadedState(appAdData: appAdData);

        if (isFromCatch(appAdData.response)) {
          try {
            //REFRESH AFTER CACHE YIELD
            final AppAdData appAdData = await appAdDataRepository
                .getAppAds(AppCacheStrategy.CACHE_LATER);
            yield AppAdLoadingState();
            yield AppAdLoadedState(
              appAdData: appAdData,
            );
          } catch (error) {
            //DON'T YIELD ERROR  BECAUSE CACHE IS FETCHED
          }
        }
      } catch (error) {
        try {
          //REFRESH WITH CACHE_LATER AFTER CACHE ERROR
          final AppAdData appAdData =
              await appAdDataRepository.getAppAds(AppCacheStrategy.CACHE_LATER);
          yield AppAdLoadingState();
          yield AppAdLoadedState(
            appAdData: appAdData,
          );
        } catch (error) {
          yield AppAdLoadingErrorState(error: error.toString());
        }
      }
    }
  }

  bool isFromCatch(Response response) {
    if (response.extra['@fromNetwork@'] == null) return true;
    return !response.extra['@fromNetwork@'];
  }
}
