import 'package:elf_play/config/themes.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final double? radius;
  final BoxConstraints? constraints;

  const AppCard({required this.child, this.radius, this.constraints});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
          borderRadius: BorderRadius.circular(
            radius != null ? radius! : 0.0,
          ),
          child: child),
      constraints: constraints,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius != null ? radius! : 0.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            spreadRadius: 4,
            color: AppColors.completelyBlack.withOpacity(0.1),
            offset: Offset(0, 0),
          ),
        ],
      ),
    );
  }
}
