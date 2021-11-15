import 'package:flutter/material.dart';
import 'package:mehaley/config/themes.dart';

class LeftAndRightItemsPlaceHolder extends StatelessWidget {
  const LeftAndRightItemsPlaceHolder({
    required this.index,
    required this.lastIndex,
    required this.item,
  });

  final int index;
  final int lastIndex;
  final Widget item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        index == 0
            ? Container(
                width: AppMargin.margin_16,
              )
            : Container(),
        item,
        index == lastIndex
            ? Container(
                width: AppMargin.margin_16,
              )
            : Container(),
      ],
    );
  }
}
