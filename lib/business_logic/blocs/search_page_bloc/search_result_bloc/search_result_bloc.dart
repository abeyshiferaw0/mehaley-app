import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/models/api_response/search_page_result_data.dart';
import 'package:elf_play/data/repositories/search_data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'search_result_event.dart';
part 'search_result_state.dart';

class SearchResultBloc extends Bloc<SearchResultEvent, SearchResultState> {
  SearchResultBloc({required this.searchDataRepository})
      : super(SearchResultInitial());

  final SearchDataRepository searchDataRepository;
  final CancelToken searchResultCancelToken = CancelToken();

  @override
  Stream<SearchResultState> mapEventToState(
    SearchResultEvent event,
  ) async* {
    if (event is LoadSearchResultEvent) {
      //FETCH SEARCH QUERY RESULT
      yield SearchResultPageLoadingState();
      try {
        final SearchPageResultData searchPageResultData =
            await searchDataRepository.getSearchResult(
          event.key,
          searchResultCancelToken,
        );
        yield SearchResultPageLoadedState(
          searchPageResultData: searchPageResultData,
          key: event.key,
        );
      } catch (error) {
        yield SearchResultPageLoadingErrorState(
            error: error.toString(), key: event.key);
      }
    } else if (event is LoadSearchResultDedicatedEvent) {
      //FETCH SEARCH QUERY RESULT FOR ONLY ALBUM
      yield SearchResultPageDedicatedLoadingState();
      try {
        final SearchPageResultData searchPageResultData =
            await searchDataRepository.getDedicatedSearchResult(
                event.key, event.appSearchItemTypes);
        yield SearchResultPageDedicatedLoadedState(
          searchPageResultData: searchPageResultData,
          appSearchItemTypes: event.appSearchItemTypes,
        );
      } catch (error) {
        yield SearchResultPageDedicatedLoadingErrorState(
            error: error.toString(), key: event.key);
      }
    } else if (event is CancelSearchFrontPageEvent) {
      searchDataRepository.cancelDio();
    }
  }
}
