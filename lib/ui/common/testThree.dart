import 'package:elf_play/config/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TestWidgetThree extends StatefulWidget {
  const TestWidgetThree({Key? key}) : super(key: key);

  @override
  _TestWidgetThreeState createState() => _TestWidgetThreeState();
}

class _TestWidgetThreeState extends State<TestWidgetThree> {
  String id = "";
  Uuid uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$id",
            style: TextStyle(
              fontSize: AppFontSizes.font_size_16,
              color: AppColors.darkGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                id = uuid
                    .v5(Uuid.NAMESPACE_NIL, '12/23/12 00:34:23 5')
                    .toString();
              });
            },
            child: Text(
              "Generate",
              style: TextStyle(
                fontSize: AppFontSizes.font_size_16,
                color: AppColors.darkGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
