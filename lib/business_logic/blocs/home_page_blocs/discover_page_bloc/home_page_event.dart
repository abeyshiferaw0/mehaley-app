part of 'home_page_bloc.dart';

@immutable
abstract class HomePageEvent extends Equatable {}

class LoadHomePageEvent extends HomePageEvent {
  @override
  List<Object?> get props => [];
}

class ReLoadHomePageEvent extends HomePageEvent {
  @override
  List<Object?> get props => [];
}

class CancelHomePageRequestEvent extends HomePageEvent {
  @override
  List<Object?> get props => [];
}
