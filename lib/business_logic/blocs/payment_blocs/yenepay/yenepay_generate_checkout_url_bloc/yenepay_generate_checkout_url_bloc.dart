import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/repositories/yenepay_purchase_repository.dart';
import 'package:mehaley/util/auth_util.dart';

part 'yenepay_generate_checkout_url_event.dart';
part 'yenepay_generate_checkout_url_state.dart';

class YenepayGenerateCheckoutUrlBloc extends Bloc<
    YenepayGenerateCheckoutUrlEvent, YenepayGenerateCheckoutUrlState> {
  YenepayGenerateCheckoutUrlBloc({required this.yenepayPurchaseRepository})
      : super(YenepayGenerateCheckoutUrlInitial());

  final YenepayPurchaseRepository yenepayPurchaseRepository;

  @override
  Stream<YenepayGenerateCheckoutUrlState> mapEventToState(
      YenepayGenerateCheckoutUrlEvent event) async* {
    if (event is GenerateCheckoutUrlEvent) {
      yield YenepayCheckoutUrlGeneratingState();
      try {
        ///GET USER ID
        String userId = AuthUtil.getUserId();

        ///GENERATE YENEPAY CHECKOUT URL
        final String checkoutUrl =
            await yenepayPurchaseRepository.generateCheckoutUrl(
          event.itemId,
          event.itemNameEn,
          event.price,
          event.appPurchasedItemType,
          userId,
        );
        yield YenepayCheckoutUrlGeneratedState(checkoutUrl: checkoutUrl);
      } catch (e) {
        yield YenepayCheckoutUrlGeneratingErrorState(error: e.toString());
      }
    }
  }
}
