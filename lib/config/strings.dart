import 'package:mehaley/config/constants.dart';

class AppStrings {
  static const appNotificationChannelName = 'Mehaleye';

  ///FOR PRODUCTION
  //static const String oneSignalId = '53f213b2-7191-4648-8ed1-45ead718045c';
  ///FOR TESTING
  //static const String oneSignalId = '187c0055-162e-417e-88b1-626d3789c76c';

  ///BASED ON BUILD TYPE
  static const String oneSignalId = AppValues.kisDebug
      ? '187c0055-162e-417e-88b1-626d3789c76c'
      : '53f213b2-7191-4648-8ed1-45ead718045c';
}
