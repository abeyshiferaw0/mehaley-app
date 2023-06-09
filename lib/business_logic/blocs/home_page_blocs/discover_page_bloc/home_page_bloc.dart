import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/api_response/home_page_data.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/repositories/home_data_repository.dart';
import 'package:meta/meta.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc({
    required this.homeDataRepository,
  }) : super(HomePageInitial());

  final HomeDataRepository homeDataRepository;

  @override
  Stream<HomePageState> mapEventToState(
    HomePageEvent event,
  ) async* {
    if (event is LoadHomePageEvent) {
      //LOAD CACHE AND REFRESH
      yield HomePageLoading();

      try {
        //YIELD CACHE DATA
        final HomePageData cachedHomePageData = await homeDataRepository
            .getHomeData(AppCacheStrategy.LOAD_CACHE_FIRST);
        yield HomePageLoaded(homePageData: cachedHomePageData);

        if (isFromCatch(cachedHomePageData.response)) {
          try {
            //REFRESH AFTER CACHE YIELD
            final HomePageData refreshedHomePageData = await homeDataRepository
                .getHomeData(AppCacheStrategy.CACHE_LATER);
            yield HomePageLoading();
            yield HomePageLoaded(homePageData: refreshedHomePageData);
          } catch (error) {
            //DON'T YIELD ERROR  BECAUSE CACHE IS FETCHED
          }
        }
      } catch (error) {
        try {
          //REFRESH CACHE_LATER AFTER CACHE ERROR
          final HomePageData refreshedHomePageData = await homeDataRepository
              .getHomeData(AppCacheStrategy.CACHE_LATER);
          yield HomePageLoading();
          yield HomePageLoaded(homePageData: refreshedHomePageData);
        } catch (error) {
          yield HomePageLoadingError(error: error.toString());
        }
      }
    } else if (event is ReLoadHomePageEvent) {
      //yield HomePageLoading();
      try {
        //REFRESH
        final HomePageData refreshedHomePageData =
            await homeDataRepository.getHomeData(AppCacheStrategy.CACHE_LATER);
        yield HomePageLoading();
        yield HomePageLoaded(homePageData: refreshedHomePageData);
      } catch (error) {
        yield HomePageLoadingError(error: error.toString());
      }
    } else if (event is CancelHomePageRequestEvent) {
      homeDataRepository.cancelDio();
    }
  }

  bool isFromCatch(Response response) {
    if (response.extra['@fromNetwork@'] == null) return true;
    return !response.extra['@fromNetwork@'];
  }
}
