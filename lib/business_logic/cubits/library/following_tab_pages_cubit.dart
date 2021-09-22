import 'package:bloc/bloc.dart';
import 'package:elf_play/config/enums.dart';

class FollowingTabPagesCubit extends Cubit<AppFollowedPageItemTypes> {
  FollowingTabPagesCubit() : super(AppFollowedPageItemTypes.ARTIST);

  changePage(AppFollowedPageItemTypes appFollowingPageItemTypes) {
    emit(appFollowingPageItemTypes);
  }
}
