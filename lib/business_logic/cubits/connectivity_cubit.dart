import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityCubit extends Cubit<ConnectivityResult> {
  late StreamSubscription streamSubscription;
  final Connectivity connectivity;

  ConnectivityCubit({required this.connectivity})
      : super(ConnectivityResult.none) {
    streamSubscription = connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        emit(result);
      },
    );
    checkConnectivity();
  }

  checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    emit(connectivityResult);
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }
}
