part of 'deep_link_listener_bloc.dart';

abstract class DeepLinkListenerEvent extends Equatable {
  const DeepLinkListenerEvent();
}

class StartDeepLinkListenerEvent extends DeepLinkListenerEvent {
  @override
  List<Object?> get props => [];
}

class SetDeepLinkListenerErrorEvent extends DeepLinkListenerEvent {
  final String error;

  SetDeepLinkListenerErrorEvent({required this.error});

  @override
  List<Object?> get props => [error];
}

class SetDeepLinkListenerOpenEvent extends DeepLinkListenerEvent {
  final AppShareTypes appShareTypes;
  final int itemId;

  SetDeepLinkListenerOpenEvent(
      {required this.appShareTypes, required this.itemId});

  @override
  List<Object?> get props => [
        appShareTypes,
        itemId,
      ];
}
