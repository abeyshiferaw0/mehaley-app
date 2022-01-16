part of 'other_videos_bloc.dart';

abstract class OtherVideosEvent extends Equatable {
  const OtherVideosEvent();
}

class LoadOtherVideosEvent extends OtherVideosEvent {
  const LoadOtherVideosEvent({required this.id});

  final int id;

  @override
  List<Object?> get props => [id];
}
