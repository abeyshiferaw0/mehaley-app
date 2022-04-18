part of 'home_page_bloc.dart';

@immutable
abstract class HomePageState extends Equatable {}

class HomePageInitial extends HomePageState {
  @override
  List<Object?> get props => [];
}

class HomePageLoading extends HomePageState {
  @override
  List<Object?> get props => [];
}

class HomePageLoaded extends HomePageState {
  final HomePageData homePageData;

  HomePageLoaded({required this.homePageData});

  @override
  List<Object?> get props => [homePageData];
}

class HomePageLoadingError extends HomePageState {
  final String error;

  HomePageLoadingError({required this.error});

  @override
  List<Object?> get props => [error];
}

class HomePageRequestCanceled extends HomePageState {
  @override
  List<Object?> get props => [];
}
