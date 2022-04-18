import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/repositories/home_data_repository.dart';

part 'all_albums_page_event.dart';
part 'all_albums_page_state.dart';

class AllAlbumsPageBloc extends Bloc<AllAlbumsPageEvent, AllAlbumsPageState> {
  AllAlbumsPageBloc({required this.homeDataRepository})
      : super(AllAlbumsPageInitial());

  final HomeDataRepository homeDataRepository;

  @override
  Stream<AllAlbumsPageState> mapEventToState(
    AllAlbumsPageEvent event,
  ) async* {
    if (event is LoadAllPaginatedAlbumsEvent) {
      yield AllPaginatedAlbumsLoadingState();

      try {
        final List<Album> paginatedAlbums =
            await homeDataRepository.getPaginatedAllAlbums(
          event.page,
          event.pageSize,
        );

        ///YIELD BASED ON PAGE
        yield AllPaginatedAlbumsLoadedState(
          paginatedAlbums: paginatedAlbums,
          page: event.page,
        );
      } catch (error) {
        yield AllPaginatedAlbumsLoadingErrorState(
          error: error.toString(),
        );
      }
    }
  }
}
