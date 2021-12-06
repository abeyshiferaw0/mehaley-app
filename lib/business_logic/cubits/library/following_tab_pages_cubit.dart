import 'package:bloc/bloc.dart';
import 'package:mehaley/data/models/enums/enums.dart';

class FollowingTabPagesCubit extends Cubit<AppFollowedPageItemTypes> {
  FollowingTabPagesCubit() : super(AppFollowedPageItemTypes.ARTIST);

  changePage(AppFollowedPageItemTypes appFollowingPageItemTypes) {
    emit(appFollowingPageItemTypes);
  }
}
