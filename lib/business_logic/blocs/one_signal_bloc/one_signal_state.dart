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

class NotificationClickedState extends OneSignalState {
  final int itemId;
  final AppItemsType itemType;

  NotificationClickedState({required this.itemId, required this.itemType});

  @override
  List<Object> get props => [itemId, itemType];
}

class NotificationClickedErrorState extends OneSignalState {
  final String error;

  NotificationClickedErrorState({required this.error});
  @override
  List<Object> get props => [error];
}

class NotificationActionClickedState extends OneSignalState {
  final String actionId;
  final String billCode;

  NotificationActionClickedState(
      {required this.actionId, required this.billCode});

  @override
  List<Object?> get props => [billCode, actionId];
}
