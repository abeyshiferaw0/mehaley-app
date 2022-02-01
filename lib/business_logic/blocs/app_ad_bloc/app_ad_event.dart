part of 'app_ad_bloc.dart';

abstract class AppAdEvent extends Equatable {
  const AppAdEvent();
}

class LoadAppAdEvent extends AppAdEvent {
  const LoadAppAdEvent();

  @override
  List<Object?> get props => [];
}
