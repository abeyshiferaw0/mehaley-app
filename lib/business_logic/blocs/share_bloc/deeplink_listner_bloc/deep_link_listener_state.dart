part of 'deep_link_listener_bloc.dart';

abstract class DeepLinkListenerState extends Equatable {
  const DeepLinkListenerState();
}

class DeepLinkListenerInitial extends DeepLinkListenerState {
  @override
  List<Object> get props => [];
}

class DeepLinkListenerStartedState extends DeepLinkListenerState {
  @override
  List<Object> get props => [];
}

class DeepLinkErrorState extends DeepLinkListenerState {
  final String error;

  DeepLinkErrorState({required this.error});

  @override
  List<Object> get props => [error];
}

class DeepLinkOpenState extends DeepLinkListenerState {
  final AppShareTypes appShareTypes;
  final int itemId;

  DeepLinkOpenState({required this.appShareTypes, required this.itemId});

  @override
  List<Object> get props => [appShareTypes, itemId];
}
