import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class AppPermission extends Equatable {
  final String permissionMsg;
  final IconData icon;

  AppPermission(this.permissionMsg, this.icon);

  @override
  List<Object?> get props => [permissionMsg, icon];
}
