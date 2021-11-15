import 'package:flutter/material.dart';
import 'package:mehaley/ui/common/app_gradients.dart';

class SearchHeaderGradient extends StatelessWidget {
  final double height;
  final Color color;

  SearchHeaderGradient({required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
          gradient: AppGradients().getSearchHeaderGradient(color)),
    );
  }
}
