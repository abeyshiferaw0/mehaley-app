part of 'share_buttons_bloc.dart';

abstract class ShareButtonsState extends Equatable {
  const ShareButtonsState();
}

class ShareInitial extends ShareButtonsState {
  @override
  List<Object> get props => [];
}

class SharingState extends ShareButtonsState {
  @override
  List<Object> get props => [];
}

class LyricSharedDoneState extends ShareButtonsState {
  @override
  List<Object> get props => [];
}

class SharingErrorState extends ShareButtonsState {
  final String error;

  SharingErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
