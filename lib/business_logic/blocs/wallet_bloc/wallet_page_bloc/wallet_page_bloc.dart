import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/api_response/wallet_page_data.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/repositories/wallet_data_repository.dart';

part 'wallet_page_event.dart';
part 'wallet_page_state.dart';

class WalletPageBloc extends Bloc<WalletPageEvent, WalletPageState> {
  WalletPageBloc({required this.walletDataRepository})
      : super(WalletPageInitial());

  final WalletDataRepository walletDataRepository;

  @override
  Stream<WalletPageState> mapEventToState(
    WalletPageEvent event,
  ) async* {
    if (event is LoadWalletPageEvent) {
      //LOAD CACHE AND REFRESH
      yield WalletPageLoadingState();

      try {
        //YIELD CACHE DATA
        final WalletPageData walletPageData = await walletDataRepository
            .getWalletData(AppCacheStrategy.LOAD_CACHE_FIRST);
        yield WalletPageLoadedState(
          walletPageData: walletPageData,
          showFreshBillDialog: false,
        );

        if (isFromCatch(walletPageData.response)) {
          try {
            //REFRESH AFTER CACHE YIELD
            final WalletPageData walletPageData =
                await walletDataRepository.getWalletData(
              AppCacheStrategy.CACHE_LATER,
            );

            ///IF NOT FROM CACHE AND FRESH BILL AVAILABLE LET FRESH WALLET BILL CUBIT SHOW DIALOG
            yield WalletPageLoadingState();
            yield WalletPageLoadedState(
              walletPageData: walletPageData,
              showFreshBillDialog:
                  walletPageData.freshBill != null ? true : false,
            );
          } catch (error) {
            //DON'T YIELD ERROR  BECAUSE CACHE IS FETCHED
          }
        }
      } catch (error) {
        yield WalletPageLoadingErrorState(error: error.toString());
      }
    } else if (event is RefreshWalletPageEvent) {
      yield WalletPageLoadingState();
      try {
        final WalletPageData walletPageData =
            await walletDataRepository.getWalletData(
          AppCacheStrategy.CACHE_LATER,
        );

        ///IF NOT FROM CACHE AND FRESH BILL AVAILABLE LET FRESH WALLET BILL CUBIT SHOW DIALOG
        yield WalletPageLoadingState();
        yield WalletPageLoadedState(
          walletPageData: walletPageData,
          showFreshBillDialog: walletPageData.freshBill != null ? true : false,
        );
      } catch (error) {
        yield WalletPageLoadingErrorState(error: error.toString());
      }
    } else if (event is UpdateWalletPageEvent) {
      print(
          "WalletPageBloc => UpdateWalletPageEvent ${event.walletPageData.activeBill == null ? 'null' : event.walletPageData.activeBill!.wbcCode}");
      yield WalletPageLoadingState();
      yield WalletPageLoadedState(
        walletPageData: event.walletPageData,
        showFreshBillDialog: false,
      );
    }
  }

  bool isFromCatch(Response response) {
    if (response.extra['@fromNetwork@'] == null) return true;
    return !response.extra['@fromNetwork@'];
  }
}
