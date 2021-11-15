import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mehaley/config/themes.dart';

class AppLoading extends StatefulWidget {
  const AppLoading({required this.size, this.strokeWidth = 5});

  final double size;
  final double strokeWidth;

  @override
  AppLoadingState createState() =>
      AppLoadingState(size: size, strokeWidth: strokeWidth);
}

class AppLoadingState extends State<AppLoading> {
  final double size;
  final double strokeWidth;

  AppLoadingState({required this.strokeWidth, required this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size,
        height: size,
        child: Lottie.asset(
          'assets/lottie/loading.json',
          fit: BoxFit.cover,
        ),
        // child: CircularProgressIndicator(
        //   color: AppColors.darkGreen,
        //   strokeWidth: strokeWidth,
        // ),
      ),
    );
  }
}
