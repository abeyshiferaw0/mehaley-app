import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class TestThree extends StatefulWidget {
  const TestThree({Key? key}) : super(key: key);

  @override
  _TestThreeState createState() => _TestThreeState();
}

class _TestThreeState extends State<TestThree> {
  late StreamSubscription _subscription;

  @override
  void initState() {
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      print("InAppPurchaseee=> ${purchaseDetailsList}");
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
    initInApp();
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void initInApp() async {
    final bool available = await InAppPurchase.instance.isAvailable();
    print("InAppPurchaseee=> available ${available}");
    if (available) {
      // Set literals require Dart 2.2. Alternatively, use
// `Set<String> _kIds = <String>['product1', 'product2'].toSet()`.
      const Set<String> _kIds = <String>{'mehaleye.mezmur.purchase.1'};
      final ProductDetailsResponse response =
          await InAppPurchase.instance.queryProductDetails(_kIds);
      if (response.notFoundIDs.isNotEmpty) {
        // Handle the error.
      }

      List<ProductDetails> products = response.productDetails;
      print("InAppPurchaseee=> products ${products[0].toString()}");

      final ProductDetails productDetails =
          products[0]; // Saved earlier from queryProductDetails().
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: productDetails);
      await InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
      //  InAppPurchase.instance.completePurchase(purchaseParam);
    }
  }
}
