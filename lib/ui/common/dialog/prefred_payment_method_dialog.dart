// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_remix/flutter_remix.dart';
// import 'package:mehaley/app_language/app_locale.dart';
// import 'package:mehaley/business_logic/blocs/payment_blocs/preferred_payment_method_bloc/preferred_payment_method_bloc.dart';
// import 'package:mehaley/config/constants.dart';
// import 'package:mehaley/config/themes.dart';
// import 'package:mehaley/data/models/enums/app_payment_methods.dart';
// import 'package:mehaley/ui/common/dialog/widgets/payment_item.dart';
// import 'package:mehaley/util/pages_util_functions.dart';
// import 'package:mehaley/util/screen_util.dart';
// import 'package:sizer/sizer.dart';
//
// import '../app_bouncing_button.dart';
//
// class PreferredPaymentDialog extends StatefulWidget {
//   const PreferredPaymentDialog({Key? key}) : super(key: key);
//
//   @override
//   State<PreferredPaymentDialog> createState() => _PreferredPaymentDialogState();
// }
//
// class _PreferredPaymentDialogState extends State<PreferredPaymentDialog> {
//   late AppPaymentMethods tempAppPaymentMethods;
//
//   @override
//   void initState() {
//     tempAppPaymentMethods = AppPaymentMethods.METHOD_UNK;
//     BlocProvider.of<PreferredPaymentMethodBloc>(context).add(
//       LoadPreferredPaymentMethodEvent(),
//     );
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Wrap(
//         children: [
//           Container(
//             height: ScreenUtil(context: context).getScreenHeight() * 0.8,
//             margin: EdgeInsets.symmetric(
//               horizontal: AppMargin.margin_16,
//             ),
//             decoration: BoxDecoration(
//               color: AppColors.white,
//               borderRadius: BorderRadius.circular(6),
//             ),
//             padding: EdgeInsets.all(
//               AppPadding.padding_16,
//             ),
//             child: BlocBuilder<PreferredPaymentMethodBloc,
//                 PreferredPaymentMethodState>(
//               builder: (context, state) {
//                 if (state is PreferredPaymentMethodLoadedState) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       buildDialogHeader(context),
//                       SizedBox(
//                         height: AppMargin.margin_16,
//                       ),
//                       buildPaymentMethodsList(state.appPaymentMethod),
//                       SizedBox(
//                         height: AppMargin.margin_20,
//                       ),
//                       state.appPaymentMethod != AppPaymentMethods.METHOD_UNK
//                           ? buildCurrentlySelected(state.appPaymentMethod)
//                           : SizedBox(),
//                       buildSaveButton(),
//                     ],
//                   );
//                 } else {
//                   return SizedBox();
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Column buildCurrentlySelected(AppPaymentMethods appPaymentMethod) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           AppLocale.of().currentlySeletced.toUpperCase(),
//           style: TextStyle(
//             color: AppColors.txtGrey,
//             fontWeight: FontWeight.w600,
//             fontSize: AppFontSizes.font_size_8.sp,
//           ),
//         ),
//         SizedBox(
//           height: AppMargin.margin_16,
//         ),
//         PaymentMethodItem(
//           title: PagesUtilFunctions.getPaymentMethodName(
//             appPaymentMethod,
//             context,
//           ),
//           imagePath: PagesUtilFunctions.getPaymentMethodIcon(appPaymentMethod),
//           scale: 0.8,
//           isSelected: true,
//           appPaymentMethods: appPaymentMethod,
//           onTap: () {},
//         ),
//         SizedBox(
//           height: AppMargin.margin_20,
//         ),
//       ],
//     );
//   }
//
//   AppBouncingButton buildSaveButton() => AppBouncingButton(
//         onTap: () {
//           if (tempAppPaymentMethods == AppPaymentMethods.METHOD_UNK) {
//           } else {
//             BlocProvider.of<PreferredPaymentMethodBloc>(context).add(
//               SetPreferredPaymentMethodEvent(
//                 appPaymentMethods: tempAppPaymentMethods,
//               ),
//             );
//             Navigator.pop(context);
//           }
//         },
//         child: Container(
//           padding: EdgeInsets.symmetric(
//             horizontal: AppPadding.padding_32,
//             vertical: AppPadding.padding_20,
//           ),
//           decoration: BoxDecoration(
//             color: tempAppPaymentMethods == AppPaymentMethods.METHOD_UNK
//                 ? AppColors.txtGrey
//                 : AppColors.darkOrange,
//             borderRadius: BorderRadius.circular(40),
//           ),
//           child: Center(
//             child: Text(
//               AppLocale.of().selectPaymentMethod.toUpperCase(),
//               style: TextStyle(
//                 color: AppColors.white,
//                 fontWeight: FontWeight.w600,
//                 fontSize: AppFontSizes.font_size_10.sp,
//               ),
//             ),
//           ),
//         ),
//       );
//
//   Expanded buildPaymentMethodsList(AppPaymentMethods paymentMethod) {
//     return Expanded(
//       child: ShaderMask(
//         blendMode: BlendMode.dstOut,
//         shaderCallback: (Rect bounds) {
//           return LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               AppColors.black,
//               Colors.transparent,
//               Colors.transparent,
//               AppColors.black,
//             ],
//             stops: [0.0, 0.03, 0.98, 1.0],
//           ).createShader(bounds);
//         },
//         child: SingleChildScrollView(
//           physics: BouncingScrollPhysics(),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 height: AppMargin.margin_16,
//               ),
//               PaymentMethodItem(
//                 title: AppLocale.of().amole,
//                 imagePath: AppAssets.icAmole,
//                 scale: 1.0,
//                 isSelected:
//                     tempAppPaymentMethods == AppPaymentMethods.METHOD_AMOLE,
//                 appPaymentMethods: AppPaymentMethods.METHOD_AMOLE,
//                 onTap: () {
//                   setState(() {
//                     tempAppPaymentMethods = AppPaymentMethods.METHOD_AMOLE;
//                   });
//                 },
//               ),
//               SizedBox(
//                 height: AppMargin.margin_16,
//               ),
//               PaymentMethodItem(
//                 title: AppLocale.of().cbeBirr,
//                 imagePath: AppAssets.icCbeBirr,
//                 scale: 1.0,
//                 isSelected:
//                     tempAppPaymentMethods == AppPaymentMethods.METHOD_CBE_BIRR,
//                 appPaymentMethods: AppPaymentMethods.METHOD_CBE_BIRR,
//                 onTap: () {
//                   setState(() {
//                     tempAppPaymentMethods = AppPaymentMethods.METHOD_CBE_BIRR;
//                   });
//                 },
//               ),
//               SizedBox(
//                 height: AppMargin.margin_16,
//               ),
//               PaymentMethodItem(
//                 title: AppLocale.of().cbeBirr,
//                 imagePath: AppAssets.icHelloCash,
//                 scale: 0.8,
//                 isSelected: tempAppPaymentMethods ==
//                     AppPaymentMethods.METHOD_HELLO_CASH,
//                 appPaymentMethods: AppPaymentMethods.METHOD_HELLO_CASH,
//                 onTap: () {
//                   setState(() {
//                     tempAppPaymentMethods = AppPaymentMethods.METHOD_HELLO_CASH;
//                   });
//                 },
//               ),
//               SizedBox(
//                 height: AppMargin.margin_16,
//               ),
//               PaymentMethodItem(
//                 title: AppLocale.of().mbirr,
//                 imagePath: AppAssets.icMbirr,
//                 scale: 1.3,
//                 isSelected:
//                     tempAppPaymentMethods == AppPaymentMethods.METHOD_MBIRR,
//                 appPaymentMethods: AppPaymentMethods.METHOD_MBIRR,
//                 onTap: () {
//                   setState(() {
//                     tempAppPaymentMethods = AppPaymentMethods.METHOD_MBIRR;
//                   });
//                 },
//               ),
//               SizedBox(
//                 height: AppMargin.margin_16,
//               ),
//               PaymentMethodItem(
//                 title: AppLocale.of().visa,
//                 imagePath: AppAssets.icVisa,
//                 scale: 1.0,
//                 isSelected:
//                     tempAppPaymentMethods == AppPaymentMethods.METHOD_VISA,
//                 appPaymentMethods: AppPaymentMethods.METHOD_VISA,
//                 onTap: () {
//                   setState(() {
//                     tempAppPaymentMethods = AppPaymentMethods.METHOD_VISA;
//                   });
//                 },
//               ),
//               SizedBox(
//                 height: AppMargin.margin_16,
//               ),
//               PaymentMethodItem(
//                 title: AppLocale.of().mastercard,
//                 imagePath: AppAssets.icMasterCard,
//                 scale: 1.0,
//                 isSelected: tempAppPaymentMethods ==
//                     AppPaymentMethods.METHOD_MASTERCARD,
//                 appPaymentMethods: AppPaymentMethods.METHOD_MASTERCARD,
//                 onTap: () {
//                   setState(() {
//                     tempAppPaymentMethods = AppPaymentMethods.METHOD_MASTERCARD;
//                   });
//                 },
//               ),
//               SizedBox(
//                 height: AppMargin.margin_16,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Column buildDialogHeader(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               AppLocale.of().paymentMethod,
//               style: TextStyle(
//                 color: AppColors.black,
//                 fontWeight: FontWeight.w500,
//                 fontSize: AppFontSizes.font_size_12.sp,
//               ),
//             ),
//             Expanded(
//               child: SizedBox(),
//             ),
//             AppBouncingButton(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: Icon(
//                 FlutterRemix.close_line,
//                 color: AppColors.black,
//                 size: AppIconSizes.icon_size_24,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(
//           height: AppMargin.margin_8,
//         ),
//         Text(
//           AppLocale.of().selectYourPrefrredPayment,
//           style: TextStyle(
//             color: AppColors.txtGrey,
//             fontWeight: FontWeight.w400,
//             fontSize: AppFontSizes.font_size_8.sp,
//           ),
//         ),
//       ],
//     );
//   }
// }
