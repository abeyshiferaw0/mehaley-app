import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/models/api_response/category_page_top_data.dart';
import 'package:elf_play/data/repositories/category_data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'category_page_event.dart';
part 'category_page_state.dart';

class CategoryPageBloc extends Bloc<CategoryPageEvent, CategoryPageState> {
  CategoryPageBloc({required this.categoryDataRepository}) : super(CategoryPageInitial());

  final CategoryDataRepository categoryDataRepository;

  @override
  Future<void> close() {
    categoryDataRepository.cancelDio();
    return super.close();
  }

  @override
  Stream<CategoryPageState> mapEventToState(
    CategoryPageEvent event,
  ) async* {
    if (event is LoadCategoryPageTopEvent) {
      yield CategoryPageTopLoading();
      try {
        //YIELD CACHE DATA
        final CategoryPageTopData categoryPageTopData =
            await categoryDataRepository.getCategoryTopData(event.categoryId, AppCacheStrategy.LOAD_CACHE_FIRST);
        yield CategoryPageTopLoaded(categoryPageTopData: categoryPageTopData);

        if (isFromCatch(categoryPageTopData.response)) {
          try {
            yield CategoryPageTopLoading();
            //REFRESH AFTER CACHE YIELD
            final CategoryPageTopData categoryPageTopData =
                await categoryDataRepository.getCategoryTopData(event.categoryId, AppCacheStrategy.CACHE_LATER);
            yield CategoryPageTopLoaded(
              categoryPageTopData: categoryPageTopData,
            );
          } catch (error) {
            //DON'T YIELD ERROR  BECAUSE CACHE IS FETCHED
          }
        }
      } catch (error) {
        yield CategoryPageTopLoadingError(error: error.toString());
      }
    }
  }

  bool isFromCatch(Response response) {
    if (response.extra['@fromNetwork@'] == null) return true;
    return !response.extra['@fromNetwork@'];
  }
}
