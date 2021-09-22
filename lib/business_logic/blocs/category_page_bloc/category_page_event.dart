part of 'category_page_bloc.dart';

@immutable
abstract class CategoryPageEvent extends Equatable {}

class LoadCategoryPageTopEvent extends CategoryPageEvent {
  final int categoryId;

  LoadCategoryPageTopEvent({required this.categoryId});

  @override
  List<Object?> get props => [];
}
