import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          width: 300,
          height: 500,
          child: WebView(
            initialUrl: 'www.google.com',
          ),
        ),
      ),
    );
  }
}
