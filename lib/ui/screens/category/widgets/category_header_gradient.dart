import 'package:elf_play/ui/common/app_gradients.dart';
import 'package:flutter/material.dart';

class CategoryHeaderGradient extends StatelessWidget {
  final double height;
  final Color color;

  CategoryHeaderGradient({required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
          gradient: AppGradients().getCategoryHeaderGradient(color)),
    );
  }
}
