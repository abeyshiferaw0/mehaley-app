part of 'share_bloc.dart';

abstract class ShareState extends Equatable {
  const ShareState();
}

class ShareInitial extends ShareState {
  @override
  List<Object> get props => [];
}

class SharingState extends ShareState {
  @override
  List<Object> get props => [];
}

class LyricSharedDoneState extends ShareState {
  @override
  List<Object> get props => [];
}

class SharingErrorState extends ShareState {
  final String error;

  SharingErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
