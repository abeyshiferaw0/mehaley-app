part of 'one_signal_bloc.dart';

abstract class OneSignalState extends Equatable {
  const OneSignalState();
}

class OneSignalInitial extends OneSignalState {
  @override
  List<Object> get props => [];
}

class OneSignalTagAdding extends OneSignalState {
  @override
  List<Object> get props => [];
}

class OneSignalTagAddingError extends OneSignalState {
  final String error;

  OneSignalTagAddingError({required this.error});
  @override
  List<Object> get props => [error];
}

class OneSignalTagAdded extends OneSignalState {
  @override
  List<Object> get props => [];
}
