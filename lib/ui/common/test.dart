import 'package:elf_play/ui/common/testThree.dart';
import 'package:flutter/material.dart';

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TestApp(),
    );
  }
}

class TestApp extends StatelessWidget {
  const TestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///DEBUG USE FORM CONSTOCTOR
    return TestWidgetThree();
  }
}
