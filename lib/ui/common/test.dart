import 'package:flutter/material.dart';
import 'package:mehaley/ui/common/testThree.dart';

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: TestThree(),
      ),
    );
  }
}
