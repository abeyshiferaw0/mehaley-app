// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
//
// class TestThree extends StatefulWidget {
//   const TestThree({Key? key}) : super(key: key);
//
//   @override
//   _TestThreeState createState() => _TestThreeState();
// }
//
// class _TestThreeState extends State<TestThree> {
//   late StreamSubscription _subscription;
//
//   @override
//   void initState() {
//     final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
//     _subscription = purchaseUpdated.listen((purchaseDetailsList) {
//       //print("InAppPurchaseee=> ${purchaseDetailsList}");
//       _listenToPurchaseUpdated(purchaseDetailsList);
//     }, onDone: () {
//       _subscription.cancel();
//     }, onError: (error) {
//       // handle error here.
//     });
//     initInApp();
//     super.initState();
//   }
//
//   void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
//     purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
//       if (purchaseDetails.status == PurchaseStatus.pending) {
//         // _showPendingUI();
//         //print("InAppPurchaseee=> UPDATE=> PENDING");
//       } else {
//         if (purchaseDetails.status == PurchaseStatus.error) {
//           //print("InAppPurchaseee=> UPDATE=> ERROR");
//           //_handleError(purchaseDetails.error!);
//         } else if (purchaseDetails.status == PurchaseStatus.purchased ||
//             purchaseDetails.status == PurchaseStatus.restored) {
//           // bool valid = await _verifyPurchase(purchaseDetails);
//           // if (valid) {
//           //   _deliverProduct(purchaseDetails);
//           // } else {
//           //   _handleInvalidPurchase(purchaseDetails);
//           // }
//           print(
//               "InAppPurchaseee=> UPDATE=> purchased OR restored ${purchaseDetails.purchaseID}");
//         }
//         if (purchaseDetails.pendingCompletePurchase) {
//           await InAppPurchase.instance.completePurchase(purchaseDetails);
//           //print("InAppPurchaseee=> UPDATE=> pendingCompletePurchase");
//         }
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
//
//   void initInApp() async {
//     final bool available = await InAppPurchase.instance.isAvailable();
//     //print("InAppPurchaseee=> available ${available}");
//     if (available) {
//       // Set literals require Dart 2.2. Alternatively, use
// // `Set<String> _kIds = <String>['product1', 'product2'].toSet()`.
//       const Set<String> _kIds = <String>{'mehaleye.mezmur.purchase.1'};
//       final ProductDetailsResponse response =
//           await InAppPurchase.instance.queryProductDetails(_kIds);
//       if (response.notFoundIDs.isNotEmpty) {
//         // Handle the error.
//       }
//
//       List<ProductDetails> products = response.productDetails;
//
//       //print("InAppPurchaseee=> products ${products.length}");
//       //print("InAppPurchaseee=> products iddd ${products[0].id}");
//
//       final ProductDetails productDetails =
//           products[0]; // Saved earlier from queryProductDetails().
//       final PurchaseParam purchaseParam =
//           PurchaseParam(productDetails: productDetails);
//       await InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
//     }
//   }
// }
