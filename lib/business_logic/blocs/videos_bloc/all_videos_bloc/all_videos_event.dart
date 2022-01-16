part of 'all_videos_bloc.dart';

abstract class AllVideosEvent extends Equatable {
  const AllVideosEvent();
}

class LoadAllVideosEvent extends AllVideosEvent {
  const LoadAllVideosEvent({required this.pageSize, required this.page});

  final int pageSize;
  final int page;

  @override
  List<Object?> get props => [pageSize, page];
}
