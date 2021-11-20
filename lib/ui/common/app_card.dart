import 'package:flutter/material.dart';
import 'package:mehaley/config/themes.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final double? radius;
  final BoxConstraints? constraints;
  final bool? withShadow;

  const AppCard(
      {required this.child, this.radius, this.constraints, this.withShadow});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          radius != null ? radius! : 0.0,
        ),
        child: child,
      ),
      constraints: constraints,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius != null ? radius! : 0.0),
        boxShadow: withShadow == null
            ? [
                BoxShadow(
                  blurRadius: 4,
                  spreadRadius: 2,
                  color: AppColors.black.withOpacity(0.1),
                  offset: Offset(0, 0),
                ),
              ]
            : withShadow!
                ? [
                    BoxShadow(
                      blurRadius: 2,
                      spreadRadius: 1,
                      color: AppColors.black.withOpacity(0.1),
                      offset: Offset(0, 0),
                    ),
                  ]
                : null,
      ),
    );
  }
}
