import 'package:flutter/services.dart';

class StatusBarUtil {
  void hideStatusBar(bool withAnimation) async {
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  void showStatusBar(bool withAnimation) async {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }
}
