import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class TestThree extends StatefulWidget {
  const TestThree({Key? key}) : super(key: key);

  @override
  _TestThreeState createState() => _TestThreeState();
}

class _TestThreeState extends State<TestThree> {
  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  Future<void> initPlatformState() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup("goog_iYQtnabbQMCTZLTLfyBTJroeeUP");
    try {
      Offerings offerings = await Purchases.getOfferings();
      print("offerings=>1  ${offerings.all}");
      if (offerings.current != null) {
        if (offerings.current!.availablePackages.isNotEmpty) {
          print("offerings=>  ${offerings.all}");

          ///
          try {
            PurchaserInfo purchaserInfo = await Purchases.purchasePackage(
                offerings.current!.getPackage('mehaleye.mezmur.purchase.1')!);

            print("offerings=> purchased ${purchaserInfo.toString()}");
          } on PlatformException catch (e) {
            var errorCode = PurchasesErrorHelper.getErrorCode(e);
            if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
              print("offerings=> purcahsee=> error=> ${e.message}");
            }
            print("offerings=> purcahsee=> error 2 => ${e.message}");
          }

          ///
        }
      }
    } on PlatformException catch (e) {
      // optional error handling
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
