import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/repositories/telebirr_purchase_repository.dart';

part 'telebirr_generate_checkout_url_event.dart';
part 'telebirr_generate_checkout_url_state.dart';

class TelebirrGenerateCheckoutUrlBloc extends Bloc<
    TelebirrGenerateCheckoutUrlEvent, TelebirrGenerateCheckoutUrlState> {
  TelebirrGenerateCheckoutUrlBloc({required this.telebirrPurchaseRepository})
      : super(TelebirrGenerateCheckoutUrlInitial());

  final TelebirrPurchaseRepository telebirrPurchaseRepository;

  @override
  Stream<TelebirrGenerateCheckoutUrlState> mapEventToState(
      TelebirrGenerateCheckoutUrlEvent event) async* {
    if (event is GenerateCheckoutUrlEvent) {
      yield TelebirrCheckoutUrlGeneratingState();
      try {
        ///GENERATE TELEBIRR CHECKOUT URL
        final String checkoutUrl =
            await telebirrPurchaseRepository.generateCheckoutUrl(
          event.itemId,
          event.appPurchasedItemType,
        );
        yield TelebirrCheckoutUrlGeneratedState(checkoutUrl: checkoutUrl);
      } catch (e) {
        yield TelebirrCheckoutUrlGeneratingErrorState(error: e.toString());
      }
    }
  }
}
