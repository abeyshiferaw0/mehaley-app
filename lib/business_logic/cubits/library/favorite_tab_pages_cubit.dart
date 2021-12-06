import 'package:bloc/bloc.dart';
import 'package:mehaley/data/models/enums/enums.dart';

class FavoriteTabPagesCubit extends Cubit<AppFavoritePageItemTypes> {
  FavoriteTabPagesCubit() : super(AppFavoritePageItemTypes.SONGS);

  changePage(AppFavoritePageItemTypes appFavoritePageItemTypes) {
    emit(appFavoritePageItemTypes);
  }
}
