import 'package:elf_play/config/themes.dart';
import 'package:flutter/material.dart';

class ShimmerItem extends StatelessWidget {
  const ShimmerItem(
      {Key? key,
      required this.width,
      required this.height,
      required this.radius})
      : super(key: key);

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        width: width,
        height: height,
        color: AppColors.grey,
      ),
    );
  }
}
