part of 'category_page_bloc.dart';

@immutable
abstract class CategoryPageState extends Equatable {}

class CategoryPageInitial extends CategoryPageState {
  @override
  List<Object?> get props => [];
}

class CategoryPageTopLoading extends CategoryPageState {
  @override
  List<Object?> get props => [];
}

class CategoryPageTopLoaded extends CategoryPageState {
  final CategoryPageTopData categoryPageTopData;

  CategoryPageTopLoaded({required this.categoryPageTopData});

  @override
  List<Object?> get props => [categoryPageTopData];
}

class CategoryPageTopLoadingError extends CategoryPageState {
  final String error;

  CategoryPageTopLoadingError({required this.error});

  @override
  List<Object?> get props => [error];
}
