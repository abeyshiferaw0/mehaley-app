import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/api_response/search_page_front_data.dart';
import 'package:mehaley/data/repositories/search_data_repository.dart';
import 'package:meta/meta.dart';

part 'search_front_page_event.dart';
part 'search_front_page_state.dart';

class SearchFrontPageBloc
    extends Bloc<SearchFrontPageEvent, SearchFrontPageState> {
  SearchFrontPageBloc({required this.searchDataRepository})
      : super(SearchFrontPageInitial());

  final SearchDataRepository searchDataRepository;

  @override
  Future<void> close() {
    searchDataRepository.cancelDio();
    return super.close();
  }

  @override
  Stream<SearchFrontPageState> mapEventToState(
    SearchFrontPageEvent event,
  ) async* {
    if (event is LoadSearchFrontPageEvent) {
      //LOAD CACHE AND REFRESH
      yield SearchFrontPageLoadingState();
      try {
        //YIELD CACHE DATA
        final SearchPageFrontData searchPageFrontData =
            await searchDataRepository.getSearchFrontPageData(
          AppCacheStrategy.LOAD_CACHE_FIRST,
        );
        yield SearchFrontPageLoadedState(
            searchPageFrontData: searchPageFrontData);
        if (isFromCatch(searchPageFrontData.response)) {
          try {
            //REFRESH AFTER CACHE YIELD
            final SearchPageFrontData searchPageFrontData =
                await searchDataRepository.getSearchFrontPageData(
              AppCacheStrategy.CACHE_LATER,
            );
            yield SearchFrontPageLoadingState();
            yield SearchFrontPageLoadedState(
                searchPageFrontData: searchPageFrontData);
          } catch (error) {
            //DON'T YIELD ERROR  BECAUSE CACHE IS FETCHED
          }
        }
      } catch (error) {
        yield SearchFrontPageLoadingErrorState(error: error.toString());
      }
    } else if (event is CancelSearchFrontPageEvent) {
      searchDataRepository.cancelDio();
    }
  }

  bool isFromCatch(Response response) {
    if (response.extra['@fromNetwork@'] == null) return true;
    return !response.extra['@fromNetwork@'];
  }
}
