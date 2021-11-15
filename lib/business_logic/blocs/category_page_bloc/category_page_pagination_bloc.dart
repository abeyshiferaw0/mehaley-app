import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/repositories/category_data_repository.dart';
import 'package:meta/meta.dart';

part 'category_page_pagination_event.dart';
part 'category_page_pagination_state.dart';

class CategoryPagePaginationBloc
    extends Bloc<CategoryPagePaginationEvent, CategoryPagePaginationState> {
  CategoryPagePaginationBloc({required this.categoryDataRepository})
      : super(CategoryPagePaginationInitial());

  final CategoryDataRepository categoryDataRepository;

  @override
  Future<void> close() {
    categoryDataRepository.cancelDio();
    return super.close();
  }

  @override
  Stream<CategoryPagePaginationState> mapEventToState(
    CategoryPagePaginationEvent event,
  ) async* {
    if (event is LoadCategoryPagePaginatedEvent) {
      yield CategoryPagePaginatedLoading();
      try {
        List<Song> songs = await categoryDataRepository.getCategorySongData(
            event.categoryId, event.page, event.pageSize);
        yield CategoryPagePaginatedLoaded(songs: songs, page: event.page);
      } catch (e) {
        yield CategoryPagePaginatedLoadingError(error: e.toString());
      }
    }
  }
}
