import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/app_ad.dart';

class AppAdData extends Equatable {
  final List<AppAd> appAdList;

  final Response response;

  const AppAdData({
    required this.response,
    required this.appAdList,
  });

  @override
  List<Object?> get props => [
        appAdList,
        response,
      ];
}
