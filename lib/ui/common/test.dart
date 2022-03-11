import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/yenepay/yenepay_payment_launcher_listener_bloc/yenepay_payment_launcher_listener_bloc.dart';
import 'package:mehaley/ui/common/testTwo.dart';

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: BlocProvider<YenepayPaymentLauncherListenerBloc>(
          create: (context) => YenepayPaymentLauncherListenerBloc(),
          child: TestTwoWidget(),
        ),
      ),
    );
  }
}
