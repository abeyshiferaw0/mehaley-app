import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/api_response/app_ad_data.dart';
import 'package:mehaley/data/models/app_ad.dart';
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
    // if (event is LoadAppAdEvent) {
    //   yield AppAdLoadingState();
    //   try {
    //     //YIELD CACHE DATA
    //     final AppAdData appAdData =
    //         await appAdDataRepository.getAppAds(AppCacheStrategy.LOAD_CACHE_FIRST);
    //
    //     yield AppAdLoadedState(appAdData: appAdData);
    //
    //     if (isFromCatch(appAdData.response)) {
    //       try {
    //         //REFRESH AFTER CACHE YIELD
    //         final AppAdData appAdData =
    //             await appAdDataRepository.getAppAds(AppCacheStrategy.CACHE_LATER);
    //         yield AppAdLoadingState();
    //         yield AppAdLoadedState(
    //           appAdData: appAdData,
    //         );
    //       } catch (error) {
    //         //DON'T YIELD ERROR  BECAUSE CACHE IS FETCHED
    //       }
    //     }
    //   } catch (error) {
    //     try {
    //       //REFRESH WITH CACHE_LATER AFTER CACHE ERROR
    //       final AppAdData appAdData =
    //           await appAdDataRepository.getAppAds(AppCacheStrategy.CACHE_LATER);
    //       yield AppAdLoadingState();
    //       yield AppAdLoadedState(
    //         appAdData: appAdData,
    //       );
    //     } catch (error) {
    //       yield AppAdLoadingErrorState(error: error.toString());
    //     }
    //   }
    // }

    ///DEBUG
    yield AppAdLoadingState();
    yield AppAdLoadedState(
      appAdData: AppAdData(
        appAdList: [
          AppAd(
            id: 1,
            link: Uri.parse(
              'https://elements.envato.com/product-sale-banners-html5-d42-ad-gwd-psd-BQ9DYB',
            ),
            appAddEmbedPlace: AppAddEmbedPlace.HOME_PAGE,
            appAdAction: AppAdAction.LAUNCH_URL,
            actionLaunchLink: Uri.parse("https://google.com"),
            actionPhoneNumber: "+251930325400",
            maxAdLength: 8,
            preferredHeight: 150,
          ),
          AppAd(
            id: 1,
            link: Uri.parse(
              'https://stackoverflow.com/questions/59916010/what-is-the-offset-class',
            ),
            appAddEmbedPlace: AppAddEmbedPlace.PLAYER_PAGE_ALBUM_ART,
            appAdAction: AppAdAction.LAUNCH_URL,
            maxAdLength: 8,
            preferredHeight: 150,
          ),
        ],
        response: Response(
          requestOptions: RequestOptions(path: ''),
        ),
      ),
    );

    ///DEBUG
  }

  bool isFromCatch(Response response) {
    if (response.extra['@fromNetwork@'] == null) return true;
    return !response.extra['@fromNetwork@'];
  }
}
