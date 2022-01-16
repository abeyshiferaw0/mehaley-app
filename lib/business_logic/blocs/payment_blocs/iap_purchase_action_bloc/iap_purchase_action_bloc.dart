import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/enums/enums.dart';

part 'iap_purchase_action_event.dart';
part 'iap_purchase_action_state.dart';

class IapPurchaseActionBloc
    extends Bloc<IapPurchaseActionEvent, IapPurchaseActionState> {
  IapPurchaseActionBloc() : super(IapPurchaseActionInitial());

  @override
  Stream<IapPurchaseActionState> mapEventToState(
      IapPurchaseActionEvent event) async* {
    if (event is IapSongPurchaseActionEvent) {
      yield IapSongPurchaseActionState(
        itemId: event.itemId,
        appPurchasedSources: event.appPurchasedSources,
      );
      yield IapPurchaseActionInitial();
    } else if (event is IapAlbumPurchaseActionEvent) {
      yield IapAlbumPurchaseActionState(
        itemId: event.itemId,
        isFromSelfPage: event.isFromSelfPage,
        appPurchasedSources: event.appPurchasedSources,
      );
      yield IapPurchaseActionInitial();
    } else if (event is IapPlaylistPurchaseActionEvent) {
      yield IapPlaylistPurchaseActionState(
        itemId: event.itemId,
        isFromSelfPage: event.isFromSelfPage,
        appPurchasedSources: event.appPurchasedSources,
      );
      yield IapPurchaseActionInitial();
    }
  }
}
