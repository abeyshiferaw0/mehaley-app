import 'package:bloc/bloc.dart';
import 'package:elf_play/config/enums.dart';

class FavoriteTabPagesCubit extends Cubit<AppFavoritePageItemTypes> {
  FavoriteTabPagesCubit() : super(AppFavoritePageItemTypes.SONGS);

  changePage(AppFavoritePageItemTypes appFavoritePageItemTypes) {
    emit(appFavoritePageItemTypes);
  }
}
