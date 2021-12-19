part of 'newer_version_bloc.dart';

abstract class NewerVersionEvent extends Equatable {
  const NewerVersionEvent();
}

class ShouldShowNewVersionDialogEvent extends NewerVersionEvent {
  @override
  List<Object?> get props => [];
}
